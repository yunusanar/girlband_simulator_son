// Öğrenci No: 202313171033
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import 'song_manager.dart';
import 'group_manager.dart';
import 'ledger.dart';

/// Aylık eğitim motoru. game_clock.advanceMonth içinden çağrılır.
/// - Tutulan her koçun maaşı bütçeden düşer (bütçe yetmezse koç işten ayrılır).
/// - Her koç, kendi disiplininde TÜM aktif idollere artış uygular.
/// - Artış farklıdır: kalan potansiyel boşluğu + yatkınlık + ruh hali belirler.
///   Böylece potansiyel hiç gösterilmeden, kimin büyümeye devam ettiğinden anlaşılır.
class TrainingManager {
  final AppDatabase db;
  TrainingManager(this.db);

  /// HER HAFTA çağrılır — sadece GELİŞİM (eğitim). Para/maaş yok.
  /// Tutulan koçlar tüm aktif idolleri eğitir; yorgunluk/moral haftalık işler.
  /// Bu ayki toplam gelişimi döndürür.
  Future<int> runWeeklyTraining(int careerId) async {
    int totalGain = 0;

    final hiredCoaches = await (db.select(db.coaches)
          ..where((c) => c.careerId.equals(careerId) & c.isHired.equals(true)))
        .get();

    final rows = await (db.select(db.playerIdols).join([
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId))
    ])..where(db.playerIdols.careerId.equals(careerId) &
            db.playerIdols.status.equals('active')))
        .get();
    final idols = rows
        .map((r) => (
              idol: r.readTable(db.playerIdols),
              char: r.readTable(db.generatedCharacters),
            ))
        .toList();
    if (idols.isEmpty) return 0;

    final Map<int, _IdolDelta> deltas = {};
    _IdolDelta deltaFor(int idolId) =>
        deltas.putIfAbsent(idolId, () => _IdolDelta());

    // Koçlar eğitir (maaş YOK — maaş aylık ödenir)
    for (final coach in hiredCoaches) {
      for (final e in idols) {
        final gain = _computeGain(coach, e.idol, e.char);
        if (gain <= 0) continue;
        final d = deltaFor(e.idol.id);
        switch (coach.discipline) {
          case 'vocal':
            d.vocal += gain;
            d.revealVocal = true;
            break;
          case 'dance':
            d.dance += gain;
            d.revealDance = true;
            break;
          case 'rap':
            d.rap += gain;
            d.revealRap = true;
            break;
        }
        d.fatigue += 3; // haftalık eğitim yorgunluğu
        totalGain += gain;
      }
    }

    // Haftalık dinlenme (-3) + eğitim yorgunluğu + moral, sonra yaz
    for (final e in idols) {
      final d = deltas[e.idol.id];
      final idol = e.idol;
      int newFatigue = (idol.fatigue - 3 + (d?.fatigue ?? 0)).clamp(0, 100);
      final int newMood =
          _computeMood(idol.mood, newFatigue, e.char.neuroticism);

      if (d == null) {
        await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
            .write(PlayerIdolsCompanion(
          fatigue: Value(newFatigue),
          mood: Value(newMood),
        ));
        continue;
      }

      await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
          .write(PlayerIdolsCompanion(
        vocalBonus: Value(idol.vocalBonus + d.vocal),
        danceBonus: Value(idol.danceBonus + d.dance),
        rapBonus: Value(idol.rapBonus + d.rap),
        fatigue: Value(newFatigue),
        mood: Value(newMood),
      ));

      final reveal = GeneratedCharactersCompanion(
        isVocalRevealed:
            d.revealVocal ? const Value(true) : const Value.absent(),
        isDanceRevealed:
            d.revealDance ? const Value(true) : const Value.absent(),
        isRapRevealed: d.revealRap ? const Value(true) : const Value.absent(),
      );
      await (db.update(db.generatedCharacters)
            ..where((t) => t.id.equals(e.char.id)))
          .write(reveal);
    }

    return totalGain;
  }

  /// AY SINIRINDA çağrılır — GELİR + MAAŞLAR. Eğitim yok (o haftalık).
  Future<TrainingReport> runMonthlyEconomy(int careerId, int month) async {
    final report = TrainingReport();

    final wallet = await (db.select(db.currencyWallets)
          ..where((w) => w.careerId.equals(careerId)))
        .getSingleOrNull();
    if (wallet == null) return report;
    int balance = wallet.fanPoints;

    // --- GELİR: stream (debut sonrası) yoksa yayın (debut öncesi) ---
    final songMgr = SongManager(db);
    final streamIncome = await songMgr.computeMonthlyStreamIncome(careerId);
    if (streamIncome > 0) {
      balance += streamIncome;
      report.broadcastIncome = streamIncome;
      report.isStreamIncome = true;
      await Ledger.record(db, careerId, 'stream', 'Stream geliri', streamIncome);
    } else {
      final income = await _computeBroadcastIncome(careerId);
      balance += income;
      report.broadcastIncome = income;
      await Ledger.record(db, careerId, 'broadcast', 'Yayın geliri', income);
    }

    // --- GELİR: aktif sponsorluk (her ay sabit, süre dolunca biter) ---
    final group = await (db.select(db.groups)
          ..where((g) =>
              g.careerId.equals(careerId) & g.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
    if (group != null && group.sponsorMonthsLeft > 0) {
      balance += group.sponsorIncome;
      report.sponsorIncome = group.sponsorIncome;
      await Ledger.record(db, careerId, 'sponsor',
          'Sponsor: ${group.sponsorName ?? "marka"}', group.sponsorIncome);
      final left = group.sponsorMonthsLeft - 1;
      await (db.update(db.groups)..where((g) => g.id.equals(group.id))).write(
        GroupsCompanion(
          sponsorMonthsLeft: Value(left),
          // Anlaşma bitince sponsor temizlenir
          sponsorName: left <= 0 ? const Value(null) : Value(group.sponsorName),
          sponsorIncome: left <= 0 ? const Value(0) : Value(group.sponsorIncome),
          // Ticari imaj: küçük itibar maliyeti
          reputation: Value((group.reputation - 1).clamp(0, 100)),
        ),
      );
    }

    // --- GİDER: idol maaşları (sadece aktif gruptaki üyeler) ---
    final idolSalary = await songMgr.computeIdolSalaries(careerId);
    if (idolSalary > 0) {
      if (balance >= idolSalary) {
        balance -= idolSalary;
        report.idolSalaryPaid = idolSalary;
      } else {
        report.idolSalaryPaid = balance;
        report.idolSalaryDebt = idolSalary - balance;
        balance = 0;
      }
      if (report.idolSalaryPaid > 0) {
        await Ledger.record(db, careerId, 'salary_idol', 'İdol maaşları',
            -report.idolSalaryPaid);
      }
    }

    // --- GİDER: koç maaşları (prestij vergisiyle ölçeklenir) ---
    final costMult = group == null
        ? 1.0
        : GroupManager.costMultiplierFor(
            group.socialFollowers, group.totalPopularity);
    final hiredCoaches = await (db.select(db.coaches)
          ..where((c) => c.careerId.equals(careerId) & c.isHired.equals(true)))
        .get();
    for (final coach in hiredCoaches) {
      final salary = (coach.monthlySalary * costMult).round();
      if (balance < salary) {
        await (db.update(db.coaches)..where((c) => c.id.equals(coach.id)))
            .write(const CoachesCompanion(isHired: Value(false)));
        report.quitCoaches.add(coach.name);
        continue;
      }
      balance -= salary;
      report.totalSalaryPaid += salary;
    }
    if (report.totalSalaryPaid > 0) {
      await Ledger.record(db, careerId, 'salary_coach', 'Koç maaşları',
          -report.totalSalaryPaid);
    }

    await (db.update(db.currencyWallets)
          ..where((w) => w.careerId.equals(careerId)))
        .write(CurrencyWalletsCompanion(fanPoints: Value(balance)));
    report.endingBalance = balance;
    return report;
  }

  /// Yayın geliri (DEBÜT ÖNCESİ) — mütevazı ve SABİT banda çekildi.
  /// Bilinçli olarak tüm koçları karşılamaz → koç seçimi stratejik bir karar.
  /// Şöhret artık pre-debüt parayı KATLAMAZ (snowball kaldırıldı); şöhret
  /// post-debüt takipçi/star power olarak işe yarar.
  Future<int> _computeBroadcastIncome(int careerId) async {
    const int baseBroadcast = 800;
    const int perHighGrade = 35;
    const int ratingsCap = 700; // reyting bonusu tavanı düşük
    const int highGradeThreshold = 78; // auditionScore eşiği

    final highGrade = await (db.select(db.generatedCharacters)
          ..where((t) =>
              t.careerId.equals(careerId) &
              t.auditionScore.isBiggerOrEqualValue(highGradeThreshold)))
        .get();

    int bonus = highGrade.length * perHighGrade;
    if (bonus > ratingsCap) bonus = ratingsCap;

    return baseBroadcast + bonus; // ~800..1500₺/ay
  }

  /// Yorgunluk ve nevrotikliğe göre yeni ruh hali (0..100). HAFTALIK ölçek.
  int _computeMood(int mood, int fatigue, int neuroticism) {
    int delta;
    if (fatigue >= 70) {
      delta = -3; // aşırı çalışma
    } else if (fatigue <= 35) {
      delta = 2; // dinlenmiş ve mutlu
    } else {
      delta = 1;
    }
    // Nevrotiklik: negatif kayışı büyütür, pozitif toparlanmayı yavaşlatır
    if (delta < 0) {
      delta = (delta * (1 + neuroticism / 100.0)).round();
    } else {
      delta = (delta * (1 - neuroticism / 250.0)).round();
    }
    return (mood + delta).clamp(0, 100);
  }

  /// Tek bir koçun tek bir idole bu ay vereceği artış.
  int _computeGain(Coach coach, PlayerIdol idol, GeneratedCharacter char) {
    final int base;
    final int bonus;
    final int potential;
    switch (coach.discipline) {
      case 'vocal':
        base = char.vocalSkill;
        bonus = idol.vocalBonus;
        potential = char.vocalPotential;
        break;
      case 'dance':
        base = char.danceSkill;
        bonus = idol.danceBonus;
        potential = char.dancePotential;
        break;
      case 'rap':
      default:
        base = char.rapSkill;
        bonus = idol.rapBonus;
        potential = char.rapPotential;
        break;
    }

    final int current = base + bonus;
    final int room = potential - current;
    if (room <= 0) return 0; // tavan → plato (büyüme durur, fark burada görünür)

    // Azalan verim: tavana yakınken küçülür (0.15..1.0)
    final double diminishing = (room / 50).clamp(0.15, 1.0);
    // Yatkınlık: birincil disiplinde daha hızlı öğrenir
    final double affinity = (char.primaryDiscipline == coach.discipline) ? 1.3 : 1.0;
    // Ruh hali ve yorgunluk öğrenmeyi etkiler
    final double moodF = idol.mood / 100.0;
    final double fatigueF = (100 - idol.fatigue) / 100.0;
    // BIG5 — Özdisiplin: disiplinli idoller daha verimli çalışır (0.8x..1.2x)
    final double conscF = 0.8 + char.conscientiousness / 250.0;

    double raw = coach.quality * affinity * diminishing * moodF * fatigueF * conscF;
    int gain = raw.round();

    // Oda varsa en az 1 ilerlesin (yavaş da olsa kıpırdasın), ama tavanı aşma
    if (gain < 1 && room > 0 && moodF > 0.2) gain = 1;
    if (gain > room) gain = room;
    return gain;
  }

  static const int vacationCost = 2000;

  /// HAFTALIK PROGRAM: her üyenin o haftaki aktivitesini uygular.
  /// activities: idolId → 'practice'|'rest'|'variety'|'fan' (varsayılan practice).
  /// Bireysel etkiler üyeye, grup etkileri (takipçi/pop/fandom) gruba işlenir.
  Future<void> applyWeeklyActivities(
      int careerId, Map<int, String> activities) async {
    final group = await GroupManager(db).getActiveGroup(careerId);
    if (group == null) return;
    final members = await (db.select(db.groupMembers)
          ..where((t) =>
              t.groupId.equals(group.id) & t.leaveMonth.isNull()))
        .get();

    int addFollowers = 0, addPop = 0, addFandom = 0;
    for (final m in members) {
      final idol = await (db.select(db.playerIdols)
            ..where((t) => t.id.equals(m.idolId)))
          .getSingleOrNull();
      if (idol == null) continue;
      final act = activities[m.idolId] ?? 'practice';
      var vb = idol.vocalBonus,
          db_ = idol.danceBonus,
          rb = idol.rapBonus,
          mood = idol.mood,
          fat = idol.fatigue,
          pop = idol.popularityBonus;
      switch (act) {
        case 'rest':
          fat = (fat - 25).clamp(0, 100);
          mood = (mood + 12).clamp(0, 100);
          break;
        case 'variety':
          pop += 3;
          mood = (mood + 3).clamp(0, 100);
          fat = (fat + 8).clamp(0, 100);
          addFollowers += 6000;
          addPop += 15000;
          break;
        case 'fan':
          mood = (mood + 7).clamp(0, 100);
          fat = (fat + 6).clamp(0, 100);
          addFollowers += 3000;
          addFandom += 3;
          break;
        default: // practice
          vb += 2;
          db_ += 2;
          rb += 2;
          fat = (fat + 11).clamp(0, 100);
      }
      await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
          .write(PlayerIdolsCompanion(
        vocalBonus: Value(vb),
        danceBonus: Value(db_),
        rapBonus: Value(rb),
        mood: Value(mood),
        fatigue: Value(fat),
        popularityBonus: Value(pop),
      ));
    }
    if (addFollowers != 0 || addPop != 0 || addFandom != 0) {
      await (db.update(db.groups)..where((t) => t.id.equals(group.id))).write(
        GroupsCompanion(
          socialFollowers: Value(group.socialFollowers + addFollowers),
          totalPopularity: Value(group.totalPopularity + addPop),
          fandomLoyalty: Value((group.fandomLoyalty + addFandom).clamp(0, 100)),
        ),
      );
    }
  }

  /// Tek bir üyeyle BİREBİR ilgilenme. type: 'chat' (sohbet), 'gift' (hediye),
  /// 'rest' (kişisel mola). Parayla o üyenin moralini/sadakatini/yorgunluğunu
  /// iyileştirir; maliyet prestijle ölçeklenir. (ok, message) döner.
  Future<({bool ok, String message})> careForIdol(
      int careerId, int idolId, String type) async {
    final mult = await GroupManager(db).currentCostMultiplier(careerId);
    final baseCost = switch (type) {
      'gift' => 4000,
      'rest' => 3000,
      _ => 1500, // chat
    };
    final cost = (baseCost * mult).round();
    final w = await (db.select(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    if (w == null || w.fanPoints < cost) {
      return (ok: false, message: 'Yetersiz bütçe (gerekli: $cost₺).');
    }
    final idol = await (db.select(db.playerIdols)
          ..where((t) => t.id.equals(idolId)))
        .getSingleOrNull();
    if (idol == null) return (ok: false, message: 'Üye bulunamadı.');

    await (db.update(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .write(CurrencyWalletsCompanion(
            fanPoints: Value((w.fanPoints - cost).clamp(0, 1 << 31))));

    int moodAdd = 10, loyaltyAdd = 2, fatigueAdd = 0;
    String label = 'Birebir sohbet';
    if (type == 'gift') {
      moodAdd = 20;
      loyaltyAdd = 8;
      label = 'Hediye';
    } else if (type == 'rest') {
      moodAdd = 8;
      fatigueAdd = -35;
      label = 'Kişisel mola';
    }
    await (db.update(db.playerIdols)..where((t) => t.id.equals(idolId)))
        .write(PlayerIdolsCompanion(
      mood: Value((idol.mood + moodAdd).clamp(0, 100)),
      loyalty: Value((idol.loyalty + loyaltyAdd).clamp(0, 100)),
      fatigue: Value((idol.fatigue + fatigueAdd).clamp(0, 100)),
    ));
    await Ledger.record(db, careerId, 'care', '$label (üye ilgisi)', -cost);
    return (ok: true, message: '$label yapıldı! Üyenin morali yükseldi.');
  }

  /// Tatil/Mola: parayla tüm aktif idollerin yorgunluğunu düşürür, moralini
  /// ve sadakatini toparlar. (ok, reason) döner.
  Future<({bool ok, String reason})> giveVacation(int careerId) async {
    final w = await (db.select(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    final mult = await GroupManager(db).currentCostMultiplier(careerId);
    final cost = (vacationCost * mult).round();
    if (w == null || w.fanPoints < cost) {
      return (ok: false, reason: 'Yetersiz bütçe (gerekli: $cost₺).');
    }
    await (db.update(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .write(CurrencyWalletsCompanion(
            fanPoints: Value(w.fanPoints - cost)));
    await Ledger.record(db, careerId, 'vacation', 'Tatil/mola', -cost);

    final idols = await (db.select(db.playerIdols)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active')))
        .get();
    for (final idol in idols) {
      await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
          .write(PlayerIdolsCompanion(
        fatigue: Value((idol.fatigue - 50).clamp(0, 100)),
        mood: Value((idol.mood + 15).clamp(0, 100)),
        loyalty: Value((idol.loyalty + 3).clamp(0, 100)),
      ));
    }
    return (ok: true, reason: '');
  }
}

class _IdolDelta {
  int vocal = 0;
  int dance = 0;
  int rap = 0;
  int fatigue = 0;
  bool revealVocal = false;
  bool revealDance = false;
  bool revealRap = false;
}

class TrainingReport {
  bool isNewMonth = false; // bu tik ay sınırı mı (ekonomi işledi mi)
  int broadcastIncome = 0;
  bool isStreamIncome = false;
  int totalSalaryPaid = 0;  // koç maaşı
  int idolSalaryPaid = 0;   // idol maaşı (ödenen kısım)
  int idolSalaryDebt = 0;   // idol maaşı (ödenemeyen kısım → çöküş tetikler)
  bool groupDisbanded = false;
  int totalGain = 0;
  int endingBalance = 0;
  List<String> quitCoaches = [];
  // Olay motoru çıktısı
  List<String> eventHeadlines = [];
  int pendingDecisions = 0;
  List<String> departedMembers = [];
  // Yıl sonu ödülü
  bool awardWon = false;
  String awardTitle = '';
  // Yüksek skandal baskısı uygulandı mı (>=80)
  bool scandalPressure = false;
  // Zafer: rakibi geçtin + ödül kazandın → kariyeri taçlandırma teklifi
  bool victoryAvailable = false;
  // Yeni açılan başarımlar (başlıklar)
  List<String> newAchievements = [];
  // Yeni açılan GENEL (kalıcı) başarımlar + ana hedef tamamlandı mı
  List<String> newGlobalAchievements = [];
  bool careerGoalReached = false;
  // Bu ay sponsordan gelen gelir
  int sponsorIncome = 0;
  // Ay sonu garip ödülü (varsa) ve gazete manşeti (varsa)
  String? monthlyAward;
  String? newspaperHeadline;
  // Bu haftaki takipçi değişimi (+/-)
  int followerDelta = 0;
  // Morali 20'nin altına düşen üyeler (uyarı popup'ı)
  List<String> lowMoraleWarnings = [];
}
