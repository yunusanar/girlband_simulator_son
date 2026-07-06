// Öğrenci No: 202313171033
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import 'group_manager.dart';
import 'ledger.dart';

/// Albüm sistemi: albüme dahil edilmemiş ("single") şarkıları derleyip albüm
/// yapar. Albüm tek tek single'dan daha büyük popülarite/takipçi getirir ve
/// en iyi parçayı ("title track") listeye geri sokar.
class AlbumManager {
  final AppDatabase db;
  AlbumManager(this.db);

  static const int minTracks = 3;
  static const int baseProductionCost = 3000;
  static const int perTrackCost = 1200;

  // (key, ad) — albüm konseptleri
  static const List<(String, String)> concepts = [
    ('standart', 'Standart'),
    ('konsept', 'Konsept Albüm'),
    ('derleme', 'Hit Derlemesi'),
  ];

  static int costFor(int trackCount) =>
      baseProductionCost + trackCount * perTrackCost;

  /// Albüme girmemiş yayınlanmış şarkılar (single'lar).
  Future<List<Song>> eligibleSongs(int groupId) {
    return (db.select(db.songs)
          ..where((t) => t.groupId.equals(groupId) & t.albumId.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.qualityScore)]))
        .get();
  }

  Future<List<Album>> getAlbums(int groupId) {
    return (db.select(db.albums)
          ..where((t) => t.groupId.equals(groupId))
          ..orderBy([(t) => OrderingTerm.desc(t.releaseMonth)]))
        .get();
  }

  ({double pop, double sales, int rep, double follower}) _conceptMods(
      String concept) {
    switch (concept) {
      case 'konsept':
        return (pop: 0.85, sales: 0.9, rep: 6, follower: 1.0);
      case 'derleme':
        return (pop: 1.2, sales: 1.25, rep: -2, follower: 1.3);
      default: // standart
        return (pop: 1.0, sales: 1.0, rep: 0, follower: 1.0);
    }
  }

  /// GİDER & GELİR TABLOSU (UI önizlemesi). Seçili şarkılar + konsepte göre.
  Future<({int cost, int salesIncome, int popBoost, int followerGain})> quote(
      int careerId, int groupId, List<int> songIds, String concept) async {
    final all = await eligibleSongs(groupId);
    final sel = all.where((s) => songIds.contains(s.id)).toList();
    final totalQ = sel.fold<int>(0, (s, x) => s + (x.qualityScore ?? 0));
    final m = _conceptMods(concept);
    final g = await (db.select(db.groups)..where((t) => t.id.equals(groupId)))
        .getSingleOrNull();
    final followers = g?.socialFollowers ?? 0;

    final costMult = g == null
        ? 1.0
        : GroupManager.costMultiplierFor(g.socialFollowers, g.totalPopularity);
    final cost = (costFor(sel.length) * costMult).round();
    final salesMult = (0.7 + followers / 400000.0).clamp(0.7, 2.8);
    // İtibar + skandal satışı etkiler (düşük itibar/yüksek skandal → az satış)
    final repMult = g == null ? 1.0 : (0.6 + g.reputation / 100.0);
    final scandalMult = g == null
        ? 1.0
        : (g.scandalHeat >= 80 ? 0.5 : (g.scandalHeat >= 50 ? 0.75 : 1.0));
    final salesIncome =
        (totalQ * 55 * m.sales * salesMult * repMult * scandalMult).round();
    final popBoost = (totalQ * 1000 * m.pop).round();
    final followerGain = (totalQ * 320 * m.follower).round();
    return (
      cost: cost,
      salesIncome: salesIncome,
      popBoost: popBoost,
      followerGain: followerGain
    );
  }

  Future<({bool ok, String reason})> canRelease(
      int careerId, int groupId, List<int> songIds) async {
    if (songIds.length < minTracks) {
      return (
        ok: false,
        reason: 'Albüm için en az $minTracks şarkı seç (seçili: ${songIds.length}).'
      );
    }
    final w = await (db.select(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    final mult = await GroupManager(db).currentCostMultiplier(careerId);
    final cost = (costFor(songIds.length) * mult).round();
    if (w == null || w.fanPoints < cost) {
      return (ok: false, reason: 'Yetersiz bütçe (gerekli: $cost₺).');
    }
    return (ok: true, reason: '');
  }

  /// Seçili şarkılardan albüm yapar. Üretim gideri düşer, SATIŞ geliri gelir,
  /// popülarite/takipçi artar, title track listeye geri girer.
  Future<({Album album, int cost, int salesIncome, int popBoost, int followerGain})>
      releaseAlbum({
    required int careerId,
    required int groupId,
    required String title,
    required int absMonth,
    required List<int> songIds,
    required String concept,
  }) async {
    final all = await eligibleSongs(groupId);
    final songs = all.where((s) => songIds.contains(s.id)).toList()
      ..sort((a, b) => (b.qualityScore ?? 0).compareTo(a.qualityScore ?? 0));
    final tracks = songs.length;
    final totalQ = songs.fold<int>(0, (s, x) => s + (x.qualityScore ?? 0));
    final avgQ = tracks == 0 ? 0 : (totalQ / tracks).round();
    final m = _conceptMods(concept);

    final factor = await GroupManager(db).currentPopGainFactor(careerId);
    final g0 = await (db.select(db.groups)..where((t) => t.id.equals(groupId)))
        .getSingleOrNull();
    final followers0 = g0?.socialFollowers ?? 0;
    final costMult = g0 == null
        ? 1.0
        : GroupManager.costMultiplierFor(
            g0.socialFollowers, g0.totalPopularity);
    final cost = (costFor(tracks) * costMult).round();
    final salesMult = (0.7 + followers0 / 400000.0).clamp(0.7, 2.8);
    final repMult = g0 == null ? 1.0 : (0.6 + g0.reputation / 100.0);
    final scandalMult = g0 == null
        ? 1.0
        : (g0.scandalHeat >= 80 ? 0.5 : (g0.scandalHeat >= 50 ? 0.75 : 1.0));
    final salesIncome =
        (totalQ * 55 * m.sales * salesMult * repMult * scandalMult).round();
    final popBoost = (totalQ * 1000 * m.pop * factor).round();
    final followerGain = (totalQ * 320 * m.follower).round();

    // Kasa: -gider +satış geliri
    final w = await (db.select(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    if (w != null) {
      final newBal = (w.fanPoints - cost + salesIncome).clamp(0, 1 << 31);
      await (db.update(db.currencyWallets)
            ..where((t) => t.careerId.equals(careerId)))
          .write(CurrencyWalletsCompanion(fanPoints: Value(newBal)));
    }
    await Ledger.record(db, careerId, 'album', 'Albüm yapımı: $title', -cost);
    await Ledger.record(db, careerId, 'album', 'Albüm satışı: $title', salesIncome);

    final albumId = await db.into(db.albums).insert(AlbumsCompanion.insert(
          groupId: groupId,
          title: title,
          releaseMonth: absMonth,
          trackCount: tracks,
          avgQuality: avgQ,
          popBoost: Value(popBoost),
          concept: Value(concept),
        ));

    for (final s in songs) {
      await (db.update(db.songs)..where((t) => t.id.equals(s.id)))
          .write(SongsCompanion(albumId: Value(albumId)));
    }

    // Title track (en kaliteli; konsept albümde +kalite kabul edilir) re-entry
    if (songs.isNotEmpty) {
      final t0 = songs.first;
      final effQ = ((t0.qualityScore ?? 50) + m.rep).clamp(1, 100);
      final reentry = (101 - effQ).clamp(1, 40);
      final newPeak = t0.peakChartPosition == null
          ? reentry
          : (reentry < t0.peakChartPosition! ? reentry : t0.peakChartPosition!);
      await (db.update(db.songs)..where((t) => t.id.equals(t0.id))).write(
        SongsCompanion(
          currentChartPosition: Value(reentry),
          peakChartPosition: Value(newPeak),
        ),
      );
    }

    final g = await (db.select(db.groups)..where((t) => t.id.equals(groupId)))
        .getSingleOrNull();
    if (g != null) {
      await (db.update(db.groups)..where((t) => t.id.equals(groupId))).write(
        GroupsCompanion(
          totalPopularity: Value(g.totalPopularity + popBoost),
          socialFollowers: Value(g.socialFollowers + followerGain),
          reputation: Value((g.reputation + m.rep).clamp(0, 100)),
          fandomLoyalty: Value((g.fandomLoyalty + 3).clamp(0, 100)),
        ),
      );
    }

    await db.into(db.events).insert(EventsCompanion.insert(
          careerId: careerId,
          groupId: Value(groupId),
          eventType: 'album_release',
          category: const Value('pr'),
          title: 'Albüm Çıktı: $title 💿',
          description: Value(
              '$tracks parçalık albüm yayınlandı! Satış +${_fmt(salesIncome)}₺, erişim +${_fmt(popBoost)}, takipçi +${_fmt(followerGain)}.'),
          monthOccurred: absMonth,
          impactValue: Value(popBoost),
          resolved: const Value(true),
        ));

    final album = (await (db.select(db.albums)..where((t) => t.id.equals(albumId)))
        .getSingleOrNull())!;
    return (
      album: album,
      cost: cost,
      salesIncome: salesIncome,
      popBoost: popBoost,
      followerGain: followerGain
    );
  }

  static String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return '$n';
  }
}
