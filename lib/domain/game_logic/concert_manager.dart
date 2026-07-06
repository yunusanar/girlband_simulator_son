// Öğrenci No: 202313171033
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import 'group_manager.dart';
import 'global_achievement_manager.dart';
import 'ledger.dart';

/// Konser ve tur sistemi.
///
/// Açılış koşulu (herhangi biri):
///   • En az 3 "hit" şarkı (zirve pozisyonu ≤ 10)
///   • Popülarite ≥ 500.000
///   • Takipçi ≥ 500.000
///
/// Konser: aylık yapılabilir, orta gelir + moral.
/// Tur: 3 ay cooldown, büyük gelir + büyük popülarite ama yüksek yorgunluk.
class ConcertManager {
  final AppDatabase db;
  ConcertManager(this.db);

  static const int followerThreshold = 500000;
  static const int hitSongsRequired = 5;
  static const int hitChartPosition = 10;
  static const int tourCooldown = 3; // ay

  // Konser boyutları: küçük=güvenli az gelir, büyük=çok gelir+yorgunluk+koşul
  static const List<ConcertSize> concertSizes = [
    ConcertSize(
        key: 'kulup',
        label: 'Kulüp Sahnesi',
        emoji: '🎵',
        incomeMult: 0.55,
        popMult: 0.5,
        fatigue: 8,
        followerGate: 0,
        cost: 3000,
        blurb: 'Küçük mekan. Az gider/gelir, güvenli başlangıç.'),
    ConcertSize(
        key: 'salon',
        label: 'Salon Konseri',
        emoji: '🎤',
        incomeMult: 1.0,
        popMult: 1.0,
        fatigue: 13,
        followerGate: 150000,
        cost: 14000,
        blurb: 'Orta ölçek (150K takipçi). Gider yüksek; itibar düşükse zarar edebilirsin.'),
    ConcertSize(
        key: 'arena',
        label: 'Arena Şovu',
        emoji: '🏟️',
        incomeMult: 2.0,
        popMult: 1.8,
        fatigue: 22,
        followerGate: 1000000,
        cost: 60000,
        blurb: 'Dev prodüksiyon (1M takipçi). Büyük gider; sadece büyük gruplar kâr eder.'),
  ];

  // ── Uygunluk ────────────────────────────────────────────────────────────────
  Future<ConcertEligibility> checkEligibility(int careerId) async {
    final group = await _activeGroup(careerId);
    if (group == null) {
      return const ConcertEligibility(
          unlocked: false,
          hitSongs: 0,
          popularity: 0,
          followers: 0,
          reason: 'Önce bir grup kur.');
    }

    final hits = await _hitSongCount(group.id);
    final unlocked =
        hits >= hitSongsRequired || group.socialFollowers >= followerThreshold;

    return ConcertEligibility(
      unlocked: unlocked,
      hitSongs: hits,
      popularity: group.totalPopularity,
      followers: group.socialFollowers,
      reason: unlocked
          ? 'Sahneye çıkmaya hazırsın!'
          : 'Açılış için: $hitSongsRequired hit şarkı VEYA 500K takipçi gerekiyor.',
    );
  }

  // ── Konser ──────────────────────────────────────────────────────────────────
  Future<ConcertResult> holdConcert(int careerId, int month,
      {ConcertSize? size}) async {
    final sz = size ?? concertSizes[1]; // varsayılan: salon
    final group = await _activeGroup(careerId);
    if (group == null) {
      return const ConcertResult(success: false, message: 'Grup yok.');
    }
    final elig = await checkEligibility(careerId);
    if (!elig.unlocked) {
      return ConcertResult(success: false, message: elig.reason);
    }
    if (group.lastConcertMonth != null && month <= group.lastConcertMonth!) {
      return const ConcertResult(
          success: false, message: 'Bu ay zaten konser verdin. Gelecek ay tekrar dene.');
    }
    if (group.socialFollowers < sz.followerGate) {
      return ConcertResult(
          success: false,
          message:
              '${sz.label} için en az ${sz.followerGate ~/ 1000}K takipçi gerekiyor.');
    }

    // Prodüksiyon gideri prestijle artar (yumuşatılmış: gelir tavanını geçmesin)
    final rawMult = GroupManager.costMultiplierFor(
        group.socialFollowers, group.totalPopularity);
    final costMult = 1 + (rawMult - 1) * 0.6;
    final prodCost = (sz.cost * costMult).round();

    // BÜTÇE ŞARTI: prodüksiyon gideri peşin ödenir, karşılayamıyorsan konser yok
    final wallet = await _walletBalance(careerId);
    if (wallet < prodCost) {
      return ConcertResult(
          success: false,
          message:
              '${sz.label} için $prodCost₺ prodüksiyon gideri gerekiyor (kasanda $wallet₺ var).');
    }

    final repMult = 0.7 + group.reputation / 150.0;
    // Fandom sadakati bilet gelirini etkiler (0.7 → 1.37)
    final fanMult = 0.7 + group.fandomLoyalty / 150.0;
    // Skandal bilet satışını vurur: yüksek skandal → boş koltuklar
    final scandalMult = group.scandalHeat >= 80
        ? 0.45
        : group.scandalHeat >= 50
            ? 0.7
            : 1.0;
    int gross = (1000 +
            group.socialFollowers * 0.05 +
            group.totalPopularity * 0.0025)
        .round();
    gross = (gross * repMult * fanMult * scandalMult * sz.incomeMult)
        .round()
        .clamp(0, 700000);
    final net = gross - prodCost;

    // Popülarite kazancı rakibe yaklaştıkça azalır
    final factor = await GroupManager(db).currentPopGainFactor(careerId);
    final popGain = (40000 * factor * sz.popMult).round();
    final followerGain = (5000 * sz.popMult).round();

    // Önce gider PEŞİN düşer, sonra bilet hasılatı eklenir (gider görünür çıksın)
    await _addMoney(careerId, -prodCost);
    await _addMoney(careerId, gross);
    await Ledger.record(db, careerId, 'concert', '${sz.label} hasılatı', gross);
    await Ledger.record(db, careerId, 'concert', '${sz.label} gideri', -prodCost);
    await (db.update(db.groups)..where((t) => t.id.equals(group.id))).write(
      GroupsCompanion(
        totalPopularity: Value(group.totalPopularity + popGain),
        socialFollowers: Value(group.socialFollowers + followerGain),
        reputation: Value((group.reputation + 3).clamp(0, 100)),
        fandomLoyalty: Value((group.fandomLoyalty + 4).clamp(0, 100)),
        lastConcertMonth: Value(month),
      ),
    );
    await _adjustMembers(group.id, mood: 5, loyalty: 1, fatigue: sz.fatigue);

    final netStr = net >= 0 ? '+$net₺' : '$net₺ (ZARAR)';
    final dispMonth = ((month - 1) % 12) + 1;
    await _logEvent(careerId, group.id, dispMonth, 'concert',
        '${sz.label} Verildi! ${sz.emoji}',
        'Hasılat $gross₺ - Gider $prodCost₺ = Net $netStr. Erişim +${_fmt(popGain)}');

    return ConcertResult(
        success: true,
        income: net,
        message: net >= 0
            ? '${sz.label} başarılı! Net +$net₺ (hasılat $gross₺ - gider $prodCost₺) • Erişim +${_fmt(popGain)}'
            : '${sz.label} ZARAR etti! Net $net₺ (hasılat $gross₺ < gider $prodCost₺). İtibar/skandal gelirini düşürdü.');
  }

  // Tur planları: şehir sayısına göre gelir/gider/yorgunluk ölçeklenir
  static const List<TourPlan> tourPlans = [
    TourPlan(
        key: 'mini',
        label: 'Mini Tur',
        emoji: '🚐',
        cities: 3,
        cost: 30000,
        fatigue: 24,
        followerGate: 0,
        blurb: '3 şehir. Mütevazı gelir, daha az yorgunluk.'),
    TourPlan(
        key: 'ulusal',
        label: 'Ulusal Tur',
        emoji: '🚌',
        cities: 5,
        cost: 60000,
        fatigue: 34,
        followerGate: 400000,
        blurb: '5 şehir (400K takipçi). Büyük gelir, yüksek yorgunluk.'),
    TourPlan(
        key: 'dunya',
        label: 'Dünya Turu',
        emoji: '✈️',
        cities: 8,
        cost: 130000,
        fatigue: 48,
        followerGate: 1200000,
        blurb: '8 şehir (1.2M takipçi). Devasa gelir ama ekip bitkin düşer.'),
  ];

  // ── Tur ───────────────────────────────────────────────────────────────────
  Future<ConcertResult> holdTour(int careerId, int month,
      {TourPlan? plan}) async {
    final tp = plan ?? tourPlans[0];
    final group = await _activeGroup(careerId);
    if (group == null) {
      return const ConcertResult(success: false, message: 'Grup yok.');
    }
    final elig = await checkEligibility(careerId);
    if (!elig.unlocked) {
      return ConcertResult(success: false, message: elig.reason);
    }
    if (group.lastTourMonth != null &&
        month - group.lastTourMonth! < tourCooldown) {
      final remaining = tourCooldown - (month - group.lastTourMonth!);
      return ConcertResult(
          success: false,
          message: 'Tur ekibi dinleniyor. $remaining ay sonra tekrar.');
    }
    if (group.socialFollowers < tp.followerGate) {
      return ConcertResult(
          success: false,
          message:
              '${tp.label} için en az ${tp.followerGate ~/ 1000}K takipçi gerekiyor.');
    }

    final rawMult = GroupManager.costMultiplierFor(
        group.socialFollowers, group.totalPopularity);
    final costMult = 1 + (rawMult - 1) * 0.6;
    final prodCost = (tp.cost * costMult).round();

    // BÜTÇE ŞARTI: tur prodüksiyonu peşin ödenir
    final wallet = await _walletBalance(careerId);
    if (wallet < prodCost) {
      return ConcertResult(
          success: false,
          message:
              '${tp.label} için $prodCost₺ prodüksiyon gideri gerekiyor (kasanda $wallet₺ var).');
    }

    final repMult = 0.7 + group.reputation / 150.0;
    final fanMult = 0.7 + group.fandomLoyalty / 150.0;
    final scandalMult = group.scandalHeat >= 80
        ? 0.45
        : group.scandalHeat >= 50
            ? 0.7
            : 1.0;
    // Şehir başına hasılat
    int perCity = (2500 +
            group.socialFollowers * 0.04 +
            group.totalPopularity * 0.0025)
        .round();
    int gross = (perCity * tp.cities * repMult * fanMult * scandalMult)
        .round()
        .clamp(0, 1800000);
    final net = gross - prodCost;

    final factor = await GroupManager(db).currentPopGainFactor(careerId);
    final popGain = (45000 * tp.cities * factor).round();
    final followerGain = (6000 * tp.cities).round();

    // Gider peşin düşer, sonra hasılat eklenir
    await _addMoney(careerId, -prodCost);
    await _addMoney(careerId, gross);
    await Ledger.record(db, careerId, 'tour', '${tp.label} hasılatı', gross);
    await Ledger.record(db, careerId, 'tour', '${tp.label} gideri', -prodCost);
    if (tp.key == 'dunya') {
      await GlobalAchievementManager(db).unlock('world_tour');
    }
    await (db.update(db.groups)..where((t) => t.id.equals(group.id))).write(
      GroupsCompanion(
        totalPopularity: Value(group.totalPopularity + popGain),
        socialFollowers: Value(group.socialFollowers + followerGain),
        reputation: Value((group.reputation + 6).clamp(0, 100)),
        fandomLoyalty: Value((group.fandomLoyalty + 8).clamp(0, 100)),
        lastTourMonth: Value(month),
      ),
    );
    // Tur yorucudur: yüksek fatigue, hafif moral düşüşü ama sadakat artışı
    await _adjustMembers(group.id, mood: -2, loyalty: 4, fatigue: tp.fatigue);

    final netStr = net >= 0 ? '+$net₺' : '$net₺ (ZARAR)';
    final dispMonth = ((month - 1) % 12) + 1;
    await _logEvent(careerId, group.id, dispMonth, 'tour',
        '${tp.label} Tamamlandı! ${tp.emoji}',
        '${tp.cities} şehir gezdiniz. Hasılat $gross₺ - Gider $prodCost₺ = Net $netStr. Erişim +${_fmt(popGain)}.');

    return ConcertResult(
        success: true,
        income: net,
        message: net >= 0
            ? '${tp.label} (${tp.cities} şehir) muhteşemdi! Net +$net₺ • Erişim +${_fmt(popGain)}'
            : '${tp.label} ZARAR etti! Net $net₺ (hasılat $gross₺ < gider $prodCost₺).');
  }

  // ── Yardımcılar ─────────────────────────────────────────────────────────────
  Future<Group?> _activeGroup(int careerId) {
    return (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> _hitSongCount(int groupId) async {
    final songs = await (db.select(db.songs)
          ..where((t) =>
              t.groupId.equals(groupId) &
              t.peakChartPosition.isSmallerOrEqualValue(hitChartPosition)))
        .get();
    return songs.length;
  }

  Future<int> _walletBalance(int careerId) async {
    final w = await (db.select(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    return w?.fanPoints ?? 0;
  }

  Future<void> _addMoney(int careerId, int amount) async {
    final w = await (db.select(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    if (w == null) return;
    await (db.update(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .write(CurrencyWalletsCompanion(
            fanPoints: Value((w.fanPoints + amount).clamp(0, 1 << 31))));
  }

  Future<void> _adjustMembers(int groupId,
      {int mood = 0, int loyalty = 0, int fatigue = 0}) async {
    final members = await (db.select(db.groupMembers)
          ..where((t) => t.groupId.equals(groupId) & t.leaveMonth.isNull()))
        .get();
    for (final m in members) {
      final idol = await (db.select(db.playerIdols)
            ..where((t) => t.id.equals(m.idolId)))
          .getSingleOrNull();
      if (idol == null) continue;
      await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
          .write(PlayerIdolsCompanion(
        mood: Value((idol.mood + mood).clamp(0, 100)),
        loyalty: Value((idol.loyalty + loyalty).clamp(0, 100)),
        fatigue: Value((idol.fatigue + fatigue).clamp(0, 100)),
      ));
    }
  }

  Future<void> _logEvent(int careerId, int groupId, int month, String type,
      String title, String desc) async {
    await db.into(db.events).insert(EventsCompanion.insert(
          careerId: careerId,
          groupId: Value(groupId),
          eventType: type,
          category: const Value('pr'),
          title: title,
          description: Value(desc),
          monthOccurred: month,
          resolved: const Value(true),
        ));
  }
}

class ConcertSize {
  final String key;
  final String label;
  final String emoji;
  final double incomeMult;
  final double popMult;
  final int fatigue;
  final int followerGate;
  final int cost; // sahne/prodüksiyon gideri
  final String blurb;
  const ConcertSize({
    required this.key,
    required this.label,
    required this.emoji,
    required this.incomeMult,
    required this.popMult,
    required this.fatigue,
    required this.followerGate,
    required this.cost,
    required this.blurb,
  });
}

class TourPlan {
  final String key;
  final String label;
  final String emoji;
  final int cities;
  final int cost;
  final int fatigue;
  final int followerGate;
  final String blurb;
  const TourPlan({
    required this.key,
    required this.label,
    required this.emoji,
    required this.cities,
    required this.cost,
    required this.fatigue,
    required this.followerGate,
    required this.blurb,
  });
}

class ConcertEligibility {
  final bool unlocked;
  final int hitSongs;
  final int popularity;
  final int followers;
  final String reason;
  const ConcertEligibility({
    required this.unlocked,
    required this.hitSongs,
    required this.popularity,
    required this.followers,
    required this.reason,
  });
}

class ConcertResult {
  final bool success;
  final int income;
  final String message;
  const ConcertResult(
      {required this.success, this.income = 0, required this.message});
}

String _fmt(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
  return '$n';
}
