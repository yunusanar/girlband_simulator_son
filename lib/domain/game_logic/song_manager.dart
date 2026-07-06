// Öğrenci No: 202313171033
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import '../../data/database/app_database.dart';
import 'group_manager.dart';
import 'social_manager.dart';
import 'ledger.dart';

// ─── Seçim modelleri ──────────────────────────────────────────────────────────

class TitleOption {
  final String title;
  final int qualityBonus; // nihai kaliteye eklenir
  final String hint;      // oyuncuya gösterilen kısa açıklama

  const TitleOption({
    required this.title,
    required this.qualityBonus,
    required this.hint,
  });
}

class LyricOption {
  final String profile;
  final String description;
  final int qualityBonus;
  final int driftPerMonth; // chart'tan kayma hızı (düşük = uzun ömür)
  final double scandalChance;
  final bool isRisky;       // kullanıcıya risk uyarısı göster
  final bool coachRecommended;
  final IconData icon;
  final Color color;

  const LyricOption({
    required this.profile,
    required this.description,
    required this.qualityBonus,
    required this.driftPerMonth,
    required this.scandalChance,
    this.isRisky = false,
    this.coachRecommended = false,
    required this.icon,
    required this.color,
  });
}

class SongSelectionData {
  final List<TitleOption> titles;
  final List<LyricOption> lyrics;

  const SongSelectionData({required this.titles, required this.lyrics});
}

class SongReleaseResult {
  final Song song;
  final bool scandalTriggered;
  final String? scandalDesc;
  final int finalQuality;
  final bool flopped; // kalite çok düşük → listeye giremedi, gelir yok
  final String? buzzHeadline; // sosyal medyada öne çıkan twit (bildirim)

  const SongReleaseResult({
    required this.song,
    required this.scandalTriggered,
    this.scandalDesc,
    required this.finalQuality,
    this.flopped = false,
    this.buzzHeadline,
  });
}

// ─── Grafik girişi ────────────────────────────────────────────────────────────

class ChartEntry {
  final int rank;
  final String title;
  final String groupName;
  final bool isOurs;
  final bool isRival;
  final int approxStreams;

  const ChartEntry({
    required this.rank,
    required this.title,
    required this.groupName,
    required this.isOurs,
    required this.isRival,
    required this.approxStreams,
  });
}

// ─── SongManager ──────────────────────────────────────────────────────────────

class SongManager {
  final AppDatabase db;
  final _rng = Random();

  SongManager(this.db);

  // ── Seçim verisini üret ────────────────────────────────────────────────────

  Future<SongSelectionData> generateSelectionOptions({
    required int careerId,
    required int groupPower,
    required int avgChem,
  }) async {
    // Tutulan koçları al → söz seçeneklerini etkiler
    final coaches = await (db.select(db.coaches)
          ..where((t) =>
              t.careerId.equals(careerId) & t.isHired.equals(true)))
        .get();
    final hasVocal = coaches.any((c) => c.discipline == 'vocal');
    final hasDance = coaches.any((c) => c.discipline == 'dance');
    final hasRap = coaches.any((c) => c.discipline == 'rap');

    return SongSelectionData(
      titles: _generateTitles(groupPower),
      lyrics: _buildLyricOptions(
        hasVocal: hasVocal,
        hasDance: hasDance,
        hasRap: hasRap,
        avgChem: avgChem,
        groupPower: groupPower,
      ),
    );
  }

  // ── Başlık üretimi ─────────────────────────────────────────────────────────

  static const _adj = [
    'Neon', 'Kristal', 'Altın', 'Mor', 'Gümüş', 'Kırmızı', 'Mavi', 'Pembe',
    'Sonsuz', 'Siyah', 'Beyaz', 'Işıltılı', 'Derin', 'Soluk', 'Parlak',
  ];
  static const _noun = [
    'Yıldız', 'Ay', 'Gece', 'Sabah', 'Rüya', 'Kalp', 'Şehir', 'Dalga',
    'Ses', 'Işık', 'Anı', 'Yol', 'Kapı', 'Gökyüzü', 'Çiçek',
  ];
  static const _templates = [
    '[ADJ] [NOUN]',
    'Under the [NOUN]',
    '[NOUN] Fantasy',
    'My [ADJ] [NOUN]',
    'Dear [NOUN]',
    'Forever [ADJ]',
    'Hello [NOUN]',
    '[ADJ] Melody',
    'Chasing [NOUN]',
    'One [ADJ] [NOUN]',
    '[NOUN] of Stars',
    'Last [ADJ] Night',
  ];

  List<TitleOption> _generateTitles(int groupPower) {
    // Güç arttıkça başlık seçeneği artar: 2..4
    final count = (2 + (groupPower ~/ 40)).clamp(2, 4);
    final usedTitles = <String>{};
    final result = <TitleOption>[];
    int attempt = 0;

    while (result.length < count && attempt < 30) {
      attempt++;
      final tmpl = _templates[_rng.nextInt(_templates.length)];
      String title = tmpl
          .replaceAll('[ADJ]', _adj[_rng.nextInt(_adj.length)])
          .replaceAll('[NOUN]', _noun[_rng.nextInt(_noun.length)]);
      if (usedTitles.contains(title)) continue;
      usedTitles.add(title);

      // Kalite bonusu: şablon çeşitliliğine göre −3..+10
      final qBonus = _rng.nextInt(14) - 3;
      final hint = qBonus >= 7
          ? 'Özgün ve akılda kalıcı'
          : qBonus >= 3
              ? 'Sade ama etkili'
              : qBonus >= 0
                  ? 'Yeterince ilgi çekici'
                  : 'Sıradan bir başlık';
      result.add(TitleOption(title: title, qualityBonus: qBonus, hint: hint));
    }
    // Bonus'a göre sırala (yüksek önce) — ama oyuncu bunu bilmiyor gibi
    result.shuffle(_rng);
    return result;
  }

  // ── Söz seçenekleri ────────────────────────────────────────────────────────

  static final _allProfiles = <LyricOption>[
    const LyricOption(
      profile: 'Güvenli',
      description: 'Dengeli, temiz üretim. Uzun süre çalar.',
      qualityBonus: 0,
      driftPerMonth: 3,
      scandalChance: 0.03,
      icon: Icons.shield_outlined,
      color: Colors.teal,
    ),
    const LyricOption(
      profile: 'Cesur',
      description: 'Yüksek enerji, dikkat çekici nakaratlar.',
      qualityBonus: 8,
      driftPerMonth: 4,
      scandalChance: 0.15,
      isRisky: true,
      icon: Icons.bolt,
      color: Colors.orange,
    ),
    const LyricOption(
      profile: 'Deneysel',
      description: 'Alışılmadık yapı: büyük başarı ya da fiyasko.',
      qualityBonus: 16,  // rastgele −8..+16; UI bunu gösterir
      driftPerMonth: 5,
      scandalChance: 0.25,
      isRisky: true,
      icon: Icons.science_outlined,
      color: Colors.purple,
    ),
    const LyricOption(
      profile: 'Nostaljik',
      description: 'Zamansız melodi. Yavaş tutunur, uzun kalır.',
      qualityBonus: 3,
      driftPerMonth: 2,
      scandalChance: 0.04,
      icon: Icons.history_edu_outlined,
      color: Colors.brown,
    ),
    const LyricOption(
      profile: 'Agresif',
      description: 'Patlama yapar, hızlı düşer. Hit ya da hiç.',
      qualityBonus: 14,
      driftPerMonth: 6,
      scandalChance: 0.35,
      isRisky: true,
      icon: Icons.local_fire_department,
      color: Colors.red,
    ),
    const LyricOption(
      profile: 'Duygusal',
      description: 'Fan sadakati oluşturur. Sessiz ama güçlü.',
      qualityBonus: 5,
      driftPerMonth: 3,
      scandalChance: 0.08,
      icon: Icons.favorite_border,
      color: Colors.pink,
    ),
    const LyricOption(
      profile: 'Komik & Viral',
      description: 'İnternette yayılır. Kısa ömürlü ama patlayıcı.',
      qualityBonus: 6,
      driftPerMonth: 7,
      scandalChance: 0.20,
      isRisky: true,
      icon: Icons.tag_faces,
      color: Colors.amber,
    ),
    const LyricOption(
      profile: 'Politik',
      description: 'Güçlü mesaj, yüksek skandal riski.',
      qualityBonus: 10,
      driftPerMonth: 4,
      scandalChance: 0.45,
      isRisky: true,
      icon: Icons.campaign_outlined,
      color: Colors.indigo,
    ),
  ];

  List<LyricOption> _buildLyricOptions({
    required bool hasVocal,
    required bool hasDance,
    required bool hasRap,
    required int avgChem,
    required int groupPower,
  }) {
    final options = <LyricOption>[];
    final used = <String>{};

    void add(String profile, {bool markRecommended = false}) {
      if (used.contains(profile)) return;
      used.add(profile);
      final base = _allProfiles.firstWhere((p) => p.profile == profile);
      options.add(markRecommended
          ? LyricOption(
              profile: base.profile,
              description: base.description,
              qualityBonus: base.qualityBonus,
              driftPerMonth: base.driftPerMonth,
              scandalChance: base.scandalChance,
              isRisky: base.isRisky,
              coachRecommended: true,
              icon: base.icon,
              color: base.color,
            )
          : base);
    }

    // Temel seçenekler (her zaman)
    add('Güvenli', markRecommended: hasVocal);
    add('Cesur', markRecommended: hasDance);

    // Koça göre eklenenler
    if (hasVocal) add('Duygusal');
    if (hasVocal) add('Nostaljik');
    if (hasRap) add('Agresif', markRecommended: true);
    if (hasDance) add('Komik & Viral');

    // Kimya ve güç bonusları
    if (avgChem > 30) add('Duygusal');
    if (avgChem > 50) add('Nostaljik');
    if (groupPower > 60) add('Deneysel');
    if (groupPower > 80) add('Politik');

    // Minimum 3 seçenek garantisi
    if (options.length < 3) add('Deneysel');
    if (options.length < 3) add('Nostaljik');

    return options;
  }

  // ── TÜR META & MALİYET ──────────────────────────────────────────────────────

  /// Tür → disiplin ağırlıkları (v/d/r) + ruh hali (sezon eşleşmesi için).
  static const Map<String, ({double v, double d, double r, String mood})>
      genreInfo = {
    'K-Pop':     (v: 1.0, d: 1.0, r: 1.0, mood: 'upbeat'),
    'Pop':       (v: 1.4, d: 1.0, r: 0.5, mood: 'upbeat'),
    'Ballad':    (v: 2.0, d: 0.3, r: 0.2, mood: 'slow'),
    'R&B':       (v: 1.5, d: 0.7, r: 0.6, mood: 'slow'),
    'Dance':     (v: 0.6, d: 2.0, r: 0.3, mood: 'upbeat'),
    'Hip-Hop':   (v: 0.4, d: 0.6, r: 2.0, mood: 'neutral'),
    'Synth-Pop': (v: 0.9, d: 1.5, r: 0.4, mood: 'upbeat'),
    'EDM':       (v: 0.3, d: 2.0, r: 0.4, mood: 'upbeat'),
  };

  static const int baseReleaseCost = 1500;
  static const int musicVideoCost = 3000;

  static int releaseCost({required bool hasMusicVideo}) =>
      baseReleaseCost + (hasMusicVideo ? musicVideoCost : 0);

  /// Şu an şarkı çıkarılabilir mi? (Ayda 1 şarkı kuralı + bütçe)
  static const int fatigueBlockThreshold = 80;

  Future<({bool ok, String reason})> canRelease(
      int careerId, int absMonth, int cost) async {
    final group = await _activeGroup(careerId);
    if (group == null) return (ok: false, reason: 'Önce grup kur.');
    if (group.lastReleaseMonth != null && absMonth <= group.lastReleaseMonth!) {
      return (ok: false, reason: 'Bu ay zaten şarkı çıkardın. Gelecek ay tekrar.');
    }
    // Ekip çok yorgunsa şarkı çıkaramaz → mola/tatil ver ya da zaman geçir
    final avgFat = await _avgFatigue(group.id);
    if (avgFat >= fatigueBlockThreshold) {
      return (
        ok: false,
        reason:
            'Ekip tükenmiş durumda (yorgunluk ${avgFat.round()}). Tatil ver ya da dinlendir, sonra şarkı çıkar.'
      );
    }
    final w = await (db.select(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    if (w == null || w.fanPoints < cost) {
      return (ok: false, reason: 'Yetersiz bütçe (gerekli: $cost₺).');
    }
    return (ok: true, reason: '');
  }

  Future<double> _avgFatigue(int groupId) async {
    final rows = await (db.select(db.groupMembers).join([
      innerJoin(
          db.playerIdols, db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
    ])
          ..where(db.groupMembers.groupId.equals(groupId) &
              db.groupMembers.leaveMonth.isNull()))
        .get();
    if (rows.isEmpty) return 0;
    final total = rows.fold<int>(
        0, (s, r) => s + r.readTable(db.playerIdols).fatigue);
    return total / rows.length;
  }

  /// Grubun efektif disiplin ortalamaları.
  Future<({double v, double d, double r, double overall})> groupDisciplineAvg(
      int groupId) async {
    final rows = await (db.select(db.groupMembers).join([
      innerJoin(
          db.playerIdols, db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.groupMembers.groupId.equals(groupId) &
              db.groupMembers.leaveMonth.isNull()))
        .get();
    if (rows.isEmpty) return (v: 0.0, d: 0.0, r: 0.0, overall: 0.0);
    double v = 0, d = 0, r = 0;
    for (final row in rows) {
      final ch = row.readTable(db.generatedCharacters);
      final idol = row.readTable(db.playerIdols);
      v += ch.vocalSkill + idol.vocalBonus;
      d += ch.danceSkill + idol.danceBonus;
      r += ch.rapSkill + idol.rapBonus;
    }
    final n = rows.length;
    v /= n; d /= n; r /= n;
    return (v: v, d: d, r: r, overall: (v + d + r) / 3.0);
  }

  /// Tür yatkınlık etkisi (kaliteye eklenen ±): grubun güçlü olduğu disipline
  /// uyan tür artı, uymayan tür eksi verir.
  double genreFit(({double v, double d, double r, double overall}) disc,
      String genre) {
    final info = genreInfo[genre] ?? (v: 1.0, d: 1.0, r: 1.0, mood: 'neutral');
    final wsum = info.v + info.d + info.r;
    final weighted = (disc.v * info.v + disc.d * info.d + disc.r * info.r) / wsum;
    return ((weighted - disc.overall) * 0.9).clamp(-22.0, 15.0);
  }

  /// Sezon yatkınlık etkisi (kaliteye eklenen ±).
  int seasonFit(String genre, int month) {
    final mood = (genreInfo[genre] ?? (v: 1, d: 1, r: 1, mood: 'neutral')).mood;
    final isSummer = month >= 6 && month <= 8;
    final isWinter = month == 12 || month <= 2;
    if (isSummer) {
      if (mood == 'upbeat') return 8;
      if (mood == 'slow') return -8;
      return 0;
    }
    if (isWinter) {
      if (mood == 'slow') return 8;
      if (mood == 'upbeat') return -8;
      return 0;
    }
    return 0; // ilkbahar / sonbahar nötr
  }

  /// Tahmini kaliteyi kabaca banda çevirir (kesin sayı gizlenir).
  static ({String label, String emoji}) qualityBand(int est) {
    if (est >= 80) return (label: 'Çok umut verici', emoji: '✨');
    if (est >= 65) return (label: 'Umut verici', emoji: '🤞');
    if (est >= 50) return (label: 'Orta', emoji: '🙂');
    if (est >= 38) return (label: 'Riskli', emoji: '😬');
    return (label: 'Çok riskli', emoji: '🚨');
  }

  // ── Şarkı çıkar ───────────────────────────────────────────────────────────

  Future<SongReleaseResult> releaseSong({
    required int groupId,
    required int careerId,
    required String title,
    required String genre,
    required int month,     // 1..12 (sezon)
    required int absMonth,  // mutlak ay (saklama + cooldown)
    required int groupPower,
    required int avgChemistry,
    required int titleQualityBonus,
    required LyricOption lyricOption,
    required bool hasMusicVideo,
    int conceptQBonus = 0,
    double conceptFollMult = 1.0,
    double conceptPopMult = 1.0,
    int conceptRep = 0,
    int conceptScandal = 0,
  }) async {
    final big5 = await _groupAvgBig5(groupId);
    final disc = await groupDisciplineAvg(groupId);

    // Maliyeti düş (prestij vergisiyle ölçeklenir)
    final mult = await GroupManager(db).currentCostMultiplier(careerId);
    final cost = (releaseCost(hasMusicVideo: hasMusicVideo) * mult).round();
    final w = await (db.select(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    if (w != null) {
      await (db.update(db.currencyWallets)
            ..where((t) => t.careerId.equals(careerId)))
          .write(CurrencyWalletsCompanion(
              fanPoints: Value((w.fanPoints - cost).clamp(0, 1 << 31))));
    }
    await Ledger.record(db, careerId, 'song',
        'Şarkı yapımı: $title${hasMusicVideo ? " (klipli)" : ""}', -cost);

    // Deneysel: başarı şansı grup AÇIKLIĞINA bağlı
    int lyricQ = lyricOption.qualityBonus;
    if (lyricOption.profile == 'Deneysel') {
      final successChance = 0.35 + big5.openness / 200.0;
      lyricQ = _rng.nextDouble() < successChance ? lyricOption.qualityBonus : -10;
    }

    // Tür + sezon yatkınlığı, klip bonusu, gizli varyans
    final gFit = genreFit(disc, genre);
    final sFit = seasonFit(genre, month);
    final mvBonus = hasMusicVideo ? 7 : 0;
    final variance = _rng.nextInt(13) - 6; // ±6 gizli belirsizlik

    final rawQ = (groupPower * 0.6 +
            avgChemistry * 0.4 +
            titleQualityBonus +
            lyricQ +
            gFit +
            sFit +
            mvBonus +
            conceptQBonus + // comeback konsept kalite katkısı
            variance)
        .round()
        .clamp(1, 100);

    // KÖTÜ ŞARKI FLOP EDER: kalite < 35 → listeye giremez (gelir/ivme yok).
    const flopThreshold = 35;
    final bool flops = rawQ < flopThreshold;
    final int? startPos = flops ? null : (101 - rawQ).clamp(1, 70);

    final id = await db.into(db.songs).insert(SongsCompanion.insert(
          groupId: groupId,
          title: title,
          genre: Value(genre.isEmpty ? null : genre),
          releaseMonth: absMonth,
          qualityScore: Value(rawQ),
          currentChartPosition: Value(startPos),
          peakChartPosition: Value(startPos),
          lyricProfile: Value(lyricOption.profile),
        ));

    // Çıkış ivmeleri — flop ise SIFIR
    final mvMult = hasMusicVideo ? 1.6 : 1.0;
    final factor = await GroupManager(db).currentPopGainFactor(careerId);
    final popBoost =
        flops ? 0 : (rawQ * 500 * mvMult * factor * conceptPopMult).round();
    final followerGain = flops
        ? 0
        : (rawQ * 180 * (0.7 + big5.extraversion / 150.0) * mvMult *
                conceptFollMult)
            .round();
    final g = await (db.select(db.groups)..where((t) => t.id.equals(groupId)))
        .getSingleOrNull();
    if (g != null) {
      await (db.update(db.groups)..where((t) => t.id.equals(groupId))).write(
        GroupsCompanion(
          totalPopularity: Value(g.totalPopularity + popBoost),
          socialFollowers: Value(g.socialFollowers + followerGain),
          // Konsept itibar/skandal etkisi
          reputation: Value((g.reputation + (flops ? 0 : conceptRep))
              .clamp(0, 100)),
          scandalHeat: Value((g.scandalHeat + (flops ? 0 : conceptScandal))
              .clamp(0, 100)),
          lastReleaseMonth: Value(absMonth),
        ),
      );
    }

    // ŞARKI → İDOL geri bildirimi: hit moral+ (gelişim hızlanır, mood eğitimi
    // etkiler), flop moral- (gelişim yavaşlar). Sosyal medya tepkisi gibi.
    final int moodDelta =
        flops ? -10 : (rawQ >= 65 ? 7 : (rawQ >= 50 ? 3 : -3));
    final members = await (db.select(db.groupMembers)
          ..where((t) => t.groupId.equals(groupId) & t.leaveMonth.isNull()))
        .get();
    // Şarkı yapımı YORUCUDUR: klipli daha çok. Yorgunluk biriktikçe yeni şarkı
    // çıkmaz (canRelease engeller) → mola/tatil ya da zaman gerekir.
    final fatigueAdd = hasMusicVideo ? 26 : 18;
    for (final m in members) {
      final idol = await (db.select(db.playerIdols)
            ..where((t) => t.id.equals(m.idolId)))
          .getSingleOrNull();
      if (idol == null) continue;
      await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
          .write(PlayerIdolsCompanion(
        mood: Value((idol.mood + moodDelta).clamp(0, 100)),
        fatigue: Value((idol.fatigue + fatigueAdd).clamp(0, 100)),
      ));
    }

    // Skandal kontrolü — NEVROTIKLIK riski artırır, ÖZDISIPLIN azaltır
    final scandalMult = (1 + (big5.neuroticism - 50) / 100.0) *
        (1 - (big5.conscientiousness - 50) / 200.0);
    final effChance = (lyricOption.scandalChance * scandalMult).clamp(0.0, 0.95);
    bool scandal = false;
    String? scandalDesc;
    if (_rng.nextDouble() < effChance) {
      scandal = true;
      scandalDesc = _scandalDesc(lyricOption.profile);
      await db.into(db.events).insert(EventsCompanion.insert(
        careerId: careerId,
        groupId: Value(groupId),
        eventType: 'song_scandal',
        category: const Value('social'),
        title: 'Şarkı Sözleri Tartışma Yarattı',
        description: Value(scandalDesc),
        monthOccurred: month,
        impactValue: const Value(-15),
        resolved: const Value(true),
      ));
      if (g != null) {
        await (db.update(db.groups)..where((t) => t.id.equals(groupId))).write(
          GroupsCompanion(
            scandalHeat: Value((g.scandalHeat + 30).clamp(0, 100)),
            reputation: Value((g.reputation - 10).clamp(0, 100)),
          ),
        );
      }
    }

    // Sosyal medyada şarkı twitleri (1'i bildirim olarak öne çıkar)
    final buzz = await SocialManager(db)
        .addSongBuzz(careerId, groupId, title, rawQ >= 65, flops);

    final song = (await (db.select(db.songs)..where((t) => t.id.equals(id)))
        .getSingleOrNull())!;
    return SongReleaseResult(
      song: song,
      scandalTriggered: scandal,
      scandalDesc: scandalDesc,
      flopped: flops,
      finalQuality: rawQ,
      buzzHeadline: buzz,
    );
  }

  String _scandalDesc(String profile) {
    switch (profile) {
      case 'Cesur':
        return 'Bazı dinleyiciler sözleri provokatif buldu.';
      case 'Agresif':
        return 'Sözlerdeki agresif içerik medyada yer buldu.';
      case 'Politik':
        return 'Sözlerin politik mesajı tartışma yarattı.';
      case 'Komik & Viral':
        return 'Bir mısra yanlış anlaşılarak sosyal medyada gündem oldu.';
      case 'Deneysel':
        return 'Alışılmadık temaları bazı çevrelerce eleştirildi.';
      default:
        return 'Sözler beklenmedik tepkiye yol açtı.';
    }
  }

  // ── Haftalık chart ilerlemesi ──────────────────────────────────────────────

  Future<void> advanceWeeklyCharts(int careerId, int month) async {
    final group = await _activeGroup(careerId);
    if (group == null) return;

    final songs = await (db.select(db.songs)
          ..where((t) =>
              t.groupId.equals(group.id) &
              t.currentChartPosition.isSmallerOrEqualValue(100)))
        .get();

    for (final song in songs) {
      final pos = song.currentChartPosition ?? 100;
      final drift = _weeklyDrift(song.lyricProfile);
      final newPos = pos + drift;
      final weekly = _weeklyStreams(pos);
      final newTotal = song.totalStreams + weekly;

      await (db.update(db.songs)..where((t) => t.id.equals(song.id))).write(
        SongsCompanion(
          currentChartPosition: Value(newPos > 100 ? null : newPos),
          totalStreams: Value(newTotal),
        ),
      );
    }
  }

  // ── Gelir / gider ──────────────────────────────────────────────────────────

  Future<int> computeMonthlyStreamIncome(int careerId) async {
    final group = await _activeGroup(careerId);
    if (group == null) return 0;

    final songs = await (db.select(db.songs)
          ..where((t) =>
              t.groupId.equals(group.id) &
              t.currentChartPosition.isSmallerOrEqualValue(100)))
        .get();

    // Sıra ne kadar yüksekse o kadar çok stream (yukarıdaki şarkı katlanır gelir)
    int base = 0;
    for (final s in songs) {
      final pos = s.currentChartPosition ?? 100;
      base += (101 - pos) * 35; // YÜKSELTİLDİ (#1 ≈ 3500/ay)
      // Stream sayacını biriktir (1M stream başarımı için; #1 ≈ 200K/ay)
      final monthlyStreams = (101 - pos) * 2000;
      await (db.update(db.songs)..where((t) => t.id.equals(s.id))).write(
          SongsCompanion(totalStreams: Value(s.totalStreams + monthlyStreams)));
    }
    // İtibar çarpanı (0.6..1.6) ve skandal cezası
    final repMult = 0.6 + group.reputation / 100.0;
    final scandalMult = group.scandalHeat >= 80
        ? 0.4
        : group.scandalHeat >= 50
            ? 0.75
            : 1.0;
    return (base * repMult * scandalMult).round();
  }

  Future<int> computeMonthlySongPopBonus(int careerId) async {
    final group = await _activeGroup(careerId);
    if (group == null) return 0;

    final songs = await (db.select(db.songs)
          ..where((t) =>
              t.groupId.equals(group.id) &
              t.currentChartPosition.isSmallerOrEqualValue(100)))
        .get();

    int bonus = 0;
    for (final s in songs) {
      final pos = s.currentChartPosition ?? 100;
      // Yüksek sıradaki şarkılar popülariteye katkı yapar (dengelenmiş).
      bonus += (101 - pos) * 150;
    }
    return bonus;
  }

  // BÜYÜDÜKÇE GİDER ARTAR: ünlü idoller daha pahalı (takipçi+popülarite çarpanı)
  // + rakip baskısıyla yükseltilen salaryBonus. Döküm ile aynı toplamı verir.
  Future<int> computeIdolSalaries(int careerId) async {
    final b = await idolSalaryBreakdown(careerId);
    return b.total;
  }

  /// Maaş dökümü (grup sekmesinde "kime ne kadar, neden" gösterimi).
  Future<({List<({String name, String rarity, int base, int bonus, int total})> rows, double growthMult, int total})>
      idolSalaryBreakdown(int careerId) async {
    final group = await _activeGroup(careerId);
    if (group == null) {
      return (rows: <({String name, String rarity, int base, int bonus, int total})>[], growthMult: 1.0, total: 0);
    }
    final rows = await (db.select(db.groupMembers).join([
      innerJoin(
          db.playerIdols, db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.groupMembers.groupId.equals(group.id) &
              db.groupMembers.leaveMonth.isNull()))
        .get();
    final growthMult = (1.0 +
            (group.socialFollowers / 400000.0) +
            (group.totalPopularity / 1500000.0))
        .clamp(1.0, 4.0);
    final out = <({String name, String rarity, int base, int bonus, int total})>[];
    int total = 0;
    for (final row in rows) {
      final char = row.readTable(db.generatedCharacters);
      final idol = row.readTable(db.playerIdols);
      final b = _salaryByRarity(char.rarity);
      final t = (b * growthMult).round() + idol.salaryBonus;
      total += t;
      out.add((
        name: char.name,
        rarity: char.rarity,
        base: b,
        bonus: idol.salaryBonus,
        total: t
      ));
    }
    return (rows: out, growthMult: growthMult.toDouble(), total: total);
  }

  Future<List<Song>> getSongsForGroup(int groupId) {
    return (db.select(db.songs)
          ..where((t) => t.groupId.equals(groupId))
          ..orderBy([(t) => OrderingTerm.desc(t.releaseMonth)]))
        .get();
  }

  // ── Grafik üretimi ─────────────────────────────────────────────────────────

  // Rakip (Manifesto) şarkı havuzu — zamanla yeni şarkılar çıkarsın diye rotasyon
  static const List<String> _rivalSongPool = [
    'Eclipse', 'Rising Star', 'Phantom Beat', 'Supernova', 'Crown',
    'Wildfire', 'Diamond Hour', 'Echo Chamber', 'Last Dance', 'Vertigo',
    'Adrenaline', 'Mirror', 'Gravity', 'Obsidian', 'Skyfall',
  ];
  static const List<String> _fakeGroups = [
    'AURORA', 'STELLA5', 'CHERRY WAVE', 'MIRAE', 'BLOOM',
    'NOVA', 'IRIS', 'PEARL', 'HAZE', 'VELVET',
    'LUNA TIDE', 'KISS6', 'ECHO', 'PRISM', 'SAPPHIRE',
    'NEON KISS', 'GALAXY GIRLS', 'RUByROSE', 'MOONCHILD', 'FEVER',
  ];
  static const List<String> _fakeTitles = [
    'Moonrise', 'Neon Lights', 'Free Bird', 'Galaxy', 'Shimmer',
    'Midnight Run', 'Candy', 'Heartwave', 'Daydream', 'Starfall',
    'Ice Queen', 'Golden Hour', 'Rush', 'Afterglow', 'Signal',
    'Spark', 'Wonder', 'Fever', 'Replay', 'Flutter',
    'Butterfly', 'Cosmic', 'Honey', 'Mirage', 'Tempo',
    'Sugar Rush', 'Eternal', 'Limelight', 'Velvet Sky', 'Pulse',
  ];

  /// [seedKey] mutlak hafta → grafik her hafta yenilenir (rotasyon).
  /// [absMonth] mutlak ay → rakip popülaritesi (büyüyen hedef).
  Future<List<ChartEntry>> generateChartEntries(
      int careerId, int absMonth, int seedKey) async {
    final rivalStatus = await GroupManager(db).rivalStatusAt(absMonth);
    final rivalName = rivalStatus.name;
    final rivalPop = rivalStatus.popularity;

    final group = await _activeGroup(careerId);
    final String ourGroupName = group != null
        ? (await (db.select(db.groups)
                  ..where((t) => t.id.equals(group.id)))
                .getSingleOrNull())
            ?.groupName ?? 'Grubun'
        : '';

    // Slot tabanlı yerleştirme: ÖNCE bizim şarkılarımız (gerçek sırada),
    // sonra rakip, sonra deko gruplar. Böylece #1 şarkımız gerçekten #1 görünür.
    final slots = <int, ChartEntry>{};
    int freeFrom(int start) {
      for (int p = start; p <= 20; p++) {
        if (!slots.containsKey(p)) return p;
      }
      for (int p = start - 1; p >= 1; p--) {
        if (!slots.containsKey(p)) return p;
      }
      return -1;
    }

    // 1) Bizim şarkılar — gerçek chart pozisyonunda (önceliğimiz var)
    if (group != null) {
      final songs = await (db.select(db.songs)
            ..where((t) =>
                t.groupId.equals(group.id) &
                t.currentChartPosition.isSmallerOrEqualValue(20))
            ..orderBy([(t) => OrderingTerm(expression: t.currentChartPosition)]))
          .get();
      for (final s in songs) {
        final desired = s.currentChartPosition!;
        final p = slots.containsKey(desired) ? freeFrom(desired) : desired;
        if (p < 1) continue;
        slots[p] = ChartEntry(
          rank: p, title: s.title, groupName: ourGroupName,
          isOurs: true, isRival: false,
          approxStreams: (101 - p) * 800,
        );
      }
    }

    // 2) Rakip şarkılar — haftaya göre rotasyonlu 3 başlık, boş üst slotlara
    final rRng = Random(seedKey * 7 + 3);
    final rivalTitles = [..._rivalSongPool]..shuffle(rRng);
    final rBase = (rivalPop > 2200000) ? 1 : (rivalPop > 2000000) ? 2 : 3;
    final rivalTargets = [rBase, rBase + 3, rBase + 8];
    for (int i = 0; i < 3; i++) {
      final p = freeFrom(rivalTargets[i].clamp(1, 20));
      if (p < 1) continue;
      slots[p] = ChartEntry(
        rank: p, title: rivalTitles[i % rivalTitles.length],
        groupName: rivalName, isOurs: false, isRival: true,
        approxStreams: (101 - p) * 800 * 3,
      );
    }

    // 3) Kalan slotları deko gruplarla doldur (haftalık rotasyon)
    final rng = Random(seedKey * 31337 + 7);
    final usedGroups = <int>{};
    final usedTitles = <int>{};
    int nextIdx(List list, Set<int> used) {
      int i;
      do { i = rng.nextInt(list.length); }
      while (used.contains(i) && used.length < list.length);
      used.add(i);
      return i;
    }

    final entries = <ChartEntry>[];
    for (int pos = 1; pos <= 20; pos++) {
      if (slots.containsKey(pos)) {
        entries.add(slots[pos]!);
      } else {
        entries.add(ChartEntry(
          rank: pos,
          title: _fakeTitles[nextIdx(_fakeTitles, usedTitles)],
          groupName: _fakeGroups[nextIdx(_fakeGroups, usedGroups)],
          isOurs: false, isRival: false,
          approxStreams: (101 - pos) * 800 * (rng.nextInt(4) + 1),
        ));
      }
    }
    return entries;
  }

  // ── Yardımcılar ───────────────────────────────────────────────────────────

  Future<Group?> _activeGroup(int careerId) {
    return (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Gruptaki aktif üyelerin ortalama Big5 değerleri.
  Future<({double openness, double conscientiousness, double extraversion, double agreeableness, double neuroticism})>
      _groupAvgBig5(int groupId) async {
    final rows = await (db.select(db.groupMembers).join([
      innerJoin(
          db.playerIdols, db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.groupMembers.groupId.equals(groupId) &
              db.groupMembers.leaveMonth.isNull()))
        .get();

    if (rows.isEmpty) {
      return (openness: 50.0, conscientiousness: 50.0, extraversion: 50.0, agreeableness: 50.0, neuroticism: 50.0);
    }
    double o = 0, c = 0, e = 0, a = 0, n = 0;
    for (final row in rows) {
      final ch = row.readTable(db.generatedCharacters);
      o += ch.openness;
      c += ch.conscientiousness;
      e += ch.extraversion;
      a += ch.agreeableness;
      n += ch.neuroticism;
    }
    final len = rows.length;
    return (
      openness: o / len,
      conscientiousness: c / len,
      extraversion: e / len,
      agreeableness: a / len,
      neuroticism: n / len,
    );
  }

  // Haftalık biriken stream (sadece görsel totalStreams için).
  int _weeklyStreams(int? pos) {
    if (pos == null || pos > 100) return 0;
    return (101 - pos) * 220;
  }

  // Haftalık chart düşüş hızı (profil bazlı, aylıktan daha yumuşak).
  int _weeklyDrift(String? profile) {
    switch (profile) {
      case 'Nostaljik': return 1;
      case 'Güvenli':   return 2;
      case 'Duygusal':  return 2;
      case 'Cesur':     return 2;
      case 'Deneysel':  return 3;
      case 'Komik & Viral': return 4;
      case 'Agresif':   return 3;
      case 'Politik':   return 2;
      default:          return 2;
    }
  }

  int _salaryByRarity(String rarity) {
    // Başlangıç dengesi: debüt sonrası ilk aylarda gelir düşük olduğundan
    // taban maaşlar düşük tutuldu; growthMult ile büyüdükçe artar.
    switch (rarity) {
      case 'legendary': return 1100;
      case 'epic':      return 650;
      case 'rare':      return 400;
      default:          return 240; // common
    }
  }
}
