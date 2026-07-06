// Öğrenci No: 202313171033
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';
import 'character_generator.dart';
import 'training_manager.dart';
import 'chemistry_calculator.dart';
import 'group_manager.dart';
import 'song_manager.dart';
import 'event_engine.dart';
import 'achievement_manager.dart';
import 'global_achievement_manager.dart';
import 'social_manager.dart';

final gameClockProvider = Provider<GameClock>((ref) {
  return GameClock(ref.watch(databaseProvider));
});

class GameClock {
  final AppDatabase db;
  late final CharacterGenerator _generator;
  late final TrainingManager _training;
  late final ChemistryCalculator _chemistry;
  late final GroupManager _group;
  late final SongManager _songs;
  late final EventEngine _events;
  late final AchievementManager _achievements;
  late final GlobalAchievementManager _globalAch;
  late final SocialManager _social;
  final Random _random = Random();

  static const int monthlyTraineeCount = 5;
  static const int startingCapital = 6000; // başlangıç sermayesi

  GameClock(this.db) {
    _generator = CharacterGenerator(db);
    _training = TrainingManager(db);
    _chemistry = ChemistryCalculator(db);
    _group = GroupManager(db);
    _songs = SongManager(db);
    _events = EventEngine(db);
    _achievements = AchievementManager(db);
    _globalAch = GlobalAchievementManager(db);
    _social = SocialManager(db);
  }

  Future<int> startNewCareer(
      {String agencyName = 'Yıldız Ajans',
      int budget = startingCapital,
      String difficulty = 'medium'}) async {
    // Aktif kariyer(ler)i önce arşivle, sonra kapat
    final actives = await (db.select(db.playerCareers)
          ..where((t) => t.status.equals('active')))
        .get();
    for (final a in actives) {
      await _group.archiveCareer(a.id);
    }
    await (db.update(db.playerCareers)..where((t) => t.status.equals('active')))
        .write(const PlayerCareersCompanion(status: Value('ended')));

    final lastCareer = await (db.select(db.playerCareers)
          ..orderBy([(t) => OrderingTerm.desc(t.careerNumber)])
          ..limit(1))
        .getSingleOrNull();
    final int nextNumber = (lastCareer?.careerNumber ?? 0) + 1;

    final cleanName =
        agencyName.trim().isEmpty ? 'Yıldız Ajans' : agencyName.trim();
    final newCareerId = await db.into(db.playerCareers).insert(
          PlayerCareersCompanion.insert(
            careerNumber: nextNumber,
            agencyName: Value(cleanName),
            startedAt: DateTime.now(),
            status: const Value('active'),
            difficulty: Value(difficulty),
          ),
        );

    // Başlangıç sermayesi (zorluk seçimine göre)
    await db.into(db.currencyWallets).insert(
          CurrencyWalletsCompanion.insert(
            careerId: newCareerId,
            fanPoints: Value(budget),
          ),
        );

    // Stajyer kadrosu + paket havuzu + koç havuzu
    await _generator.generateRosterForCareer(newCareerId);

    return newCareerId;
  }

  /// Kariyeri gönüllü olarak (zaferle) bitirir: arşivler + 'ended' yapar.
  Future<void> endCareer(int careerId) async {
    await _group.archiveCareer(careerId);
    await (db.update(db.playerCareers)..where((t) => t.id.equals(careerId)))
        .write(const PlayerCareersCompanion(status: Value('ended')));
  }

  Future<PlayerCareer?> getActiveCareer() async {
    return await (db.select(db.playerCareers)
          ..where((t) => t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Bir HAFTA ilerletir.
  /// - Her hafta: chart ilerlemesi + olaylar (grup varsa).
  /// - Ay sınırında (her 4. hafta): eğitim, maaş, gelir, kimya, popülarite,
  ///   sezon hesabı, borç/çöküş kontrolü.
  /// Eğitim/olay özetini döndürür.
  Future<TrainingReport> advanceWeek(PlayerCareer currentCareer) async {
    int nextWeek = currentCareer.currentWeek + 1;
    int nextMonth = currentCareer.currentMonth;
    int nextYear = currentCareer.currentYear;
    bool isNewMonth = false;
    if (nextWeek > 4) {
      nextWeek = 1;
      isNewMonth = true;
      nextMonth += 1;
      if (nextMonth > 12) {
        nextMonth = 1;
        nextYear += 1;
      }
    }

    final report = TrainingReport();
    report.isNewMonth = isNewMonth;

    // Hafta başı takipçi sayısı (haftalık +/- değişimi için)
    final startGroup = await _group.getActiveGroup(currentCareer.id);
    final startFollowers = startGroup?.socialFollowers ?? 0;

    // ── HER HAFTA: GELİŞİM (eğitim) ──
    report.totalGain = await _training.runWeeklyTraining(currentCareer.id);

    // ── AY SINIRI: ekonomi (gelir+maaş), kimya, popülarite ──
    if (isNewMonth) {
      final eco =
          await _training.runMonthlyEconomy(currentCareer.id, nextMonth);
      _copyMonthlyInto(report, eco);

      await _chemistry.updateMonthlyChemistry(currentCareer.id, nextMonth);

      if (report.idolSalaryDebt > 0) {
        report.groupDisbanded = await _group.handleDebtAndCheckDisband(
            currentCareer.id, nextMonth);
      }

      if (!report.groupDisbanded) {
        // Önce bireysel şöhret + iç rekabet, sonra trajektori (star power için)
        await _group.updateMemberPopularityAndRivalry(
            currentCareer.id, nextMonth);
        final songBonus =
            await _songs.computeMonthlySongPopBonus(currentCareer.id);
        await _group.advanceGroupTrajectory(currentCareer.id, nextMonth,
            songBonus: songBonus);

        // Yıl sonu (yeni yıla geçildi) → ödül töreni
        if (nextMonth == 1) {
          final award =
              await _group.runYearEndAwards(currentCareer.id, nextMonth, nextYear);
          report.awardWon = award.won;
          report.awardTitle = award.title;

          // Zafer: ödül kazandın VE rakibi geçtin → kariyeri taçlandırma teklifi
          if (award.won) {
            final g = await _group.getActiveGroup(currentCareer.id);
            final rival = await _group
                .rivalStatusAt((nextYear - 1) * 12 + nextMonth);
            if (g != null && g.totalPopularity >= rival.popularity) {
              report.victoryAvailable = true;
            }
          }
        }
      }
    }

    // ── PRE-DEBUT: stajyer pazarı (popüler aday başka ajansa kaçabilir) ──
    await _processTraineeMarket(currentCareer.id, nextMonth);

    // ── HER HAFTA: chart + olaylar ──
    if (!report.groupDisbanded) {
      await _songs.advanceWeeklyCharts(currentCareer.id, nextMonth);

      final evt = await _events.generateWeeklyEvents(currentCareer.id,
          nextMonth, isNewMonth);
      report.eventHeadlines = evt.headlines;
      report.pendingDecisions = evt.pending;

      // Ay sınırında: önce yüksek skandal baskısı (kimya/moral/sadakat aşınır)
      if (isNewMonth) {
        report.scandalPressure =
            await _group.applyScandalPressure(currentCareer.id, nextMonth);

        // Moral 20 altı uyarılar (popup) + moral 10 altı "ayrılmak istiyor" kararı
        report.lowMoraleWarnings =
            await _events.lowMoraleMembers(currentCareer.id);
        await _events.maybeGenerateMoraleQuit(currentCareer.id, nextMonth);

        // Düşük sadakatli üyeler ayrılabilir / grup dağılabilir
        final dep = await _group.checkMemberDepartures(
            currentCareer.id, nextMonth);
        report.departedMembers = dep.departed;
        if (dep.disbanded) report.groupDisbanded = true;

        // Skandal ısısı kritikse grup dağılır
        if (!report.groupDisbanded) {
          final scandalDead =
              await _group.checkScandalCollapse(currentCareer.id, nextMonth);
          if (scandalDead) report.groupDisbanded = true;
        }
      }
    }

    // Başarımlar (her hafta kontrol — yeni açılanlar rapora)
    if (!report.groupDisbanded) {
      final absMonth = (nextYear - 1) * 12 + nextMonth;
      report.newAchievements =
          await _achievements.checkAndUnlock(currentCareer.id, absMonth);

      // Genel (kalıcı) başarımlar + ANA HEDEF: tüm kariyer başarımları
      report.newGlobalAchievements =
          await _globalAch.checkDuringPlay(currentCareer.id);
      final careerAchCount =
          (await _achievements.getForCareer(currentCareer.id)).length;
      // "Koleksiyoncu" bu turda açıldıysa oyun KAZANILDI sayılır
      report.careerGoalReached = report.newGlobalAchievements
              .contains(GlobalAchievementManager.titleOf('completionist')) &&
          careerAchCount >= AchievementManager.defs.length;

      // Sosyal medya: her hafta yeni yorumlar BİRİKİR (debüt sonrası)
      final absWeek = (nextYear - 1) * 48 + (nextMonth - 1) * 4 + nextWeek;
      await _social.generateWeeklyPosts(
          currentCareer.id, absMonth, absWeek);

      // Ay sonu: garip aylık ödüller + gazete manşeti (bazen)
      if (isNewMonth) {
        report.monthlyAward =
            await _group.maybeMonthlyAward(
                currentCareer.id, (nextYear - 1) * 12 + nextMonth);
        report.newspaperHeadline =
            await _group.maybeNewspaperHeadline(currentCareer.id, nextMonth);
      }
    }

    // Haftalık takipçi değişimini hesapla + kaydet (UI'da +/- gösterimi)
    if (!report.groupDisbanded) {
      final endGroup = await _group.getActiveGroup(currentCareer.id);
      if (endGroup != null) {
        final delta = endGroup.socialFollowers - startFollowers;
        report.followerDelta = delta;
        await (db.update(db.groups)..where((t) => t.id.equals(endGroup.id)))
            .write(GroupsCompanion(lastFollowerDelta: Value(delta)));
      }
    }

    // Takvimi ilerlet
    await (db.update(db.playerCareers)
          ..where((t) => t.id.equals(currentCareer.id)))
        .write(PlayerCareersCompanion(
      currentWeek: Value(nextWeek),
      currentMonth: Value(nextMonth),
      currentYear: Value(nextYear),
    ));

    return report;
  }

  /// Debüt öncesi: alınmayan POPÜLER aday (%18/hafta) başka ajansa gider
  /// ve şirketi sosyal medyada eleştirir. Grup kurulduysa ya da kadro
  /// dolduysa pazar kapanır.
  Future<void> _processTraineeMarket(int careerId, int month) async {
    final group = await (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
    if (group != null) return; // grup kuruldu → pazar kapalı

    // Şirketteki idol sayısı (kadro dolduysa pazar kapanır)
    final hired = await (db.select(db.playerIdols)
          ..where((t) => t.careerId.equals(careerId)))
        .get();
    if (hired.length >= 20) return;
    final hiredCharIds = hired.map((i) => i.characterId).toSet();

    if (_random.nextDouble() > 0.18) return;

    // Alınmamış, müsait, ünlü (fame>=70) adaylar
    final famous = await (db.select(db.generatedCharacters)
          ..where((t) =>
              t.careerId.equals(careerId) &
              t.recruitStatus.equals('available') &
              t.startingFame.isBiggerOrEqualValue(70)))
        .get();
    final pool = famous.where((c) => !hiredCharIds.contains(c.id)).toList();
    if (pool.isEmpty) return;

    // En ünlüsü gider
    pool.sort((a, b) => b.startingFame.compareTo(a.startingFame));
    final leaver = pool.first;
    await (db.update(db.generatedCharacters)
          ..where((t) => t.id.equals(leaver.id)))
        .write(const GeneratedCharactersCompanion(
            recruitStatus: Value('left')));

    await db.into(db.events).insert(EventsCompanion.insert(
          careerId: careerId,
          eventType: 'trainee_left',
          category: const Value('social'),
          title: '${leaver.name} Başka Ajansa İmza Attı',
          description: Value(
              '${leaver.name} (popülerlik ${leaver.startingFame}) seni beklemedi ve rakip bir ajansa katıldı. Sosyal medyada şirketin hakkında olumsuz konuştu.'),
          monthOccurred: month,
          impactValue: const Value(-5),
          resolved: const Value(true),
        ));
  }

  void _copyMonthlyInto(TrainingReport dst, TrainingReport src) {
    dst.broadcastIncome = src.broadcastIncome;
    dst.isStreamIncome = src.isStreamIncome;
    dst.totalSalaryPaid = src.totalSalaryPaid;
    dst.idolSalaryPaid = src.idolSalaryPaid;
    dst.idolSalaryDebt = src.idolSalaryDebt;
    dst.endingBalance = src.endingBalance;
    dst.quitCoaches = src.quitCoaches;
    dst.sponsorIncome = src.sponsorIncome;
    // totalGain HAFTALIK set edilir, ekonomi raporundan KOPYALANMAZ
  }
}

/// Sezon: aydan türetilir. Yaz=hareketli türler, Kış=slow türler avantajlı.
enum Season { ilkbahar, yaz, sonbahar, kis }

Season seasonForMonth(int month) {
  if (month >= 3 && month <= 5) return Season.ilkbahar;
  if (month >= 6 && month <= 8) return Season.yaz;
  if (month >= 9 && month <= 11) return Season.sonbahar;
  return Season.kis;
}

String seasonLabel(Season s) {
  switch (s) {
    case Season.ilkbahar:
      return 'İlkbahar 🌸';
    case Season.yaz:
      return 'Yaz ☀️';
    case Season.sonbahar:
      return 'Sonbahar 🍂';
    case Season.kis:
      return 'Kış ❄️';
  }
}
