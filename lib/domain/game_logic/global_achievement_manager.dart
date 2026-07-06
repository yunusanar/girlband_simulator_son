// Öğrenci No: 202313171033
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import 'achievement_manager.dart';
import 'group_manager.dart';

/// Kariyerler-üstü (kalıcı) genel başarımlar. Ana menüde gösterilir.
class GlobalAchievementManager {
  final AppDatabase db;
  GlobalAchievementManager(this.db);

  // (key, başlık, açıklama)
  static const List<(String, String, String)> defs = [
    ('completionist', 'Koleksiyoncu 🏅',
        'Bir kariyerde TÜM kariyer başarımlarını aç (ana hedef).'),
    ('manifesto_slayer', 'Manifesto Avcısı ⚔️',
        'Erişimde Manifesto\'yu geç.'),
    ('flawless', 'Kusursuz Kariyer 💎',
        'Hiç üye kaybetmeden bir kariyeri zirvede tamamla.'),
    ('dynasty', 'Hanedan 👑', '3 kariyer tamamla.'),
    ('tycoon', 'Para Babası 💰', 'Kasanı 1.000.000₺ yap.'),
    ('world_tour', 'Dünya Yıldızı ✈️', 'Bir Dünya Turu tamamla.'),
    ('chart_emperor', 'Liste İmparatoru 📈',
        'Aynı anda 5 hit şarkın listede olsun.'),
    ('beloved', 'Tapılan Grup 💜', 'Fandom sadakatini 100 yap.'),
    ('megastar_duet', 'Megastar Düeti 🌟',
        'Ülkenin megastarının düet teklifini kabul et (2M takipçi).'),
    ('finish_easy', 'Kolay Modu Bitir 🟢',
        'Kolay modda bir kariyerde tüm başarımları aç.'),
    ('finish_medium', 'Orta Modu Bitir 🟡',
        'Orta modda bir kariyerde tüm başarımları aç.'),
    ('finish_hard', 'Zor Modu Bitir 🔴',
        'Zor modda bir kariyerde tüm başarımları aç.'),
    ('finish_all_modes', 'Tüm Modlar Fatihi 🏆',
        'Kolay, orta ve zor modların üçünü de bitir.'),
  ];

  static String titleOf(String key) =>
      defs.firstWhere((d) => d.$1 == key, orElse: () => (key, key, '')).$2;

  Future<List<GlobalAchievement>> getAll() {
    return (db.select(db.globalAchievements)
          ..orderBy([(t) => OrderingTerm(expression: t.id)]))
        .get();
  }

  Future<Set<String>> unlockedKeys() async {
    final rows = await db.select(db.globalAchievements).get();
    return rows.map((r) => r.achKey).toSet();
  }

  /// Kilidi açar (zaten varsa yok sayar). Yeni açıldıysa başlığı döner.
  Future<String?> unlock(String key, {int careerNumber = 0}) async {
    final existing = await (db.select(db.globalAchievements)
          ..where((t) => t.achKey.equals(key))
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) return null;
    await db.into(db.globalAchievements).insert(
          GlobalAchievementsCompanion.insert(
            achKey: key,
            title: titleOf(key),
            unlockedCareerNumber: Value(careerNumber),
          ),
        );
    return titleOf(key);
  }

  /// Oyun sırasında kontrol edilen genel başarımlar. Yeni açılan başlıkları döner.
  Future<List<String>> checkDuringPlay(int careerId) async {
    final already = await unlockedKeys();
    final out = <String>[];
    Future<void> tryUnlock(String key) async {
      if (already.contains(key)) return;
      final t = await unlock(key);
      if (t != null) out.add(t);
    }

    final wallet = await (db.select(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    if (wallet != null && wallet.fanPoints >= 1000000) {
      await tryUnlock('tycoon');
    }

    final group = await (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
    if (group != null) {
      if (group.fandomLoyalty >= 100) await tryUnlock('beloved');

      final liveHits = await (db.select(db.songs)
            ..where((t) =>
                t.groupId.equals(group.id) &
                t.currentChartPosition.isSmallerOrEqualValue(10)))
          .get();
      if (liveHits.length >= 5) await tryUnlock('chart_emperor');

      final rival = await GroupManager(db).rivalStatusAt(0);
      // rivalStatusAt(0) erken segment; mutlak ay için career üzerinden hesapla
      final career = await (db.select(db.playerCareers)
            ..where((t) => t.id.equals(careerId)))
          .getSingleOrNull();
      if (career != null) {
        final absMonth =
            (career.currentYear - 1) * 12 + career.currentMonth;
        final r = await GroupManager(db).rivalStatusAt(absMonth);
        if (r.popularity > 0 && group.totalPopularity >= r.popularity) {
          await tryUnlock('manifesto_slayer');
        }
      } else if (rival.popularity > 0 &&
          group.totalPopularity >= rival.popularity) {
        await tryUnlock('manifesto_slayer');
      }
    }

    // Koleksiyoncu: bu kariyerde tüm kariyer başarımları açıldı mı?
    final careerAch =
        await AchievementManager(db).getForCareer(careerId);
    if (careerAch.length >= AchievementManager.defs.length) {
      await tryUnlock('completionist');

      // Zorluk moduna göre "modu bitir" başarımı + üçü tamamsa "tüm modlar"
      final career = await (db.select(db.playerCareers)
            ..where((t) => t.id.equals(careerId)))
          .getSingleOrNull();
      final diff = career?.difficulty ?? 'medium';
      await tryUnlock('finish_$diff');
      final now = await unlockedKeys();
      if (now.contains('finish_easy') &&
          now.contains('finish_medium') &&
          now.contains('finish_hard')) {
        await tryUnlock('finish_all_modes');
      }
    }

    return out;
  }

  /// Kariyer bitince kontrol edilenler (kusursuz kariyer, hanedan).
  Future<List<String>> checkOnCareerEnd(int careerId) async {
    final already = await unlockedKeys();
    final out = <String>[];
    Future<void> tryUnlock(String key) async {
      if (already.contains(key)) return;
      final t = await unlock(key);
      if (t != null) out.add(t);
    }

    // Hanedan: en az 3 tamamlanmış kariyer
    final histories = await db.select(db.careerHistories).get();
    if (histories.length >= 3) await tryUnlock('dynasty');

    // Kusursuz: bu kariyerin grubunda hiç ayrılan üye yok + rakibi geçmiş
    final group = await (db.select(db.groups)
          ..where((t) => t.careerId.equals(careerId))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    if (group != null) {
      final departures = await (db.select(db.groupMembers)
            ..where((t) =>
                t.groupId.equals(group.id) & t.leaveMonth.isNotNull()))
          .get();
      final career = await (db.select(db.playerCareers)
            ..where((t) => t.id.equals(careerId)))
          .getSingleOrNull();
      final absMonth = career == null
          ? 0
          : (career.currentYear - 1) * 12 + career.currentMonth;
      final rival = await GroupManager(db).rivalStatusAt(absMonth);
      final beat =
          rival.popularity > 0 && group.totalPopularity >= rival.popularity;
      if (departures.isEmpty && beat) await tryUnlock('flawless');
    }

    return out;
  }
}
