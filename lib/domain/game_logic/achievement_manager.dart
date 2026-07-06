// Öğrenci No: 202313171033
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import 'group_manager.dart';

/// Başarımlar: koşullar sağlanınca kilidi açılır, kariyer başına bir kez.
class AchievementManager {
  final AppDatabase db;
  AchievementManager(this.db);

  // (key, başlık)
  static const List<(String, String)> defs = [
    ('first_song', 'İlk Single 🎵'),
    ('first_hit', 'İlk Hit — Top 10 🔟'),
    ('mega_hit', 'Mega Hit — #1 🚀'),
    ('first_album', 'İlk Albüm 💿'),
    ('hit_album', 'Hit Albüm 🏅'),
    ('streams_1m', '1 Milyon Stream 🎧'),
    ('chart_domination', 'Listede 3 Hit Aynı Anda 📈'),
    ('followers_100k', '100K Takipçi'),
    ('followers_500k', '500K Takipçi 🌟'),
    ('followers_1m', '1M Takipçi 🔥'),
    ('beat_rival', 'Rakibi Geçtin ⚔️'),
    ('award', 'Yılın Grubu 🏆'),
    ('rich', '100.000₺ Kasa 💰'),
    ('rep_max', 'Efsane İtibar (90+) ✨'),
    ('full_squad', 'Tam Kadro (6) 👯'),
    ('megastar', 'Megastar Düeti 🌟'),
  ];

  static String titleOf(String key) =>
      defs.firstWhere((d) => d.$1 == key, orElse: () => (key, key)).$2;

  /// Belirli bir kariyer başarımını doğrudan açar (olay-tetiklemeli; koşulla değil).
  Future<void> unlockOne(int careerId, String key, int absMonth) async {
    final existing = (await getForCareer(careerId)).map((a) => a.achKey).toSet();
    if (existing.contains(key)) return;
    await db.into(db.achievements).insertOnConflictUpdate(
          AchievementsCompanion.insert(
            careerId: careerId,
            achKey: key,
            title: titleOf(key),
            unlockedAbsMonth: absMonth,
          ),
        );
  }

  Future<List<Achievement>> getForCareer(int careerId) {
    return (db.select(db.achievements)
          ..where((t) => t.careerId.equals(careerId))
          ..orderBy([(t) => OrderingTerm(expression: t.unlockedAbsMonth)]))
        .get();
  }

  /// Koşulları kontrol eder, yeni açılanları kaydeder, açılan BAŞLIKLARı döner.
  Future<List<String>> checkAndUnlock(int careerId, int absMonth) async {
    final existing = (await getForCareer(careerId)).map((a) => a.achKey).toSet();

    final unlocked = <String>{};

    final group = await (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
    final wallet = await (db.select(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    final career = await (db.select(db.playerCareers)
          ..where((t) => t.id.equals(careerId)))
        .getSingleOrNull();

    if (wallet != null && wallet.fanPoints >= 100000) unlocked.add('rich');
    if (career != null && career.awardsWon >= 1) unlocked.add('award');

    if (group != null) {
      if (group.socialFollowers >= 100000) unlocked.add('followers_100k');
      if (group.socialFollowers >= 500000) unlocked.add('followers_500k');
      if (group.socialFollowers >= 1000000) unlocked.add('followers_1m');
      if (group.reputation >= 90) unlocked.add('rep_max');

      final songs = await (db.select(db.songs)
            ..where((t) => t.groupId.equals(group.id)))
          .get();
      if (songs.isNotEmpty) unlocked.add('first_song');
      // Toplam stream 1M
      final totalStreams =
          songs.fold<int>(0, (s, x) => s + x.totalStreams);
      if (totalStreams >= 1000000) unlocked.add('streams_1m');
      if (songs.any((s) => (s.peakChartPosition ?? 99) <= 10)) {
        unlocked.add('first_hit');
      }
      if (songs.any((s) => (s.peakChartPosition ?? 99) <= 1)) {
        unlocked.add('mega_hit');
      }
      // Aynı anda listede 3+ hit (top 10)
      final liveHits =
          songs.where((s) => (s.currentChartPosition ?? 99) <= 10).length;
      if (liveHits >= 3) unlocked.add('chart_domination');

      final albums = await (db.select(db.albums)
            ..where((t) => t.groupId.equals(group.id))
            ..limit(1))
          .get();
      if (albums.isNotEmpty) unlocked.add('first_album');

      // Hit albüm: zirvesi ≤10 olan şarkısı bulunan albüm
      final allAlbums = await (db.select(db.albums)
            ..where((t) => t.groupId.equals(group.id)))
          .get();
      for (final a in allAlbums) {
        final hit = await (db.select(db.songs)
              ..where((t) =>
                  t.albumId.equals(a.id) &
                  t.peakChartPosition.isSmallerOrEqualValue(10))
              ..limit(1))
            .getSingleOrNull();
        if (hit != null) {
          unlocked.add('hit_album');
          break;
        }
      }

      final members = await (db.select(db.groupMembers)
            ..where((t) =>
                t.groupId.equals(group.id) & t.leaveMonth.isNull()))
          .get();
      if (members.length >= 6) unlocked.add('full_squad');

      final rival = await GroupManager(db).rivalStatusAt(absMonth);
      if (rival.popularity > 0 &&
          group.totalPopularity >= rival.popularity) {
        unlocked.add('beat_rival');
      }
    }

    final newOnes = unlocked.difference(existing);
    final titles = <String>[];
    for (final key in newOnes) {
      final title = titleOf(key);
      titles.add(title);
      await db.into(db.achievements).insertOnConflictUpdate(
            AchievementsCompanion.insert(
              careerId: careerId,
              achKey: key,
              title: title,
              unlockedAbsMonth: absMonth,
            ),
          );
    }
    return titles;
  }
}
