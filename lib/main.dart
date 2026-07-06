// Öğrenci No: 202313171033
import 'dart:math';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart' as drift;

import 'providers/database_provider.dart';
import 'providers/career_controller.dart';
import 'data/database/app_database.dart';
import 'domain/game_logic/group_manager.dart';
import 'domain/game_logic/song_manager.dart';
import 'domain/game_logic/event_engine.dart';
import 'domain/game_logic/pr_manager.dart';
import 'domain/game_logic/concert_manager.dart';
import 'domain/game_logic/album_manager.dart';
import 'domain/game_logic/achievement_manager.dart';
import 'domain/game_logic/global_achievement_manager.dart';
import 'domain/game_logic/social_manager.dart';
import 'domain/game_logic/training_manager.dart';
import 'domain/game_logic/game_clock.dart';
import 'theme/app_theme.dart';
import 'theme/widgets.dart';

// --- ELEME AKIŞI ---
// 50 adaydan 20 zorunlu seçim → her ay max 2 eleme → 6 kişide grup kurulur.
const int kRecruitTarget = 20;
const int kElimTarget = 10; // elemede inilecek sayı (sonra 6'sı seçilir)
const int kGroupSize = 6; // gruba seçilecek nihai kadro
const int kElimPerMonth = 2;

// Bu ay kaç idol elendi (ay başında sıfırlanır)
final eliminatedThisMonthProvider = StateProvider.autoDispose<int>((ref) => 0);

// PR haftalık limit: her hafta en fazla 2 PR aksiyonu (hafta başında sıfırlanır)
const int kPrPerWeek = 2;
final prUsedThisWeekProvider = StateProvider<int>((ref) => 0);

// Reklam anlaşması: AYLIK 3 hak (ay başında sıfırlanır).
const int kAdDealsPerMonth = 3;
final adDealsUsedThisMonthProvider = StateProvider<int>((ref) => 0);

// Tatil/mola AYLIK 1 hak (ay başında sıfırlanır)
final vacationUsedThisMonthProvider = StateProvider<bool>((ref) => false);

// İlk kez yeni kariyere başlayınca "Nasıl Oynanır?" otomatik gösterildi mi
// (oturum içi; her uygulama açılışında en fazla 1 kez).
final onboardingShownProvider = StateProvider<bool>((ref) => false);

// Oynanış ipuçları (oynadıkça ara ara pop-up olarak çıkar)
const List<String> kGameTips = [
  'Bekleyen bir karar varsa haftaya geçemezsin — Sosyal sekmesinden yanıtla.',
  'Şarkı çıkarmak ekibi yorar. Yorgunluk 80\'i geçince yeni şarkı çıkamazsın; tatil ver.',
  'İtibarın düşük, skandalın yüksekse konser ZARAR edebilir. Önce itibarı toparla.',
  'Bir üyenin morali çok düşerse ayrılmak ister. Detayından "Birebir İlgi" ile moral ver.',
  'Reklam anlaşması ayda 3 hak verir — hızlı para ama imajı yıpratır.',
  'Büyüdükçe "prestij vergisi" tüm masrafları artırır — gelirini gidere göre planla.',
  'Albümde kaliteli single\'ları topla; hit albüm "Yılın Grubu" için şart.',
  'Sponsor seçerken sadece parayı değil, itibar ve fandom etkisini de düşün.',
  'Cüzdana dokunarak Mali Geçmiş\'i açıp paranın nereye gittiğini görebilirsin.',
  'Fandom sadakati yüksekse konser bileti daha çok satar; skandal onu düşürür.',
  'Rakip bir üyeni transfer etmek isterse maaş zammı ya da ilişkiyle tutabilirsin.',
  'Tatil ekibin tamamını dinlendirir ama ayda 1 hakkın var — idareli kullan.',
];
final tipIndexProvider = StateProvider<int>((ref) => 0);
final lastTipAbsWeekProvider = StateProvider<int>((ref) => -99);

// Eleme aşamasında son interaktif prova değerlendirmesinin haftası
final lastPracticeWeekProvider = StateProvider<int>((ref) => -99);

// --- ŞARKI TÜRLERİ ---
const List<String> kSongGenres = [
  'K-Pop',
  'Ballad',
  'R&B',
  'Dance',
  'Hip-Hop',
  'Pop',
  'Synth-Pop',
  'EDM',
];

// Comeback konseptleri: şarkının görsel/kavramsal kimliği. Çıkışı etkiler.
class ComebackConcept {
  final String key, label, hint;
  final Color color;
  final int qBonus, repBonus, scandal;
  final double follMult, popMult;
  const ComebackConcept(this.key, this.label, this.hint, this.color,
      {this.qBonus = 0,
      this.repBonus = 0,
      this.scandal = 0,
      this.follMult = 1.0,
      this.popMult = 1.0});
}

const List<ComebackConcept> kComebackConcepts = [
  ComebackConcept(
      'cute', '🎀 Cute', 'Sevimli — fandom & takipçi', AppColors.secondary,
      qBonus: 3, follMult: 1.18),
  ComebackConcept(
      'girlcrush', '🔥 Girl-Crush', 'Güçlü — erişim & itibar', AppColors.bordo,
      qBonus: 4, popMult: 1.22, repBonus: 2),
  ComebackConcept(
      'retro', '🕰️ Retro', 'Nostaljik — itibar & geniş kitle', AppColors.gold,
      qBonus: 5, follMult: 1.06, popMult: 1.06, repBonus: 3),
  ComebackConcept('hype', '⚡ Y2K Hype', 'Patlayıcı — takipçi ama skandal riski',
      AppColors.accentBlue,
      qBonus: 2, follMult: 1.28, popMult: 1.12, scandal: 6),
];

// Mutlak ay/hafta yardımcıları (cooldown ve chart seed için)
int absMonthOf(PlayerCareer c) => (c.currentYear - 1) * 12 + c.currentMonth;
int absWeekOf(PlayerCareer c) => (absMonthOf(c) - 1) * 4 + c.currentWeek;

// Mutlak ayı "5. yıl 2. ay" etiketine çevirir.
String monthYearLabel(int absMonth) {
  if (absMonth < 1) return '$absMonth. ay';
  final y = (absMonth - 1) ~/ 12 + 1;
  final m = (absMonth - 1) % 12 + 1;
  return '$y. yıl $m. ay';
}

// --- VERİ PROVIDER'LARI ---
final walletProvider = FutureProvider.autoDispose<int>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return 0;
  final w = await (db.select(db.currencyWallets)
        ..where((t) => t.careerId.equals(career.id)))
      .getSingleOrNull();
  return w?.fanPoints ?? 0;
});

final traineeCampProvider =
    FutureProvider.autoDispose<List<GeneratedCharacter>>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return [];

  final myIdols = await (db.select(db.playerIdols)
        ..where((t) => t.careerId.equals(career.id)))
      .get();
  final hiredCharIds = myIdols.map((i) => i.characterId).toSet();

  // Sadece müsait adaylar (başka ajansa gidenler 'left' → görünmez)
  final all = await (db.select(db.generatedCharacters)
        ..where((t) =>
            t.careerId.equals(career.id) & t.recruitStatus.equals('available')))
      .get();
  final pool = all.where((t) => !hiredCharIds.contains(t.id)).toList();
  // Popüler adaylar üstte (cazip fırsatlar görünür olsun)
  pool.sort((a, b) => b.startingFame.compareTo(a.startingFame));
  return pool;
});

final myInventoryProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return [];

  final query = db.select(db.playerIdols).join([
    drift.innerJoin(db.generatedCharacters,
        db.generatedCharacters.id.equalsExp(db.playerIdols.characterId))
  ])
    ..where(db.playerIdols.careerId.equals(career.id) &
        db.playerIdols.status.equals('active'));

  final result = await query.get();
  return result
      .map((row) => {
            'idol': row.readTable(db.playerIdols),
            'character': row.readTable(db.generatedCharacters),
          })
      .toList();
});

final coachPoolProvider = FutureProvider.autoDispose<List<Coach>>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return [];
  return await (db.select(db.coaches)
        ..where((t) => t.careerId.equals(career.id))
        ..orderBy([
          (t) => drift.OrderingTerm(expression: t.discipline),
          (t) => drift.OrderingTerm(expression: t.monthlySalary),
        ]))
      .get();
});

// Grup panosu için toplu veri
class GroupDashboard {
  final Group group;
  final List<({PlayerIdol idol, GeneratedCharacter char, String position})>
      members;
  final int power;
  final int chem;
  final String rivalName;
  final int rivalPop;
  GroupDashboard({
    required this.group,
    required this.members,
    required this.power,
    required this.chem,
    required this.rivalName,
    required this.rivalPop,
  });
}

final groupDashboardProvider =
    FutureProvider.autoDispose<GroupDashboard?>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return null;

  final gm = GroupManager(db);
  final g = await gm.getActiveGroup(career.id);
  if (g == null) return null;

  final members = await gm.membersFull(g.id);
  final ids = members.map((m) => m.idol.id).toList();
  final power = members.isEmpty
      ? 0
      : (members
                  .map((m) => gm.memberOverall(m.idol, m.char))
                  .fold<int>(0, (s, o) => s + o) /
              members.length)
          .round();
  final chem = await gm.avgChemistryForIds(ids);
  final rival = await gm.rivalStatusAt(absMonthOf(career));

  return GroupDashboard(
    group: g,
    members: members,
    power: power,
    chem: chem,
    rivalName: rival.name,
    rivalPop: rival.popularity,
  );
});

/// Hafif kontrol: aktif grup var mı? Kamp/Şirket kilidi için kullanılır.
final hasActiveGroupProvider = FutureProvider.autoDispose<bool>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return false;
  final g = await (db.select(db.groups)
        ..where((t) => t.careerId.equals(career.id) & t.status.equals('active'))
        ..limit(1))
      .getSingleOrNull();
  return g != null;
});

final songsProvider = FutureProvider.autoDispose<List<Song>>((ref) async {
  final db = ref.watch(databaseProvider);
  final dash = ref.watch(groupDashboardProvider).value;
  if (dash == null) return [];
  return SongManager(db).getSongsForGroup(dash.group.id);
});

// Albümler + albüme girmemiş ("single") şarkı sayısı
final albumsProvider = FutureProvider.autoDispose<List<Album>>((ref) async {
  final db = ref.watch(databaseProvider);
  final dash = ref.watch(groupDashboardProvider).value;
  if (dash == null) return [];
  return AlbumManager(db).getAlbums(dash.group.id);
});

final eligibleSongCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final db = ref.watch(databaseProvider);
  final dash = ref.watch(groupDashboardProvider).value;
  if (dash == null) return 0;
  final songs = await AlbumManager(db).eligibleSongs(dash.group.id);
  return songs.length;
});

final chartProvider = FutureProvider.autoDispose<List<ChartEntry>>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return [];
  return SongManager(db)
      .generateChartEntries(career.id, absMonthOf(career), absWeekOf(career));
});

// Üyeler & İlişkiler ekranı için toplu veri
class MemberRelations {
  final List<
      ({
        PlayerIdol idol,
        GeneratedCharacter char,
        String position,
        int fame
      })> members;
  final Map<String, int> chem; // 'minId_maxId' -> skor
  final int centerIdolId;
  MemberRelations(this.members, this.chem, this.centerIdolId);
}

String _chemKey(int a, int b) => a < b ? '${a}_$b' : '${b}_$a';

final memberRelationsProvider =
    FutureProvider.autoDispose<MemberRelations?>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return null;
  final gm = GroupManager(db);
  final g = await gm.getActiveGroup(career.id);
  if (g == null) return null;

  final raw = await gm.membersFull(g.id);
  if (raw.isEmpty) return null;

  final members = raw
      .map((m) => (
            idol: m.idol,
            char: m.char,
            position: m.position,
            fame: m.char.startingFame + m.idol.popularityBonus,
          ))
      .toList()
    ..sort((a, b) => b.fame.compareTo(a.fame));

  final ids = members.map((m) => m.idol.id).toList();
  final rels = await (db.select(db.chemistryRelations)
        ..where((t) => t.idolAId.isIn(ids) & t.idolBId.isIn(ids)))
      .get();
  final chem = <String, int>{
    for (final r in rels) _chemKey(r.idolAId, r.idolBId): r.chemistryScore
  };

  return MemberRelations(members, chem, members.first.idol.id);
});

// Yedek idoller: şirkette aktif olup grupta olmayan idoller (kadro yönetimi)
final benchIdolsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return [];
  final gm = GroupManager(db);
  final g = await gm.getActiveGroup(career.id);
  if (g == null) return [];

  // Gruptaki aktif idol id'leri
  final inGroup = await (db.select(db.groupMembers)
        ..where((t) => t.groupId.equals(g.id) & t.leaveMonth.isNull()))
      .get();
  final inGroupIds = inGroup.map((m) => m.idolId).toSet();

  // Yedek havuzu: elenen/yedeğe alınan idoller (reserve) + grupta olmayan aktifler
  final rows = await (db.select(db.playerIdols).join([
    drift.innerJoin(db.generatedCharacters,
        db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
  ])
        ..where(db.playerIdols.careerId.equals(career.id) &
            (db.playerIdols.status.equals('active') |
                db.playerIdols.status.equals('reserve'))))
      .get();

  return rows
      .where((r) => !inGroupIds.contains(r.readTable(db.playerIdols).id))
      .map((r) => {
            'idol': r.readTable(db.playerIdols),
            'character': r.readTable(db.generatedCharacters),
          })
      .toList();
});

// ── İNTERAKTİF PROVA (eleme): yetenek seç → şarkı seç → herkesin performansı ──
// Yetenek: 0=Vokal, 1=Dans, 2=Rap
const List<({String label, IconData icon, Color color})> kPracticeSkills = [
  (label: 'Vokal', icon: Icons.mic, color: AppColors.primary),
  (label: 'Dans', icon: Icons.directions_run, color: AppColors.secondary),
  (label: 'Rap', icon: Icons.graphic_eq, color: AppColors.accentBlue),
];

/// Seçilen yetenek + şarkıya göre tüm aktif stajyerleri puanlar, o yeteneğe
/// küçük bir gelişim verir, sıralı liste döner (en iyi üstte).
Future<List<({String name, String? image, String rarity, int score})>>
    evaluatePractice(
        AppDatabase db, int careerId, int skill, int songSeed) async {
  final rows = await (db.select(db.playerIdols).join([
    drift.innerJoin(db.generatedCharacters,
        db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
  ])
        ..where(db.playerIdols.careerId.equals(careerId) &
            db.playerIdols.status.equals('active')))
      .get();
  final rng = Random(songSeed);
  final out = <({String name, String? image, String rarity, int score})>[];
  for (final r in rows) {
    final ch = r.readTable(db.generatedCharacters);
    final idol = r.readTable(db.playerIdols);
    final base = switch (skill) {
      0 => ch.vocalSkill + idol.vocalBonus,
      1 => ch.danceSkill + idol.danceBonus,
      _ => ch.rapSkill + idol.rapBonus,
    };
    // Şarkıya göre değişen varyans (seed sabit → aynı şarkıda tutarlı)
    final score = (base + rng.nextInt(16)).clamp(0, 130);
    // Bu yeteneğe küçük kalıcı gelişim (provanın faydası)
    final boost = 1 + rng.nextInt(3);
    final comp = switch (skill) {
      0 =>
        PlayerIdolsCompanion(vocalBonus: drift.Value(idol.vocalBonus + boost)),
      1 =>
        PlayerIdolsCompanion(danceBonus: drift.Value(idol.danceBonus + boost)),
      _ => PlayerIdolsCompanion(rapBonus: drift.Value(idol.rapBonus + boost)),
    };
    await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
        .write(comp);
    out.add(
        (name: ch.name, image: ch.imagePath, rarity: ch.rarity, score: score));
  }
  out.sort((a, b) => b.score.compareTo(a.score));
  return out;
}

/// İnteraktif prova akışı: yetenek seç → şarkı seç → herkesin performansı.
Future<void> runInteractivePractice(BuildContext context, WidgetRef ref) async {
  // 1) Yetenek seç (istemeyen "Boş Geç" ile atlayabilir)
  final skill = await showDialog<int>(
    context: context,
    builder: (dctx) => AlertDialog(
      title: const Text('🎯 Bu Hafta Neyi Değerlendirelim?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(kPracticeSkills.length, (i) {
          final s = kPracticeSkills[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: s.color),
                icon: Icon(s.icon, size: 18),
                label: Text(s.label),
                onPressed: () => Navigator.pop(dctx, i),
              ),
            ),
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dctx),
          child:
              Text('Boş Geç', style: TextStyle(color: AppColors.textSecondary)),
        ),
      ],
    ),
  );
  if (skill == null || !context.mounted) return;

  // 2) Şarkı seç (3 rastgele)
  final pool = [..._practiceSongs]..shuffle();
  final options = pool.take(3).toList();
  final song = await showDialog<String>(
    context: context,
    builder: (dctx) => AlertDialog(
      title: Text(
          '🎵 Hangi Şarkıyla Test Edelim? (${kPracticeSkills[skill].label})'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: options
            .map((sg) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dctx, sg),
                      child: Text(sg),
                    ),
                  ),
                ))
            .toList(),
      ),
    ),
  );
  if (song == null || !context.mounted) return;

  // 3) Performansları hesapla + göster
  final db = ref.read(databaseProvider);
  final career = ref.read(activeCareerProvider).value;
  if (career == null) return;
  final results = await evaluatePractice(db, career.id, skill, song.hashCode);
  ref.invalidate(myInventoryProvider);
  if (!context.mounted) return;
  await showDialog(
    context: context,
    builder: (dctx) => AlertDialog(
      title: Text('📊 "$song" — ${kPracticeSkills[skill].label} Performansı'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380, maxHeight: 420),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < results.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 22,
                          child: Text('${i + 1}.',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold))),
                      CharacterAvatar(
                          imagePath: results[i].image,
                          initial: results[i].name,
                          size: 32,
                          tint: AppTheme.rarityColor(results[i].rarity)
                              .withAlpha(40)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(results[i].name,
                              overflow: TextOverflow.ellipsis)),
                      Text('${results[i].score}',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: i == 0
                                  ? AppColors.success
                                  : (i == results.length - 1
                                      ? AppColors.danger
                                      : AppColors.ink))),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(dctx), child: const Text('Tamam')),
      ],
    ),
  );
}

const List<String> _practiceSongs = [
  'Gece Yarısı',
  'Kalp Atışı',
  'Neon Rüya',
  'Son Dans',
  'Yıldız Tozu',
  'Fırtına',
  'İlk Aşk',
  'Sahne Işıkları',
  'Geri Dönüş',
  'Cesaret',
];

// ── Sosyal medya gönderileri (DB'de BİRİKİR, her hafta yeni eklenir) ──
final socialPostsProvider =
    FutureProvider.autoDispose<List<SocialPost>>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return [];
  return (db.select(db.socialPosts)
        ..where((t) => t.careerId.equals(career.id))
        ..orderBy([
          (t) => drift.OrderingTerm.desc(t.absWeek),
          (t) => drift.OrderingTerm.desc(t.id)
        ]))
      .get();
});

// Açılan başarımlar (grup ekranı rozetleri)
final achievementsProvider =
    FutureProvider.autoDispose<List<Achievement>>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return [];
  return AchievementManager(db).getForCareer(career.id);
});

// Prestij vergisi çarpanı (takipçi+popülariteyle masraflar artar)
final costMultProvider = Provider.autoDispose<double>((ref) {
  final g = ref.watch(groupDashboardProvider).value?.group;
  if (g == null) return 1.0;
  return GroupManager.costMultiplierFor(g.socialFollowers, g.totalPopularity);
});

// İdol maaş dökümü (grup sekmesi)
final salaryBreakdownProvider = FutureProvider.autoDispose<
    ({
      List<({String name, String rarity, int base, int bonus, int total})> rows,
      double growthMult,
      int total
    })>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) {
    return (
      rows: <({String name, String rarity, int base, int bonus, int total})>[],
      growthMult: 1.0,
      total: 0
    );
  }
  return SongManager(db).idolSalaryBreakdown(career.id);
});

// Genel (kalıcı) başarımlar — ana menüde, kariyerler-üstü
final globalAchievementsProvider =
    FutureProvider.autoDispose<Set<String>>((ref) async {
  final db = ref.watch(databaseProvider);
  return GlobalAchievementManager(db).unlockedKeys();
});

// Mali işlem geçmişi (en yeni ay üstte)
final transactionsProvider =
    FutureProvider.autoDispose<List<Transaction>>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return [];
  return (db.select(db.transactions)
        ..where((t) => t.careerId.equals(career.id))
        ..orderBy([
          (t) => drift.OrderingTerm.desc(t.absMonth),
          (t) => drift.OrderingTerm.desc(t.id)
        ]))
      .get();
});

// Kazanılan ödüller (kategori 'award' olaylar — yıllık + aylık garip ödüller)
final awardsProvider = FutureProvider.autoDispose<List<Event>>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return [];
  return (db.select(db.events)
        ..where(
            (t) => t.careerId.equals(career.id) & t.category.equals('award'))
        ..orderBy([(t) => drift.OrderingTerm.desc(t.id)]))
      .get();
});

// Bekleyen karar olayları (sosyal sekmesi + appbar rozeti)
final pendingEventsProvider =
    FutureProvider.autoDispose<List<Event>>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return [];
  return (db.select(db.events)
        ..where((t) =>
            t.careerId.equals(career.id) &
            t.requiresDecision.equals(true) &
            t.resolved.equals(false))
        ..orderBy([(t) => drift.OrderingTerm.desc(t.id)]))
      .get();
});

// Tüm olay akışı (haber + çözülmüş olaylar)
final eventFeedProvider = FutureProvider.autoDispose<List<Event>>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return [];
  return (db.select(db.events)
        ..where((t) => t.careerId.equals(career.id))
        ..orderBy([(t) => drift.OrderingTerm.desc(t.id)])
        ..limit(50))
      .get();
});

// Konser/tur uygunluğu
final concertEligibilityProvider =
    FutureProvider.autoDispose<ConcertEligibility?>((ref) async {
  final db = ref.watch(databaseProvider);
  final career = ref.watch(activeCareerProvider).value;
  if (career == null) return null;
  return ConcertManager(db).checkEligibility(career.id);
});

String _phaseLabel(String phase, int companyCount) {
  switch (phase) {
    case 'recruiting':
      return 'Seçmeler: $companyCount/$kRecruitTarget';
    case 'elimination':
      return 'Eleme: $companyCount → $kElimTarget';
    default:
      return 'Şirket: $companyCount';
  }
}

String positionTr(String p) {
  switch (p) {
    case 'leader':
      return 'Lider';
    case 'main_vocal':
      return 'Ana Vokal';
    case 'lead_dancer':
      return 'Lider Dansçı';
    case 'rapper':
      return 'Rapçi';
    case 'visual':
      return 'Visual';
    default:
      return 'Üye';
  }
}

// Oyun içinde miyiz (true) yoksa ana menüde mi (false)?
final inGameProvider = StateProvider<bool>((ref) => false);

// Efekt sesleri aç/kapa (Ayarlar)
final soundEnabledProvider = StateProvider<bool>((ref) => true);

// Kariyer geçmişi
final careerHistoryProvider =
    FutureProvider.autoDispose<List<CareerHistory>>((ref) async {
  final db = ref.watch(databaseProvider);
  return (db.select(db.careerHistories)
        ..orderBy([(t) => drift.OrderingTerm.desc(t.careerNumber)]))
      .get();
});

// Koyu tema seçimi (Ayarlar'dan; kalıcı — shared_preferences)
final darkThemeProvider = StateProvider<bool>((ref) => AppColors.dark);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // GEÇİCİ SATIR: Eski test kayıtlarını temizlemek için hafızayı True'ya zorluyoruz
  // Uygulama bir kez koyu modda açıldıktan sonra bu satırı tamamen silebilirsin.
  await prefs.setBool('darkTheme', true);

  AppColors.dark = prefs.getBool('darkTheme') ?? true;
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tema değişince tüm uygulama yeniden kurulup renkler tazelensin
    final dark = ref.watch(darkThemeProvider);
    return MaterialApp(
      key: ValueKey('theme-$dark'),
      title: 'Girlband Menajer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // BURASI DEĞİŞTİ: dark değişkenini GameBackground'a gönderiyoruz
      builder: (context, child) =>
          GameBackground(dark: dark, child: child ?? const SizedBox()),
      home: const SplashScreen(),
    );
  }
}

// ── YENİ SPLASH (GİRİŞ) EKRANI ──
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    // 3 saniye sonra Ana Menüye / Oyuna Geç
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const RootScreen()));
      }
    });
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tema durumunu al (Koyu mu Açık mı)
    final isDark = AppColors.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: FadeInUp(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // BAŞLIK
              Text(
                'GIRL BAND\nSIMULATOR',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: isDark ? Colors.white : AppColors.ink,
                  shadows: [
                    Shadow(
                      color: isDark
                          ? AppColors.secondary
                          : AppColors.primary.withAlpha(80),
                      blurRadius: isDark ? 20 : 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ALT YAZI 1
              Text(
                'Yıldız Ajans kapılarını açıyor...',
                style: TextStyle(
                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(flex: 1),

              // GRUP İKONU
              Icon(
                Icons.groups,
                size: 150,
                color: isDark
                    ? AppColors.primary.withAlpha(150)
                    : AppColors.primary.withAlpha(200),
              ),

              const Spacer(flex: 1),

              // SES DALGASI (WAVEFORM) ANİMASYONU
              Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                    // Koyu modda yarı saydam siyah, açık modda yarı saydam beyaz/mor
                    color: isDark
                        ? Colors.black45
                        : AppColors.surfaceHigh.withAlpha(180),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                                color: AppColors.primary.withAlpha(30),
                                blurRadius: 10)
                          ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(15, (index) {
                    return AnimatedBuilder(
                        animation: _animCtrl,
                        builder: (context, child) {
                          final height = 10 +
                              math.sin(
                                      (_animCtrl.value * 2 * math.pi) + index) *
                                  15;
                          return Container(
                            width: 4,
                            height: height.abs(),
                            decoration: BoxDecoration(
                                color: index > 8
                                    ? AppColors.secondary
                                    : AppColors.primary,
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                      color: isDark
                                          ? AppColors.secondary
                                          : AppColors.primary.withAlpha(100),
                                      blurRadius: 4)
                                ]),
                          );
                        });
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // ALT YAZI 2
              Text(
                'Melodiler yükleniyor...',
                style: TextStyle(
                  color: isDark ? Colors.white54 : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inGame = ref.watch(inGameProvider);
    return inGame ? const DashboardScreen() : const MainMenuScreen();
  }
}

String discTr(String d) {
  switch (d) {
    case 'vocal':
      return 'Vokal';
    case 'dance':
      return 'Dans';
    case 'rap':
      return 'Rap';
    default:
      return d;
  }
}

// Gizli seçme puanını harf notuna çevirir (kesin sayı gösterilmez).
({String letter, Color color}) auditionGrade(int score) {
  if (score >= 90) return (letter: 'S', color: Colors.purple);
  if (score >= 80) return (letter: 'A', color: Colors.red);
  if (score >= 70) return (letter: 'B', color: Colors.deepOrange);
  if (score >= 60) return (letter: 'C', color: Colors.orange);
  if (score >= 50) return (letter: 'D', color: Colors.blueGrey);
  return (letter: 'F', color: Colors.grey);
}

// İlişki skorunu etiket + renge çevirir.
({String label, Color color}) relationshipStyle(int score) {
  if (score >= 60) return (label: 'Can dostu', color: Colors.green);
  if (score >= 30) return (label: 'Yakın', color: Colors.lightGreen);
  if (score > -30) return (label: 'Nötr', color: Colors.blueGrey);
  if (score > -60) return (label: 'Gergin', color: Colors.orange);
  return (label: 'Düşman', color: Colors.red);
}

// Bir idolün SADECE mevcut grup arkadaşlarıyla kimyasını yükler
// (elenmiş/ayrılmış eski stajyerler gösterilmez).
Future<List<({String name, int score})>> loadChemistryFor(
    AppDatabase db, int idolId) async {
  // İdolün aktif grubundaki diğer üyelerin id'leri
  final myIdol = await (db.select(db.playerIdols)
        ..where((t) => t.id.equals(idolId)))
      .getSingleOrNull();
  if (myIdol == null) return [];
  final g = await GroupManager(db).getActiveGroup(myIdol.careerId);
  if (g == null) return [];
  final gmRows = await (db.select(db.groupMembers)
        ..where((t) => t.groupId.equals(g.id) & t.leaveMonth.isNull()))
      .get();
  final memberIds =
      gmRows.map((m) => m.idolId).where((id) => id != idolId).toSet();
  if (memberIds.isEmpty) return [];

  final rels = await (db.select(db.chemistryRelations)
        ..where((t) => t.idolAId.equals(idolId) | t.idolBId.equals(idolId)))
      .get();

  final out = <({String name, int score})>[];
  for (final r in rels) {
    final otherId = r.idolAId == idolId ? r.idolBId : r.idolAId;
    if (!memberIds.contains(otherId)) continue; // sadece grup arkadaşları
    final row = await (db.select(db.playerIdols).join([
      drift.innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId))
    ])
          ..where(db.playerIdols.id.equals(otherId)))
        .getSingleOrNull();
    if (row == null) continue;
    final ch = row.readTable(db.generatedCharacters);
    out.add((name: ch.name, score: r.chemistryScore));
  }
  out.sort((a, b) => b.score.compareTo(a.score));
  return out;
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final careerState = ref.watch(activeCareerProvider);

    return careerState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Hata: $err'))),
      data: (career) {
        if (career == null) {
          // Kariyer bitti (grup dağıldı vb.) → ana menüye dön
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Bu kariyer sona erdi.',
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.home),
                    label: const Text('Ana Menü'),
                    onPressed: () =>
                        ref.read(inGameProvider.notifier).state = false,
                  ),
                ],
              ),
            ),
          );
        }
        return _GameScaffold(career: career);
      },
    );
  }
}

class _GameScaffold extends ConsumerWidget {
  final PlayerCareer career;
  const _GameScaffold({required this.career});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider).value ?? 0;
    final companyCount = ref.watch(myInventoryProvider).value?.length ?? 0;
    final elimThisMonth = ref.watch(eliminatedThisMonthProvider);
    final hiredCoaches =
        ref.watch(coachPoolProvider).value?.where((c) => c.isHired).length ?? 0;
    final season = seasonForMonth(career.currentMonth);

    final isFreshCareer = career.phase == 'recruiting' &&
        companyCount == 0 &&
        career.currentWeek == 1 &&
        career.currentMonth == 1 &&
        career.currentYear == 1;
    if (isFreshCareer && !ref.read(onboardingShownProvider)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        if (ref.read(onboardingShownProvider)) return;
        ref.read(onboardingShownProvider.notifier).state = true;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const HowToPlayScreen()));
      });
    }

    String? advanceBlock;
    if (career.phase == 'recruiting' && companyCount < kRecruitTarget) {
      advanceBlock =
          '$kRecruitTarget kişi seçmeden zaman atlayamazsın (şu an $companyCount).';
    } else if (career.phase == 'elimination' &&
        companyCount > kElimTarget &&
        career.currentWeek == 4 &&
        elimThisMonth < kElimPerMonth) {
      advanceBlock =
          'Ay sonu: zaman atlamadan önce $kElimPerMonth kişi elemelisin (Kamp sekmesi).';
    } else if (career.phase == 'elimination' && hiredCoaches == 0) {
      advanceBlock =
          'Zaman atlamadan önce en az 1 koç tut (Koçlar sekmesi) — yoksa kimse gelişmez.';
    }

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.headerGradient,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(AppColors.dark ? 150 : 60),
                    blurRadius: 15,
                    offset: const Offset(0, 4))
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 16,
          title: Row(
            children: [
              InkWell(
                onTap: () => ref.read(inGameProvider.notifier).state = false,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh.withAlpha(150),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColors.primary.withAlpha(120), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withAlpha(60),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: const Icon(Icons.home_rounded,
                      color: AppColors.gold, size: 24),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(career.agencyName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const FinanceHistoryScreen())),
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.account_balance_wallet_rounded,
                              size: 16, color: AppColors.accentCyan),
                          const SizedBox(width: 6),
                          AnimatedCount(wallet,
                              formatter: (n) => '$n ₺',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  color: AppColors.accentCyan)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Builder(
              builder: (ctx) {
                final pending =
                    ref.watch(pendingEventsProvider).value?.length ?? 0;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_rounded,
                          color: Colors.white, size: 28),
                      tooltip: 'Olaylar',
                      onPressed: () =>
                          DefaultTabController.of(ctx).animateTo(5),
                    ),
                    if (pending > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: AppColors.danger,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                              boxShadow: const [
                                BoxShadow(color: Colors.red, blurRadius: 4)
                              ]),
                          constraints:
                              const BoxConstraints(minWidth: 20, minHeight: 20),
                          child: Text('$pending',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900)),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(width: 4),
            Builder(
              builder: (ctx) {
                final pendingBlock =
                    (ref.watch(pendingEventsProvider).value?.length ?? 0) > 0;
                final isBlocked = advanceBlock != null || pendingBlock;

                return Padding(
                  padding:
                      const EdgeInsets.only(right: 16, top: 18, bottom: 18),
                  child: InkWell(
                    onTap: () async {
                      // ... (Arkadaşının aynı Hafta ilerletme logic'i kalsın, sadece görünüm değişiyor)
                      if (advanceBlock != null) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text(advanceBlock!)));
                        return;
                      }
                      final pendingNow =
                          ref.read(pendingEventsProvider).value?.length ?? 0;
                      if (pendingNow > 0) {
                        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                          content: Text(
                              '🔔 $pendingNow karar bekliyor. İlerlemeden önce yanıtla.'),
                          action: SnackBarAction(
                              label: 'GÖR',
                              onPressed: () =>
                                  DefaultTabController.of(ctx).animateTo(5)),
                        ));
                        return;
                      }
                      final tabController = DefaultTabController.of(ctx);
                      final messenger = ScaffoldMessenger.of(ctx);
                      messenger.showSnackBar(const SnackBar(
                          content: Text('Hafta ilerliyor...'),
                          duration: Duration(seconds: 60)));

                      final report = await ref
                          .read(activeCareerProvider.notifier)
                          .nextWeek();
                      messenger.clearSnackBars();

                      ref.read(prUsedThisWeekProvider.notifier).state = 0;
                      if (report?.isNewMonth ?? false) {
                        ref.read(eliminatedThisMonthProvider.notifier).state =
                            0;
                        ref.read(adDealsUsedThisMonthProvider.notifier).state =
                            0;
                        ref.read(vacationUsedThisMonthProvider.notifier).state =
                            false;
                      }

                      ref.invalidate(traineeCampProvider);
                      ref.invalidate(myInventoryProvider);
                      ref.invalidate(walletProvider);
                      ref.invalidate(coachPoolProvider);
                      ref.invalidate(groupDashboardProvider);
                      ref.invalidate(hasActiveGroupProvider);
                      ref.invalidate(songsProvider);
                      ref.invalidate(chartProvider);
                      ref.invalidate(pendingEventsProvider);
                      ref.invalidate(eventFeedProvider);
                      ref.invalidate(concertEligibilityProvider);
                      ref.invalidate(memberRelationsProvider);
                      ref.invalidate(albumsProvider);
                      ref.invalidate(eligibleSongCountProvider);
                      ref.invalidate(transactionsProvider);

                      if (career.phase == 'elimination' && ctx.mounted) {
                        final cur = ref.read(activeCareerProvider).value;
                        if (cur != null) {
                          final curW = absWeekOf(cur);
                          final lastP = ref.read(lastPracticeWeekProvider);
                          if (curW - lastP >= 2) {
                            ref.read(lastPracticeWeekProvider.notifier).state =
                                curW;
                            try {
                              await runInteractivePractice(ctx, ref);
                            } catch (_) {}
                          }
                        }
                      }

                      if (report != null && ctx.mounted) {
                        if (report.groupDisbanded) {
                          showDialog(
                              context: ctx,
                              builder: (dctx) => AlertDialog(
                                    title: const Text('🔴 Grup Dağıldı!',
                                        style: TextStyle(color: Colors.red)),
                                    content: const Text(
                                        'Grup ayakta kalamadı (maaş borcu, üye kaçışı ya da skandal). Kariyer sona erdi.\n\nAna menüden yeni bir kariyer başlatabilirsin.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            final container =
                                                ProviderScope.containerOf(dctx,
                                                    listen: false);
                                            Navigator.pop(dctx);
                                            container
                                                .read(inGameProvider.notifier)
                                                .state = false;
                                          },
                                          child: const Text('Ana Menü')),
                                    ],
                                  ));
                          return;
                        }

                        if (report.awardWon) {
                          final gName = ref
                                  .read(groupDashboardProvider)
                                  .value
                                  ?.group
                                  .groupName ??
                              'Grubun';
                          Navigator.of(ctx).push(MaterialPageRoute(
                              builder: (_) =>
                                  AwardCeremonyScreen(groupName: gName)));
                        }

                        if (report.careerGoalReached) {
                          playConfetti(ctx, big: true);
                          showDialog(
                              context: ctx,
                              builder: (dctx) => AlertDialog(
                                    title: const Text('🎉 OYUNU KAZANDIN!',
                                        style: TextStyle(color: Colors.amber)),
                                    content: const Text(
                                        'Bir kariyerde tüm çekirdek başarımları açtın — ana hedef tamamlandı!\n\nEfsane bir menajersin. İstersen bu kariyeri sürdürebilir ya da yeni bir kariyerle genel başarımları kovalayabilirsin.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.pop(dctx),
                                          child: const Text('Muhteşem!'))
                                    ],
                                  ));
                        } else if (report.newGlobalAchievements.isNotEmpty) {
                          playConfetti(ctx, big: true);
                          showDialog(
                              context: ctx,
                              builder: (dctx) => AlertDialog(
                                    title:
                                        const Text('🌟 Genel Başarım Açıldı!'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: report.newGlobalAchievements
                                          .map((t) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3),
                                              child: Text('• $t',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700))))
                                          .toList(),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.pop(dctx),
                                          child: const Text('Harika!'))
                                    ],
                                  ));
                        }

                        if (report.newspaperHeadline != null) {
                          showDialog(
                              context: ctx,
                              builder: (dctx) => NewspaperDialog(
                                  headline: report.newspaperHeadline!));
                        }

                        if (report.monthlyAward != null) {
                          playConfetti(ctx);
                          showDialog(
                              context: ctx,
                              builder: (dctx) =>
                                  _AwardDialog(title: report.monthlyAward!));
                        }

                        if (report.victoryAvailable) {
                          showDialog(
                              context: ctx,
                              barrierDismissible: false,
                              builder: (dctx) => AlertDialog(
                                    title: const Text('👑 Zirvedesin!',
                                        style: TextStyle(color: Colors.amber)),
                                    content: const Text(
                                        'Rakibini geçtin ve Yılın Grubu oldun — efsane bir kariyer!\n\nKariyeri burada zaferle taçlandırmak ister misin, yoksa hükümranlığını sürdürmeye devam mı edeceksin?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.pop(dctx),
                                          child: const Text('Devam Et')),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.amber.shade700,
                                            foregroundColor: Colors.white),
                                        onPressed: () async {
                                          final container =
                                              ProviderScope.containerOf(dctx,
                                                  listen: false);
                                          final db =
                                              container.read(databaseProvider);
                                          final c = container
                                              .read(activeCareerProvider)
                                              .value;
                                          if (c != null)
                                            await GameClock(db).endCareer(c.id);
                                          container
                                              .invalidate(activeCareerProvider);
                                          container.invalidate(
                                              careerHistoryProvider);
                                          if (dctx.mounted) Navigator.pop(dctx);
                                          container
                                              .read(inGameProvider.notifier)
                                              .state = false;
                                        },
                                        child:
                                            const Text('Kariyeri Taçlandır 👑'),
                                      ),
                                    ],
                                  ));
                          return;
                        }

                        if (report.departedMembers.isNotEmpty) {
                          ref.invalidate(socialPostsProvider);
                          showDialog(
                              context: ctx,
                              builder: (dctx) => _FlashNewsDialog(
                                  names: report.departedMembers));
                        }

                        if (report.lowMoraleWarnings.isNotEmpty) {
                          showDialog(
                              context: ctx,
                              builder: (dctx) => AlertDialog(
                                    title: const Text('😞 Moral Uyarısı'),
                                    content: Text(
                                        '${report.lowMoraleWarnings.join(", ")} morali çok düşük! İlgilenmen gerek — tatil ver, moral ver ya da başarı getir. Yoksa "ayrılmak istiyorum" diyebilirler.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.pop(dctx),
                                          child: const Text('Anladım'))
                                    ],
                                  ));
                        }

                        if (report.newAchievements.isNotEmpty) {
                          playConfetti(ctx);
                          showDialog(
                              context: ctx,
                              builder: (dctx) => AlertDialog(
                                    title: const Text('🏅 Başarım Açıldı!'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: report.newAchievements
                                          .map((t) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3),
                                              child: Text('• $t',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700))))
                                          .toList(),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.pop(dctx),
                                          child: const Text('Harika!'))
                                    ],
                                  ));
                        }

                        final scandalStr = report.scandalPressure
                            ? ' ⚠️ Skandal baskısı: grup geriliyor!'
                            : '';

                        if (report.isNewMonth) {
                          showDialog(
                              context: ctx,
                              builder: (dctx) =>
                                  _MonthlyReportDialog(report: report));
                        } else if (report.eventHeadlines.isNotEmpty) {
                          showDialog(
                              context: ctx,
                              builder: (dctx) => AlertDialog(
                                    title: const Text('📰 Bu Hafta'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...report.eventHeadlines.map((h) =>
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: Text(
                                                    h,
                                                    style: const TextStyle(
                                                        fontSize: 14)))),
                                        if (scandalStr.isNotEmpty)
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: Text(scandalStr.trim(),
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          AppColors.danger))),
                                      ],
                                    ),
                                    actions: [
                                      if (report.pendingDecisions > 0)
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(dctx);
                                              tabController.animateTo(5);
                                            },
                                            child: const Text('Kararı Gör')),
                                      TextButton(
                                          onPressed: () => Navigator.pop(dctx),
                                          child: const Text('Tamam')),
                                    ],
                                  ));
                        } else {
                          final cur = ref.read(activeCareerProvider).value;
                          if (cur != null &&
                              report.pendingDecisions == 0 &&
                              ctx.mounted) {
                            final curAbsWeek = absWeekOf(cur);
                            final lastTip = ref.read(lastTipAbsWeekProvider);
                            if (curAbsWeek - lastTip >= 3 &&
                                math.Random().nextDouble() < 0.6) {
                              final idx = ref.read(tipIndexProvider);
                              final tip = kGameTips[idx % kGameTips.length];
                              ref.read(tipIndexProvider.notifier).state =
                                  idx + 1;
                              ref.read(lastTipAbsWeekProvider.notifier).state =
                                  curAbsWeek;
                              showDialog(
                                  context: ctx,
                                  builder: (dctx) => AlertDialog(
                                        title: const Text('💡 İpucu'),
                                        content: Text(tip,
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(dctx),
                                              child: const Text('Anladım'))
                                        ],
                                      ));
                            }
                          }
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        gradient: isBlocked ? null : AppColors.goldGradient,
                        color: isBlocked
                            ? AppColors.surfaceHigh.withAlpha(100)
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isBlocked
                                ? Colors.transparent
                                : AppColors.gold.withAlpha(150),
                            width: 1.5),
                        boxShadow: isBlocked
                            ? []
                            : [
                                BoxShadow(
                                    color: AppColors.gold.withAlpha(90),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ],
                      ),
                      child: Row(
                        children: [
                          Text('İlerle',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: isBlocked
                                      ? Colors.white54
                                      : Colors.black87)),
                          const SizedBox(width: 4),
                          Icon(Icons.fast_forward_rounded,
                              size: 20,
                              color:
                                  isBlocked ? Colors.white54 : Colors.black87),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicatorPadding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            indicator: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.gold.withAlpha(120),
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ]),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.white.withAlpha(215),
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            tabs: const [
              Tab(icon: Icon(Icons.gite_rounded, size: 22), text: 'Kamp'),
              Tab(icon: Icon(Icons.star_rounded, size: 22), text: 'Şirket'),
              Tab(icon: Icon(Icons.school_rounded, size: 22), text: 'Koçlar'),
              Tab(icon: Icon(Icons.groups_rounded, size: 22), text: 'Grup'),
              Tab(
                  icon: Icon(Icons.music_note_rounded, size: 22),
                  text: 'Şarkılar'),
              Tab(icon: Icon(Icons.campaign_rounded, size: 22), text: 'Sosyal'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(AppColors.dark ? 120 : 30),
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded,
                      color: AppColors.gold, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Yıl ${career.currentYear} • Ay ${career.currentMonth} • Hafta ${career.currentWeek}   |   ${seasonLabel(season)}   |   ${_phaseLabel(career.phase, companyCount)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  _CampTab(),
                  _CompanyTab(),
                  _CoachesTab(),
                  _GroupTab(),
                  _SongsTab(),
                  _SocialTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grup kurulunca kilitli sekme ──────────────────────────────────────────
Widget _lockedByGroup(String message) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock, size: 56, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.grey)),
        ],
      ),
    ),
  );
}

// ============ SEKME 1: SEÇMELER → ELEME ============
class _CampTab extends ConsumerWidget {
  const _CampTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final career = ref.watch(activeCareerProvider).value;
    if (career == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (career.phase == 'debuted') {
      return _lockedByGroup(
          'Grup kuruldu.\nIdollerini Koçlar sekmesinden geliştirmeye devam edebilirsin.');
    }
    if (career.phase == 'elimination') {
      return const _EliminationView();
    }
    return const _RecruitView();
  }
}

// ── Seçmeler: 50 adaydan 20 zorunlu seçim ──
class _RecruitView extends ConsumerWidget {
  const _RecruitView();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campAsync = ref.watch(traineeCampProvider);
    final career = ref.watch(activeCareerProvider).value;
    final companyCount = ref.watch(myInventoryProvider).value?.length ?? 0;
    final db = ref.watch(databaseProvider);

    return campAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Hata: $e')),
      data: (trainees) {
        final remaining = kRecruitTarget - companyCount;
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: AppColors.success.withAlpha(28),
              child: Text(
                'Seçmeler: 50 aday arasından $kRecruitTarget kişi seç. '
                'Kalan: $remaining ($companyCount/$kRecruitTarget). '
                '$kRecruitTarget olunca eleme aşaması başlar.',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.onBgStrong),
              ),
            ),
            Expanded(
              child: trainees.isEmpty
                  ? Center(
                      child: Text('Kampta aday kalmadı.',
                          style: TextStyle(color: AppColors.onBgSoft)))
                  : ListView.builder(
                      itemCount: trainees.length,
                      itemBuilder: (context, i) {
                        final c = trainees[i];
                        final full = companyCount >= kRecruitTarget;
                        final grade = auditionGrade(c.auditionScore);
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: CharacterAvatar(
                              imagePath: c.imagePath,
                              initial: c.name,
                              size: 48,
                              tint: grade.color.withAlpha(45),
                            ),
                            title: Row(
                              children: [
                                Flexible(
                                  child: Text(c.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)),
                                ),
                                const SizedBox(width: 6),
                                _gradeChip(grade),
                                const SizedBox(width: 4),
                                _fameBadge(c.startingFame),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('İddia: ${c.claimedRole}',
                                    style: const TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.w600)),
                                if (c.bioSnippet != null)
                                  Text('"${c.bioSnippet}"',
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12)),
                                if (c.startingFame >= 70)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Text(
                                        '⭐ Ünlü aday! Gelir & takipçi getirir.',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.deepOrange,
                                            fontWeight: FontWeight.w600)),
                                  ),
                              ],
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      full ? Colors.grey : Colors.green),
                              onPressed: full || career == null
                                  ? null
                                  : () async {
                                      // %12 ihtimalle aday teklifi reddeder
                                      if (Random().nextDouble() < 0.12) {
                                        await (db.update(db.generatedCharacters)
                                              ..where((t) => t.id.equals(c.id)))
                                            .write(
                                                const GeneratedCharactersCompanion(
                                                    recruitStatus:
                                                        drift.Value('left')));
                                        ref.invalidate(traineeCampProvider);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                '${c.name}: "${_refusalReason()}" — teklifi reddetti.'),
                                          ));
                                        }
                                        return;
                                      }
                                      await db.into(db.playerIdols).insert(
                                            PlayerIdolsCompanion.insert(
                                              careerId: career.id,
                                              characterId: c.id,
                                              recruitedMonth:
                                                  career.currentMonth,
                                            ),
                                          );
                                      // 20'ye ulaştıysa eleme aşamasına geç
                                      if (companyCount + 1 >= kRecruitTarget) {
                                        await (db.update(db.playerCareers)
                                              ..where((t) =>
                                                  t.id.equals(career.id)))
                                            .write(const PlayerCareersCompanion(
                                                phase: drift.Value(
                                                    'elimination')));
                                        ref.invalidate(activeCareerProvider);
                                      }
                                      ref.invalidate(traineeCampProvider);
                                      ref.invalidate(myInventoryProvider);
                                    },
                              child: const Text('Şirkete Al',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ── Eleme: her ay max 2 kişi ele (gelişim analiziyle), 6 kişide grup ──
class _EliminationView extends ConsumerWidget {
  const _EliminationView();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invAsync = ref.watch(myInventoryProvider);
    final career = ref.watch(activeCareerProvider).value;
    final elimThisMonth = ref.watch(eliminatedThisMonthProvider);
    final db = ref.watch(databaseProvider);

    return invAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Hata: $e')),
      data: (idols) {
        final count = idols.length;
        // 10'a inildi → "Grup" sekmesinden 6'sı seçilecek
        if (count <= kElimTarget) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.celebration, size: 56, color: Colors.pink),
                  const SizedBox(height: 12),
                  Text(
                      'Eleme tamam! $count kişi kaldı.\n"Grup" sekmesinden debüt edecek $kGroupSize kişiyi seç — kalan $count\'dan ${count - kGroupSize}\'i yedek olacak.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, color: AppColors.onBgStrong)),
                ],
              ),
            ),
          );
        }

        // Gelişim = eğitim bonuslarının toplamı (en az gelişen elenir)
        int growthOf(Map<String, dynamic> m) {
          final idol = m['idol'] as PlayerIdol;
          return idol.vocalBonus + idol.danceBonus + idol.rapBonus;
        }

        final sorted = [...idols]
          ..sort((a, b) => growthOf(a).compareTo(growthOf(b)));
        final canElim = elimThisMonth < kElimPerMonth;

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: AppColors.warning.withAlpha(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ELEME — kadroyu $kElimTarget kişiye indir (sonra 6\'sını seçeceksin). '
                    'Kalan: $count → $kElimTarget. Bu ay elenen: $elimThisMonth/$kElimPerMonth. '
                    '${canElim ? "En az gelişen üstte. Ay ilerledikçe eğitimle ayrışırlar." : "Bu ayki eleme hakkın doldu — sonraki aya geç."}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.onBgStrong),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.mic, size: 18),
                      label: const Text('Prova Değerlendirmesi Yap'),
                      onPressed: () => runInteractivePractice(context, ref),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sorted.length,
                itemBuilder: (context, i) {
                  final m = sorted[i];
                  final idol = m['idol'] as PlayerIdol;
                  final c = m['character'] as GeneratedCharacter;
                  final growth = growthOf(m);
                  final eff = (c.vocalSkill + idol.vocalBonus) +
                      (c.danceSkill + idol.danceBonus) +
                      (c.rapSkill + idol.rapBonus);
                  final isLeast = i < kElimPerMonth; // en zayıf 2
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    color: isLeast ? AppColors.danger.withAlpha(28) : null,
                    child: ListTile(
                      leading: CharacterAvatar(
                        imagePath: c.imagePath,
                        initial: c.name,
                        size: 48,
                        tint: isLeast
                            ? AppColors.danger.withAlpha(45)
                            : AppColors.success.withAlpha(40),
                      ),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(c.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 6),
                          _fameBadge(c.startingFame),
                        ],
                      ),
                      subtitle: Text(
                          'Gelişim: +$growth  •  Toplam yetenek: $eff  •  Ruh: ${idol.mood}'),
                      trailing: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(
                                color: canElim
                                    ? Colors.red
                                    : AppColors.surfaceHigh)),
                        onPressed: !canElim || career == null
                            ? null
                            : () async {
                                await GroupManager(db).eliminateIdol(idol.id);
                                ref
                                    .read(eliminatedThisMonthProvider.notifier)
                                    .state = elimThisMonth + 1;
                                ref.invalidate(myInventoryProvider);
                              },
                        child: const Text('Ele'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============ SEKME 2: ŞİRKETİM (efektif yetenekler, sis perdesi) ============
class _CompanyTab extends ConsumerWidget {
  const _CompanyTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupSnap = ref.watch(hasActiveGroupProvider);
    if (!groupSnap.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    if (groupSnap.value == true) {
      return _lockedByGroup(
          'Grup debüt yaptıktan sonra şirket yönetim paneli kapanır.\nIdollerini Koçlar sekmesinden geliştirmeye devam edebilirsin.');
    }
    final invAsync = ref.watch(myInventoryProvider);
    return invAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Hata: $e')),
      data: (idols) {
        if (idols.isEmpty) {
          return Center(
              child: Text('Henüz şirkette kimse yok.',
                  style: TextStyle(color: AppColors.onBgSoft)));
        }
        return ListView.builder(
          itemCount: idols.length,
          itemBuilder: (context, i) {
            final idol = idols[i]['idol'] as PlayerIdol;
            final c = idols[i]['character'] as GeneratedCharacter;

            // Efektif güncel = temel + eğitim bonusu
            final v =
                c.isVocalRevealed ? '${c.vocalSkill + idol.vocalBonus}' : '???';
            final d =
                c.isDanceRevealed ? '${c.danceSkill + idol.danceBonus}' : '???';
            final r = c.isRapRevealed ? '${c.rapSkill + idol.rapBonus}' : '???';

            final allRevealed =
                c.isVocalRevealed && c.isDanceRevealed && c.isRapRevealed;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CharacterAvatar(
                    imagePath: c.imagePath, initial: c.name, size: 48),
                title: Text(c.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'Vokal: $v   Dans: $d   Rap: $r\nRuh: ${idol.mood}  Yorgunluk: ${idol.fatigue}'),
                isThreeLine: true,
                trailing: Text(
                  allRevealed ? c.rarity.toUpperCase() : '???',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.purple),
                ),
                onTap: () => _showIdolDetailSheet(context, ref, idol.id, c),
              ),
            );
          },
        );
      },
    );
  }
}

// Bir idolün kimya ilişkilerini alttan açılan panelde gösterir.
// Üye detayında birebir ilgi/moral bölümü: mood/loyalty/fatigue barları + aksiyonlar
class _MemberCareSection extends ConsumerStatefulWidget {
  final int idolId;
  const _MemberCareSection({required this.idolId});
  @override
  ConsumerState<_MemberCareSection> createState() => _MemberCareSectionState();
}

class _MemberCareSectionState extends ConsumerState<_MemberCareSection> {
  int _refresh = 0;
  bool _busy = false;

  Future<void> _care(String type) async {
    if (_busy) return;
    setState(() => _busy = true);
    final db = ref.read(databaseProvider);
    final career = ref.read(activeCareerProvider).value;
    if (career == null) {
      setState(() => _busy = false);
      return;
    }
    final res =
        await TrainingManager(db).careForIdol(career.id, widget.idolId, type);
    ref.invalidate(walletProvider);
    ref.invalidate(groupDashboardProvider);
    ref.invalidate(memberRelationsProvider);
    ref.invalidate(transactionsProvider);
    if (mounted) {
      setState(() {
        _busy = false;
        _refresh++;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res.message),
        backgroundColor: res.ok ? null : Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.read(databaseProvider);
    final mult = ref.watch(costMultProvider);
    int cost(int base) => (base * mult).round();
    return FutureBuilder<PlayerIdol?>(
      key: ValueKey(_refresh),
      future: (db.select(db.playerIdols)
            ..where((t) => t.id.equals(widget.idolId)))
          .getSingleOrNull(),
      builder: (context, snap) {
        final idol = snap.data;
        return GamePanel(
          title: 'Birebir İlgi',
          headerIcon: Icons.favorite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (idol != null) ...[
                _careBar('Moral', idol.mood,
                    idol.mood >= 50 ? AppColors.success : AppColors.danger),
                _careBar('Sadakat', idol.loyalty, AppColors.primary),
                _careBar('Yorgunluk', idol.fatigue,
                    idol.fatigue >= 70 ? AppColors.danger : AppColors.warning),
                const SizedBox(height: 8),
                if (idol.mood < 20)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withAlpha(22),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                        '⚠️ Morali çok düşük! İlgilenmezsen ayrılmak isteyebilir.',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.danger)),
                  ),
              ],
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _careBtn('💬 Sohbet', '${cost(1500)}₺', 'chat'),
                  _careBtn('🎁 Hediye', '${cost(4000)}₺', 'gift'),
                  _careBtn('🛌 Mola', '${cost(3000)}₺', 'rest'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _careBar(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
              width: 70,
              child: Text(label, style: const TextStyle(fontSize: 12))),
          Expanded(
            child: GameBar(
                value: (value / 100).clamp(0.0, 1.0), color: color, height: 7),
          ),
          const SizedBox(width: 6),
          Text('$value', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _careBtn(String label, String price, String type) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary.withAlpha(28),
          foregroundColor: AppColors.ink,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      onPressed: _busy ? null : () => _care(type),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

void _showIdolDetailSheet(
    BuildContext context, WidgetRef ref, int idolId, GeneratedCharacter c) {
  final db = ref.read(databaseProvider);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.92,
        builder: (_, scrollCtrl) {
          return FutureBuilder<List<({String name, int score})>>(
            future: loadChemistryFor(db, idolId),
            builder: (context, snap) {
              final list = snap.data ?? const <({String name, int score})>[];
              return ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                          color: AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  Row(
                    children: [
                      CharacterAvatar(
                          imagePath: c.imagePath, initial: c.name, size: 64),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            if (c.specialTrait != null)
                              Text('Özellik: ${c.specialTrait}',
                                  style: const TextStyle(
                                      color: AppColors.primary, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Birebir ilgi / moral ──
                  _MemberCareSection(idolId: idolId),
                  const SizedBox(height: 16),

                  // ── Big5 kişilik profili ──
                  const Text('Kişilik (Big5)',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _Big5Bars(c),
                  const SizedBox(height: 16),

                  // ── Kimya ──
                  const Text('Kimya İlişkileri',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  if (!snap.hasData)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (list.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                          'Henüz kimya oluşmadı. Birkaç ay birlikte geçince ilişkiler belirginleşir.'),
                    )
                  else
                    ...list.map((e) {
                      final st = relationshipStyle(e.score);
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading:
                            CircleAvatar(radius: 6, backgroundColor: st.color),
                        title: Text(e.name),
                        trailing: Text(
                          '${e.score >= 0 ? '+' : ''}${e.score}  ${st.label}',
                          style: TextStyle(
                              color: st.color, fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                ],
              );
            },
          );
        },
      );
    },
  );
}

// Tatil/Mola: tüm aktif idollerin yorgunluğunu düşürür (parayla).
Future<void> _giveVacation(BuildContext context, WidgetRef ref) async {
  final db = ref.read(databaseProvider);
  final career = ref.read(activeCareerProvider).value;
  if (career == null) return;
  // Aylık 1 tatil hakkı
  if (ref.read(vacationUsedThisMonthProvider)) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Bu ay zaten tatil verdin. Gelecek ay tekrar.')));
    return;
  }
  final res = await TrainingManager(db).giveVacation(career.id);
  if (res.ok) {
    ref.read(vacationUsedThisMonthProvider.notifier).state = true;
  }
  ref.invalidate(myInventoryProvider);
  ref.invalidate(walletProvider);
  ref.invalidate(groupDashboardProvider);
  ref.invalidate(memberRelationsProvider);
  ref.invalidate(transactionsProvider);
  if (context.mounted) {
    showActionResult(
        context,
        res.ok
            ? 'Ekip tatile çıktı! Yorgunluk düştü, moral ve sadakat arttı.'
            : res.reason,
        success: res.ok,
        title: res.ok ? '🏖️ Tatil' : '⚠️ Olmadı');
  }
}

// ============ SEKME 3: KOÇLAR (tut/bırak) ============
class _CoachesTab extends ConsumerWidget {
  const _CoachesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coachAsync = ref.watch(coachPoolProvider);
    final db = ref.watch(databaseProvider);

    return coachAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Hata: $e')),
      data: (coaches) {
        if (coaches.isEmpty) {
          return Center(
              child: Text('Koç havuzu boş.',
                  style: TextStyle(color: AppColors.onBgSoft)));
        }
        final mult = ref.watch(costMultProvider);
        final hired = coaches.where((c) => c.isHired);
        final totalSalary =
            hired.fold<int>(0, (s, c) => s + (c.monthlySalary * mult).round());

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: AppColors.warning.withAlpha(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tutulan koç: ${hired.length}  •  Aylık maaş gideri: $totalSalary ₺',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.ink),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    mult > 1.05
                        ? 'Prestij vergisi ×${mult.toStringAsFixed(2)}: büyüdükçe tüm masraflar arttı.'
                        : 'Yorgunluk eğitim verimini düşürür. Tatil verme artık Grup sekmesinde.',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: coaches.length,
                itemBuilder: (context, i) {
                  final coach = coaches[i];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: coach.isHired
                        ? AppColors.success.withAlpha(28)
                        : AppColors.surface,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber.shade200,
                        child: const Icon(Icons.school, color: Colors.brown),
                      ),
                      title: Text(coach.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink)),
                      subtitle: Text(
                          '${discTr(coach.discipline)} koçu  •  Eğitim gücü: ${coach.quality}  •  Maaş: ${(coach.monthlySalary * mult).round()}₺/ay',
                          style: TextStyle(color: AppColors.textSecondary)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                coach.isHired ? Colors.red : Colors.green),
                        onPressed: () async {
                          await (db.update(db.coaches)
                                ..where((t) => t.id.equals(coach.id)))
                              .write(CoachesCompanion(
                                  isHired: drift.Value(!coach.isHired)));
                          ref.invalidate(coachPoolProvider);
                        },
                        child: Text(coach.isHired ? 'Bırak' : 'Tut',
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============ SEKME 4: GRUP (yoksa kurma, varsa pano) ============
class _GroupTab extends ConsumerWidget {
  const _GroupTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dash = ref.watch(groupDashboardProvider);
    return dash.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Hata: $e')),
      data: (d) {
        if (d == null) return const _FormationView();
        return _GroupDashboardView(dash: d);
      },
    );
  }
}

// ---- Grup Kurma (eleme sonrası kalan kadroyla) ----
class _FormationView extends ConsumerStatefulWidget {
  const _FormationView();
  @override
  ConsumerState<_FormationView> createState() => _FormationViewState();
}

class _FormationViewState extends ConsumerState<_FormationView> {
  final TextEditingController _nameCtrl = TextEditingController();
  final List<int> _selected = []; // gruba seçilen idol id'leri (sıralı, max 6)

  static const List<String> _auditionQuotes = [
    'Sahne benim evim, beni seçin!',
    'Bu grup için doğdum sanki.',
    'Bir şans verin, fark yaratacağım.',
    'Çok çalıştım, hayalim bu.',
    'Sizi asla pişman etmem, söz!',
    'Müzik kalbimde, hadi başlayalım.',
    'Işıklar yansın, hazırım.',
    'En iyisi olmak için buradayım.',
  ];
  String _quoteFor(int id) => _auditionQuotes[id % _auditionQuotes.length];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Widget _skillBar(String label, int value, Color color) {
    return Row(
      children: [
        SizedBox(
            width: 16,
            child: Text(label,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w800, color: color))),
        const SizedBox(width: 4),
        Expanded(
          child: GameBar(
              value: (value / 100).clamp(0.0, 1.0), color: color, height: 5),
        ),
        const SizedBox(width: 4),
        SizedBox(
            width: 22,
            child: Text('$value',
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700))),
      ],
    );
  }

  // Tek bir adayı "gruba al" onay popup'ı (mini profil + replik)
  Future<void> _confirmPick(
      BuildContext context, PlayerIdol idol, GeneratedCharacter c) async {
    final v = c.vocalSkill + idol.vocalBonus;
    final d = c.danceSkill + idol.danceBonus;
    final r = c.rapSkill + idol.rapBonus;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: Row(
          children: [
            CharacterAvatar(
                imagePath: c.imagePath,
                initial: c.name,
                size: 44,
                tint: AppTheme.rarityColor(c.rarity).withAlpha(45)),
            const SizedBox(width: 10),
            Expanded(child: Text(c.name, style: const TextStyle(fontSize: 18))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('"${_quoteFor(idol.id)}"',
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 13)),
            ),
            const SizedBox(height: 12),
            _skillBar('V', v, AppColors.primary),
            const SizedBox(height: 5),
            _skillBar('D', d, AppColors.secondary),
            const SizedBox(height: 5),
            _skillBar('R', r, AppColors.accentBlue),
            const SizedBox(height: 8),
            Text('Ruh: ${idol.mood}  •  Nadirlik: ${c.rarity}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx, false),
              child: const Text('Vazgeç')),
          ElevatedButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Gruba Al!'),
            onPressed: () => Navigator.pop(dctx, true),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _selected.add(idol.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final invAsync = ref.watch(myInventoryProvider);
    final career = ref.watch(activeCareerProvider).value;
    final db = ref.watch(databaseProvider);

    return invAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Hata: $e')),
      data: (idols) {
        // Önce eleme bitmeli (10 kişiye inilmeli)
        if (idols.length > kElimTarget) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Grubu kurmak için önce "Kamp" sekmesindeki elemeyi tamamla.\n'
                'Şu an ${idols.length} kişi var, $kElimTarget kişiye inmen gerekiyor '
                '(her ay en fazla $kElimPerMonth eleme). Sonra $kGroupSize\'sını seçeceksin.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.onBgSoft),
              ),
            ),
          );
        }

        final reserveCount = idols.length - kGroupSize;
        final ready =
            _selected.length == kGroupSize && _nameCtrl.text.trim().isNotEmpty;
        // id → karakter (sahne dizilişi avatarları için)
        final charById = <int, GeneratedCharacter>{
          for (final m in idols)
            (m['idol'] as PlayerIdol).id: m['character'] as GeneratedCharacter
        };

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              decoration: BoxDecoration(gradient: AppColors.headerGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎤 KADRO SEÇİMİ — ${_selected.length}/$kGroupSize seçildi',
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  Text(
                    '${idols.length} aday içinden debüt $kGroupSize\'sını seç • kalan ${reserveCount < 0 ? 0 : reserveCount} kişi yedek',
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  // ── SAHNE DİZİLİŞİ (6 slot) ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(kGroupSize, (i) {
                      final filled = i < _selected.length;
                      final id = filled ? _selected[i] : null;
                      final c = id != null ? charById[id] : null;
                      return GestureDetector(
                        onTap: filled
                            ? () => setState(() => _selected.removeAt(i))
                            : null,
                        child: filled && c != null
                            ? CharacterAvatar(
                                imagePath: c.imagePath,
                                initial: c.name,
                                size: 44,
                                ringWidth: 2.5,
                                ringGradient: AppColors.goldGradient,
                                tint: Colors.white)
                            : Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withAlpha(30),
                                  border: Border.all(
                                      color: Colors.white54, width: 2),
                                ),
                                child: const Icon(Icons.add,
                                    color: Colors.white60, size: 20),
                              ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: TextField(
                controller: _nameCtrl,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Grup adı',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: idols.length,
                itemBuilder: (context, i) {
                  final idol = idols[i]['idol'] as PlayerIdol;
                  final c = idols[i]['character'] as GeneratedCharacter;
                  final v = c.vocalSkill + idol.vocalBonus;
                  final d = c.danceSkill + idol.danceBonus;
                  final r = c.rapSkill + idol.rapBonus;
                  final sel = _selected.contains(idol.id);
                  final atLimit = _selected.length >= kGroupSize && !sel;
                  return PressableScale(
                    onTap: atLimit
                        ? null
                        : (sel
                            ? () => setState(() => _selected.remove(idol.id))
                            : () => _confirmPick(context, idol, c)),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: sel
                                ? AppColors.gold
                                : (atLimit
                                    ? AppColors.border
                                    : AppColors.border),
                            width: sel ? 2 : 1.5),
                        boxShadow: sel
                            ? [
                                BoxShadow(
                                    color: AppColors.gold.withAlpha(70),
                                    blurRadius: 10)
                              ]
                            : null,
                      ),
                      child: Opacity(
                        opacity: atLimit ? 0.45 : 1,
                        child: Row(
                          children: [
                            CharacterAvatar(
                                imagePath: c.imagePath,
                                initial: c.name,
                                size: 52,
                                ringGradient:
                                    sel ? AppColors.goldGradient : null,
                                tint: AppTheme.rarityColor(c.rarity)
                                    .withAlpha(40)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(c.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15)),
                                      ),
                                      const SizedBox(width: 6),
                                      _fameBadge(c.startingFame),
                                    ],
                                  ),
                                  Text('"${_quoteFor(idol.id)}"',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic,
                                          color: AppColors.textSecondary)),
                                  const SizedBox(height: 5),
                                  _skillBar('V', v, AppColors.primary),
                                  const SizedBox(height: 3),
                                  _skillBar('D', d, AppColors.secondary),
                                  const SizedBox(height: 3),
                                  _skillBar('R', r, AppColors.accentBlue),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              sel
                                  ? Icons.check_circle
                                  : (atLimit
                                      ? Icons.lock_outline
                                      : Icons.add_circle_outline),
                              color: sel
                                  ? AppColors.gold
                                  : AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.groups),
                  label: Text(ready
                      ? 'Grubu Kur & Debüt Yap'
                      : 'Önce $kGroupSize kişi + isim seç (${_selected.length}/$kGroupSize)'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: (ready && career != null)
                      ? () async {
                          final selectedIds = _selected.toList();
                          final groupId =
                              await GroupManager(db).createGroupAuto(
                            careerId: career.id,
                            name: _nameCtrl.text.trim(),
                            month: career.currentMonth,
                            idolIds: selectedIds,
                          );
                          // Seçilmeyenler YEDEK olur (kadro yönetiminden çağrılır)
                          for (final m in idols) {
                            final id = (m['idol'] as PlayerIdol).id;
                            if (!_selected.contains(id)) {
                              await (db.update(db.playerIdols)
                                    ..where((t) => t.id.equals(id)))
                                  .write(const PlayerIdolsCompanion(
                                      status: drift.Value('reserve')));
                            }
                          }
                          final buzz = await SocialManager(db)
                              .addDebutBuzz(career.id, groupId);
                          ref.invalidate(groupDashboardProvider);
                          ref.invalidate(hasActiveGroupProvider);
                          ref.invalidate(activeCareerProvider);
                          ref.invalidate(benchIdolsProvider);
                          ref.invalidate(socialPostsProvider);
                          if (buzz != null && context.mounted) {
                            showBuzzDialog(context, buzz);
                          }
                        }
                      : null,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---- Grup Panosu ----
class _GroupDashboardView extends ConsumerWidget {
  final GroupDashboard dash;
  const _GroupDashboardView({required this.dash});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider).value ?? 0;
    final chemStyle = relationshipStyle(dash.chem);
    final g = dash.group;

    final sortedMembers = [...dash.members]..sort((a, b) =>
        (b.char.startingFame + b.idol.popularityBonus)
            .compareTo(a.char.startingFame + a.idol.popularityBonus));
    final centerId = sortedMembers.isEmpty ? -1 : sortedMembers.first.idol.id;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // ── Başlık ──
        Text(g.groupName,
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(color: AppColors.onBgStrong)),
        Text('${g.formationMonth}. ayda kuruldu • ${dash.members.length} üye',
            style: TextStyle(color: AppColors.onBgSoft, fontSize: 13)),
        const SizedBox(height: 14),

        // ── SAHNE GÖRÜNÜMÜ ──
        _stageView(context, ref, sortedMembers, centerId),
        const SizedBox(height: 16),

        // ── ÜYELER (en üstte) ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Üyeler',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: AppColors.onBgStrong)),
            Text('${dash.members.length} kişi',
                style: TextStyle(color: AppColors.onBgSoft, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 12),
        ...sortedMembers.map((m) {
          final overall = ((m.char.vocalSkill + m.idol.vocalBonus) +
                  (m.char.danceSkill + m.idol.danceBonus) +
                  (m.char.rapSkill + m.idol.rapBonus)) ~/
              3;
          final fame = m.char.startingFame + m.idol.popularityBonus;
          return _MemberTile(
            name: m.char.name,
            position: positionTr(m.position),
            overall: overall,
            morale: m.idol.mood,
            fame: fame,
            vocal: m.char.vocalSkill + m.idol.vocalBonus,
            dance: m.char.danceSkill + m.idol.danceBonus,
            rap: m.char.rapSkill + m.idol.rapBonus,
            imagePath: m.char.imagePath,
            isCenter: m.idol.id == centerId,
            onTap: () => _showIdolDetailSheet(context, ref, m.idol.id, m.char),
          );
        }),
        const SizedBox(height: 8),
        // Tatil/mola (eskiden Koçlar sekmesindeydi)
        _vacationButton(context, ref),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.diversity_3, size: 18),
                label: const Text('İlişkiler', style: TextStyle(fontSize: 13)),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const MembersRelationshipScreen(),
                )),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.manage_accounts, size: 18),
                label: const Text('Kadro', style: TextStyle(fontSize: 13)),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const SquadManagementScreen(),
                )),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Kaynak chip'leri (Erişim artık Güç/Kimya satırında) ──
        Row(
          children: [
            Expanded(
              child: _resChip(
                  Icons.savings_outlined, AppColors.accentCyan, 'Kasa', '',
                  animatedValue: wallet, formatter: (n) => '$n₺'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _resChip(
                  Icons.people_alt,
                  AppColors.secondary,
                  'Takipçi',
                  g.lastFollowerDelta == 0
                      ? fmtCount(g.socialFollowers)
                      : '${fmtCount(g.socialFollowers)}  ${g.lastFollowerDelta > 0 ? "▲" : "▼"}${fmtCount(g.lastFollowerDelta.abs())}'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _resChip(
                  Icons.verified,
                  g.reputation >= 50 ? AppColors.success : AppColors.warning,
                  'İtibar',
                  '${g.reputation}/100'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _resChip(Icons.favorite, AppColors.secondary,
                  g.fandomName ?? 'Fandom', 'Sadakat ${g.fandomLoyalty}/100'),
            ),
          ],
        ),
        if (g.scandalHeat > 0) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _resChip(
                    Icons.local_fire_department,
                    g.scandalHeat > 50 ? AppColors.danger : AppColors.warning,
                    'Skandal Isısı',
                    '${g.scandalHeat}/100'),
              ),
              const SizedBox(width: 10),
              const Spacer(),
            ],
          ),
        ],
        const SizedBox(height: 16),

        // ── Maaş dökümü ──
        const _SalaryPanel(),

        // ── Popülarite sıralaması ──
        _PopularityChart(
            groupName: g.groupName,
            popularity: g.totalPopularity,
            rivalName: dash.rivalName,
            rivalPop: dash.rivalPop),
        const SizedBox(height: 16),

        // Güç • Erişim • Kimya — grup istatistikleri yan yana (ayrı çip yok)
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: _miniStat(Icons.fitness_center, AppColors.secondary,
                      'Güç', '${dash.power}'),
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                Expanded(
                  child: _miniStat(Icons.public, AppColors.primary, 'Erişim',
                      fmtCount(g.totalPopularity)),
                ),
                Container(width: 1, height: 30, color: AppColors.border),
                Expanded(
                  child: _miniStat(Icons.favorite, chemStyle.color, 'Kimya',
                      '${dash.chem >= 0 ? "+" : ""}${dash.chem}'),
                ),
              ],
            ),
          ),
        ),

        // Konser / Tur
        const SizedBox(height: 12),
        const _ConcertCard(),
      ],
    );
  }

  // Tatil/mola butonu (aylık 1 hak; eskiden Koçlar sekmesindeydi)
  Widget _vacationButton(BuildContext context, WidgetRef ref) {
    final vacUsed = ref.watch(vacationUsedThisMonthProvider);
    final mult = ref.watch(costMultProvider);
    final vacCost = (TrainingManager.vacationCost * mult).round();
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.beach_access, size: 18),
        label: Text(vacUsed
            ? 'Tatil hakkı bu ay kullanıldı'
            : 'Tatil Ver ($vacCost₺) — yorgunluk↓ moral↑'),
        style: OutlinedButton.styleFrom(
            foregroundColor: vacUsed ? Colors.grey : Colors.teal,
            side: BorderSide(color: vacUsed ? Colors.grey : Colors.teal)),
        onPressed: vacUsed ? null : () => _giveVacation(context, ref),
      ),
    );
  }

  // Sahne görünümü: üyeleri ışıklı bir sahnede dizer (center ortada, büyük + taç).
// Sahne görünümü: Koyu temada büyüleyici bir sahne. Center ortada büyük ve altın taçlı.
  Widget _stageView(
      BuildContext context, WidgetRef ref, List members, int centerId) {
    if (members.isEmpty) return const SizedBox.shrink();

    final left = [], right = [];
    dynamic center;
    for (var i = 0; i < members.length; i++) {
      if (i == 0) {
        center = members[i];
      } else if (i.isOdd) {
        left.add(members[i]);
      } else {
        right.add(members[i]);
      }
    }
    final ordered = [...left.reversed, center, ...right];

    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: AppColors.dark
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2A0E22), Color(0xFF160314)],
              )
            : AppColors
                .headerGradient, // Açık temada orjinal arkadaşının header gradyanı
        border: Border.all(color: AppColors.gold.withAlpha(60), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withAlpha(80),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                    colors: [AppColors.gold.withAlpha(50), Colors.transparent]),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: ordered.map((m) {
              final isCenter = m.idol.id == centerId;
              final c = m.char;
              return GestureDetector(
                onTap: () => _showIdolDetailSheet(context, ref, m.idol.id, c),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (isCenter)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Icon(Icons.workspace_premium,
                              color: AppColors.gold, size: 30),
                        ),
                      CharacterAvatar(
                        imagePath: c.imagePath,
                        initial: c.name,
                        size: isCenter ? 76 : 56,
                        ringWidth: isCenter ? 4 : 2.5,
                        ringGradient: isCenter
                            ? AppColors.goldGradient
                            : AppColors.buttonGradient,
                        tint: AppColors.surfaceHigh,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        c.name,
                        style: TextStyle(
                            fontSize: isCenter ? 14 : 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _spotBeam(Color color) {
    return Container(
      width: 80,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withAlpha(70), Colors.transparent],
        ),
      ),
    );
  }

  Widget _resChip(IconData icon, Color color, String label, String value,
      {int? animatedValue, String Function(int)? formatter}) {
    final valueStyle = TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
              color: color.withAlpha(26),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
                animatedValue != null
                    ? AnimatedCount(animatedValue,
                        formatter: formatter, style: valueStyle)
                    : Text(value,
                        overflow: TextOverflow.ellipsis, style: valueStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Güç/Erişim/Kimya satırı için kompakt istatistik (yan yana, ayrı çip değil)
  Widget _miniStat(IconData icon, Color color, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 3),
        Text(label,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        const SizedBox(height: 1),
        Text(value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w800, color: color)),
      ],
    );
  }
}

// Popülarite sıralama grafiği (career_screen tasarımından)
class _PopularityChart extends StatelessWidget {
  final String groupName;
  final int popularity;
  final String rivalName;
  final int rivalPop;
  const _PopularityChart({
    required this.groupName,
    required this.popularity,
    required this.rivalName,
    required this.rivalPop,
  });

  @override
  Widget build(BuildContext context) {
    // Oyuncu + ana rakip + birkaç deko rakip (sıralama derinliği için)
    final entries = <(String, double, bool)>[
      (groupName, popularity.toDouble(), true),
      (rivalName, rivalPop.toDouble(), false),
      ('AURORA', rivalPop * 0.86, false),
      ('STELLA5', rivalPop * 0.62, false),
      ('NOVA', rivalPop * 0.4, false),
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    final maxPop = entries.fold<double>(1, (p, e) => e.$2 > p ? e.$2 : p);
    final rank = entries.indexWhere((e) => e.$3) + 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Erişim Sıralaması',
                  style: Theme.of(context).textTheme.titleMedium),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(38),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('#$rank',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(entries.length, (i) {
            final (name, pop, isPlayer) = entries[i];
            final ratio = (pop / maxPop).clamp(0.0, 1.0);
            final color = isPlayer ? AppColors.primary : AppColors.secondary;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                      width: 18,
                      child: Text('${i + 1}',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700))),
                  SizedBox(
                    width: 78,
                    child: Text(name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isPlayer ? FontWeight.w800 : FontWeight.w500,
                          color: isPlayer
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        )),
                  ),
                  Expanded(
                    child: GameBar(value: ratio, color: color, height: 7),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 42,
                    child: Text(fmtCount(pop.round()),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textSecondary)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Maaş dökümü paneli: kime ne kadar + neden (katsayı açıklaması)
class _SalaryPanel extends ConsumerWidget {
  const _SalaryPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(salaryBreakdownProvider).value;
    if (data == null || data.rows.isEmpty) return const SizedBox.shrink();
    return GamePanel(
      title: 'Aylık İdol Maaşları',
      headerIcon: Icons.payments,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...data.rows.map((r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: AppTheme.rarityColor(r.rarity),
                          shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(r.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13)),
                    ),
                    if (r.bonus > 0)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text('(+${fmtCount(r.bonus)} zam)',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.danger)),
                      ),
                    Text('${fmtCount(r.total)}₺',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w800)),
                  ],
                ),
              )),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Katsayı ×${data.growthMult.toStringAsFixed(2)}',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text('Toplam: ${fmtCount(data.total)}₺/ay',
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 6),
          Builder(builder: (ctx) {
            final mult = ref.watch(costMultProvider);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.danger.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up,
                      size: 16, color: AppColors.danger),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                        'Prestij Vergisi ×${mult.toStringAsFixed(2)} — şarkı, konser, tur, PR, koç, tatil dahil TÜM masraflar bu oranda artar.',
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
          Text(
              'Maaşlar nadirliğe göre belirlenir; büyüdükçe katsayı büyür. Rakip transfer baskısında üyeyi tutmak için verilen zam da eklenir.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// Üye kartı (career_screen tasarımından: OVR + moral)
// Üye kartı (Premium kart stili)
class _MemberTile extends StatelessWidget {
  final String name;
  final String position;
  final int overall;
  final int morale;
  final int fame;
  final int vocal;
  final int dance;
  final int rap;
  final String? imagePath;
  final bool isCenter;
  final VoidCallback onTap;

  const _MemberTile({
    required this.name,
    required this.position,
    required this.overall,
    required this.morale,
    required this.fame,
    required this.vocal,
    required this.dance,
    required this.rap,
    required this.imagePath,
    required this.isCenter,
    required this.onTap,
  });

  Widget _skill(String label, int v, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('$label $v',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w900, color: color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
            color: AppColors
                .surface, // Tema rengine duyarlı (Koyuda koyu, açıkta beyaz)
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isCenter ? AppColors.gold : AppColors.primary, width: 2),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ]),
        child: Row(
          children: [
            CharacterAvatar(
              imagePath: imagePath,
              initial: name,
              size: 58,
              ringGradient:
                  isCenter ? AppColors.goldGradient : AppColors.buttonGradient,
              tint: AppColors.surfaceHigh,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isCenter)
                        const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(Icons.workspace_premium,
                              color: AppColors.gold, size: 18),
                        ),
                      Flexible(
                        child: Text(name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.ink)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.orange.withAlpha(40),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text('$fame',
                                style: const TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13))
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text('$position${isCenter ? " • Center" : ""}',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _skill('V', vocal, AppColors.primary),
                      _skill('D', dance, AppColors.secondary),
                      _skill('R', rap, AppColors.accentBlue),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$overall OVR',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.favorite,
                        size: 14, color: AppColors.danger),
                    const SizedBox(width: 4),
                    Text('$morale',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.danger)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Konser / Tur kartı ──
class _ConcertCard extends ConsumerWidget {
  const _ConcertCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eligAsync = ref.watch(concertEligibilityProvider);
    return eligAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (elig) {
        if (elig == null) return const SizedBox.shrink();
        final unlocked = elig.unlocked;
        return Card(
          color: unlocked
              ? AppColors.secondary.withAlpha(28)
              : AppColors.surfaceHigh,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.stadium,
                        color: unlocked ? Colors.indigo : Colors.grey),
                    const SizedBox(width: 8),
                    const Text('Sahne Etkinlikleri',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                if (!unlocked) ...[
                  Text(elig.reason,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  _progressLine('Hit şarkı', elig.hitSongs,
                      ConcertManager.hitSongsRequired),
                  _progressLine('Takipçi', elig.followers,
                      ConcertManager.followerThreshold),
                ] else ...[
                  Text(
                      'Konser ve tur düzenleyerek büyük gelir ve erişim kazan.',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.mic_external_on, size: 18),
                          label: const Text('Konser'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white),
                          onPressed: () => _pickConcertSize(context, ref),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.directions_bus, size: 18),
                          label: const Text('Tur'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white),
                          onPressed: () => _pickTourPlan(context, ref),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _progressLine(String label, int value, int target) {
    final frac = (value / target).clamp(0.0, 1.0);
    final done = value >= target;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 11)),
          ),
          Expanded(
            child: GameBar(
                value: frac,
                color: done ? Colors.green : Colors.indigo,
                height: 6),
          ),
          const SizedBox(width: 6),
          Text('${fmtCount(value)}/${fmtCount(target)}',
              style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Future<void> _pickConcertSize(BuildContext context, WidgetRef ref) async {
    final grp = ref.read(groupDashboardProvider).value?.group;
    final followers = grp?.socialFollowers ?? 0;
    final rawMult = grp == null
        ? 1.0
        : GroupManager.costMultiplierFor(
            grp.socialFollowers, grp.totalPopularity);
    final mult = 1 + (rawMult - 1) * 0.6; // konser gideri yumuşatılmış çarpan
    final size = await showDialog<ConcertSize>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('🎤 Konser Boyutu Seç'),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ConcertManager.concertSizes.map((s) {
              final locked = followers < s.followerGate;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: locked ? AppColors.surfaceHigh : null,
                child: InkWell(
                  onTap: locked ? null : () => Navigator.pop(dctx, s),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${s.emoji}  ${s.label}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: locked
                                    ? AppColors.textSecondary
                                    : AppColors.ink)),
                        const SizedBox(height: 2),
                        Text(locked ? '🔒 ${s.blurb}' : s.blurb,
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 6),
                        Text(
                            'Gider ${fmtCount((s.cost * mult).round())}₺ • Gelir ×${s.incomeMult} • Erişim ×${s.popMult} • Yorgunluk +${s.fatigue}',
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx),
              child: const Text('Vazgeç')),
        ],
      ),
    );
    if (size == null) return;
    if (context.mounted) await _run(context, ref, isTour: false, size: size);
  }

  Future<void> _pickTourPlan(BuildContext context, WidgetRef ref) async {
    final grp = ref.read(groupDashboardProvider).value?.group;
    final followers = grp?.socialFollowers ?? 0;
    final rawMult = grp == null
        ? 1.0
        : GroupManager.costMultiplierFor(
            grp.socialFollowers, grp.totalPopularity);
    final mult = 1 + (rawMult - 1) * 0.6; // tur gideri yumuşatılmış çarpan
    final plan = await showDialog<TourPlan>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('🚌 Tur Planı Seç'),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ConcertManager.tourPlans.map((t) {
              final locked = followers < t.followerGate;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                color: locked ? AppColors.surfaceHigh : null,
                child: InkWell(
                  onTap: locked ? null : () => Navigator.pop(dctx, t),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${t.emoji}  ${t.label} • ${t.cities} şehir',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: locked
                                    ? AppColors.textSecondary
                                    : AppColors.ink)),
                        const SizedBox(height: 2),
                        Text(locked ? '🔒 ${t.blurb}' : t.blurb,
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 6),
                        Text(
                            'Gider ${fmtCount((t.cost * mult).round())}₺ • Yorgunluk +${t.fatigue}',
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx),
              child: const Text('Vazgeç')),
        ],
      ),
    );
    if (plan == null) return;
    if (context.mounted) await _run(context, ref, isTour: true, tourPlan: plan);
  }

  Future<void> _run(BuildContext context, WidgetRef ref,
      {required bool isTour, ConcertSize? size, TourPlan? tourPlan}) async {
    final db = ref.read(databaseProvider);
    final career = ref.read(activeCareerProvider).value;
    if (career == null) return;
    final mgr = ConcertManager(db);
    final result = isTour
        ? await mgr.holdTour(career.id, absMonthOf(career), plan: tourPlan)
        : await mgr.holdConcert(career.id, absMonthOf(career), size: size);

    ref.invalidate(walletProvider);
    ref.invalidate(groupDashboardProvider);
    ref.invalidate(concertEligibilityProvider);
    ref.invalidate(eventFeedProvider);
    ref.invalidate(myInventoryProvider);

    if (context.mounted) {
      showActionResult(context, result.message,
          success: result.success,
          title: result.success ? '🎤 Sahne Sonucu' : '⚠️ Olmadı');
    }
  }
}

// ============ SEKME 5: ŞARKILAR ============
class _SongsTab extends ConsumerStatefulWidget {
  const _SongsTab();
  @override
  ConsumerState<_SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends ConsumerState<_SongsTab> {
  bool _preparing = false;
  int _view = 0; // 0=diskografi, 1=grafik, 2=albümler

  @override
  Widget build(BuildContext context) {
    final dashAsync = ref.watch(groupDashboardProvider);
    final career = ref.watch(activeCareerProvider).value;
    final db = ref.watch(databaseProvider);

    return dashAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (dash) {
        if (dash == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Şarkı çıkarmak için önce bir grup kurman gerekiyor.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Column(
          children: [
            // ── Şarkı çıkarma butonu ─────────────────────────────────────
            Container(
              color: AppColors.primary.withAlpha(22),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Yeni Single',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(
                          'Güç: ${dash.power}  •  Kimya: ${dash.chem >= 0 ? "+" : ""}${dash.chem}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: _preparing
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.music_note),
                    label: const Text('Şarkı Hazırla'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white),
                    onPressed: (_preparing || career == null)
                        ? null
                        : () async {
                            setState(() => _preparing = true);
                            try {
                              // Cooldown + bütçe kontrolü (ayda 1 şarkı)
                              final mgr = SongManager(db);
                              final costMult = GroupManager.costMultiplierFor(
                                  dash.group.socialFollowers,
                                  dash.group.totalPopularity);
                              final baseCost = (SongManager.releaseCost(
                                          hasMusicVideo: false) *
                                      costMult)
                                  .round();
                              final gate = await mgr.canRelease(
                                  career.id, absMonthOf(career), baseCost);
                              if (!gate.ok) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(gate.reason)));
                                }
                                return;
                              }
                              final data = await mgr.generateSelectionOptions(
                                careerId: career.id,
                                groupPower: dash.power,
                                avgChem: dash.chem,
                              );
                              if (!context.mounted) return;
                              final result =
                                  await showModalBottomSheet<SongReleaseResult>(
                                context: context,
                                isScrollControlled: true,
                                useSafeArea: true,
                                builder: (_) => _SongSelectionSheet(
                                  data: data,
                                  groupId: dash.group.id,
                                  careerId: career.id,
                                  month: career.currentMonth,
                                  absMonth: absMonthOf(career),
                                  groupPower: dash.power,
                                  avgChemistry: dash.chem,
                                  walletBalance:
                                      ref.read(walletProvider).value ?? 0,
                                  costMult: costMult,
                                  db: db,
                                ),
                              );
                              if (result != null && context.mounted) {
                                ref.invalidate(songsProvider);
                                ref.invalidate(chartProvider);
                                ref.invalidate(groupDashboardProvider);
                                ref.invalidate(walletProvider);
                                ref.invalidate(socialPostsProvider);
                                final pos = result.song.currentChartPosition;
                                final isHit =
                                    !result.flopped && pos != null && pos <= 10;
                                final mega = pos == 1;
                                final band = SongManager.qualityBand(
                                    result.finalQuality);
                                final title = isHit
                                    ? (mega
                                        ? '🚀 MEGA HIT! #1'
                                        : '🔥 HIT! #$pos')
                                    : (result.flopped
                                        ? '📉 Flop'
                                        : '🎵 Şarkı Yayında');
                                final body = isHit
                                    ? (mega
                                        ? '"${result.song.title}" listeye 1 numaradan girdi! Efsane bir çıkış!'
                                        : '"${result.song.title}" listeye #$pos\'den girdi! Harika.')
                                    : (result.flopped
                                        ? '"${result.song.title}" listeye giremedi, gelir getirmedi.'
                                        : result.scandalTriggered
                                            ? '"${result.song.title}" yayınlandı! ⚠️ ${result.scandalDesc}'
                                            : '"${result.song.title}" yayınlandı! İlk tepki: ${band.label} ${band.emoji}');
                                // Hit ise konfeti (mega → büyük)
                                if (isHit) {
                                  playConfetti(context, big: mega);
                                }
                                // TEK POP-UP: sonuç + sosyal medya twiti
                                showDialog(
                                  context: context,
                                  builder: (dctx) => AlertDialog(
                                    title: Text(title),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(body),
                                        if (result.buzzHeadline != null) ...[
                                          const SizedBox(height: 12),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppColors.accentBlue
                                                  .withAlpha(18),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                                '🐦 ${result.buzzHeadline}',
                                                style: const TextStyle(
                                                    fontSize: 13)),
                                          ),
                                        ],
                                      ],
                                    ),
                                    actions: [
                                      if (result.buzzHeadline != null)
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(dctx);
                                            Navigator.of(dctx).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const SocialFeedScreen()));
                                          },
                                          child: const Text('Akışı Gör'),
                                        ),
                                      TextButton(
                                          onPressed: () => Navigator.pop(dctx),
                                          child: const Text('Tamam')),
                                    ],
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _preparing = false);
                            }
                          },
                  ),
                ],
              ),
            ),

            // ── Görünüm seçici (Diskografi / Grafik / Albümler) ──────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  _viewTab('Diskografi', 0),
                  const SizedBox(width: 6),
                  _viewTab('Grafik', 1),
                  const SizedBox(width: 6),
                  _viewTab('Albümler', 2),
                ],
              ),
            ),

            // ── Albüm çıkarma butonu (yalnızca Albümler görünümünde) ─────
            if (_view == 2)
              Consumer(builder: (context, ref, _) {
                final count = ref.watch(eligibleSongCountProvider).value ?? 0;
                final canMake = count >= AlbumManager.minTracks;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.album, size: 18),
                      label: Text(canMake
                          ? 'Albüm Çıkar ($count single hazır)'
                          : 'Albüm için en az ${AlbumManager.minTracks} albümsüz şarkı ($count)'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              canMake ? Colors.deepPurple : Colors.grey,
                          foregroundColor: Colors.white),
                      onPressed: (!canMake || career == null)
                          ? null
                          : () => _albumFlow(context, dash, career, db),
                    ),
                  ),
                );
              }),

            Expanded(
              child: _view == 1
                  ? _ChartView()
                  : _view == 2
                      ? _AlbumsView()
                      : _DiscoView(),
            ),
          ],
        );
      },
    );
  }

  Widget _viewTab(String label, int index) {
    final active = _view == index;
    return Expanded(
      child: PressableScale(
        onTap: () => setState(() => _view = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: active ? AppColors.buttonGradient : null,
            color: active ? null : AppColors.surface,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
                color: active ? Colors.transparent : AppColors.border,
                width: 1.5),
            boxShadow: active
                ? [
                    BoxShadow(
                        color: AppColors.primary.withAlpha(80),
                        blurRadius: 8,
                        offset: const Offset(0, 3)),
                  ]
                : null,
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: active ? Colors.white : AppColors.textSecondary)),
        ),
      ),
    );
  }

  Future<void> _albumFlow(BuildContext context, GroupDashboard dash,
      PlayerCareer career, AppDatabase db) async {
    final mgr = AlbumManager(db);
    final eligible = await mgr.eligibleSongs(dash.group.id);
    if (eligible.length < AlbumManager.minTracks) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Albüm için en az ${AlbumManager.minTracks} albümsüz şarkı gerek.')));
      }
      return;
    }
    if (!context.mounted) return;

    final result =
        await showDialog<({String title, List<int> ids, String concept})>(
      context: context,
      builder: (dctx) => _AlbumComposerDialog(
        mgr: mgr,
        careerId: career.id,
        groupId: dash.group.id,
        eligible: eligible,
      ),
    );
    if (result == null) return;

    final gate = await mgr.canRelease(career.id, dash.group.id, result.ids);
    if (!gate.ok) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(gate.reason)));
      }
      return;
    }

    final res = await mgr.releaseAlbum(
      careerId: career.id,
      groupId: dash.group.id,
      title: result.title,
      absMonth: absMonthOf(career),
      songIds: result.ids,
      concept: result.concept,
    );
    ref.invalidate(albumsProvider);
    ref.invalidate(eligibleSongCountProvider);
    ref.invalidate(songsProvider);
    ref.invalidate(chartProvider);
    ref.invalidate(groupDashboardProvider);
    ref.invalidate(walletProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            '"${res.album.title}" çıktı! Satış +${fmtCount(res.salesIncome)}₺ • Erişim +${fmtCount(res.popBoost)} • Takipçi +${fmtCount(res.followerGain)}'),
        duration: const Duration(seconds: 4),
      ));
    }
  }
}

// Albüm besteci diyaloğu: şarkı seçimi + konsept + gider/gelir tablosu
class _AlbumComposerDialog extends StatefulWidget {
  final AlbumManager mgr;
  final int careerId;
  final int groupId;
  final List<Song> eligible;
  const _AlbumComposerDialog({
    required this.mgr,
    required this.careerId,
    required this.groupId,
    required this.eligible,
  });

  @override
  State<_AlbumComposerDialog> createState() => _AlbumComposerDialogState();
}

class _AlbumComposerDialogState extends State<_AlbumComposerDialog> {
  final _ctrl = TextEditingController(text: 'Yeni Albüm');
  late Set<int> _selected;
  String _concept = 'standart';
  ({int cost, int salesIncome, int popBoost, int followerGain})? _q;

  @override
  void initState() {
    super.initState();
    // Varsayılan: en kaliteli ilk 5 şarkı seçili
    _selected = widget.eligible.take(5).map((s) => s.id).toSet();
    _refreshQuote();
  }

  Future<void> _refreshQuote() async {
    final q = await widget.mgr
        .quote(widget.careerId, widget.groupId, _selected.toList(), _concept);
    if (mounted) setState(() => _q = q);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _q;
    return AlertDialog(
      title: const Text('Albüm Besteci 💿'),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _ctrl,
                maxLength: 24,
                decoration: const InputDecoration(
                    labelText: 'Albüm adı', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              const Text('Konsept',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 6,
                children: AlbumManager.concepts.map((c) {
                  final sel = _concept == c.$1;
                  return ChoiceChip(
                    label: Text(c.$2),
                    selected: sel,
                    onSelected: (_) {
                      setState(() => _concept = c.$1);
                      _refreshQuote();
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Text('Şarkılar (${_selected.length} seçili)',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ...widget.eligible.map((s) {
                final sel = _selected.contains(s.id);
                return CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: sel,
                  title: Text(s.title, style: const TextStyle(fontSize: 13)),
                  subtitle: Text('Kalite ${s.qualityScore ?? 0}',
                      style: const TextStyle(fontSize: 11)),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _selected.add(s.id);
                      } else {
                        _selected.remove(s.id);
                      }
                    });
                    _refreshQuote();
                  },
                );
              }),
              const Divider(),
              if (q != null) ...[
                _tableRow(
                    'Üretim Gideri', '-${fmtCount(q.cost)}₺', AppColors.danger),
                _tableRow('Tahmini Satış Geliri',
                    '+${fmtCount(q.salesIncome)}₺', AppColors.success),
                _tableRow(
                    'Net',
                    '${q.salesIncome - q.cost >= 0 ? "+" : ""}${fmtCount(q.salesIncome - q.cost)}₺',
                    q.salesIncome - q.cost >= 0
                        ? AppColors.success
                        : AppColors.danger),
                const SizedBox(height: 4),
                _tableRow(
                    'Erişim', '+${fmtCount(q.popBoost)}', AppColors.primary),
                _tableRow('Takipçi', '+${fmtCount(q.followerGain)}',
                    AppColors.accentBlue),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç')),
        ElevatedButton(
          onPressed: (_selected.length < AlbumManager.minTracks ||
                  _ctrl.text.trim().isEmpty)
              ? null
              : () => Navigator.pop(context, (
                    title: _ctrl.text.trim(),
                    ids: _selected.toList(),
                    concept: _concept
                  )),
          child: const Text('Yayınla'),
        ),
      ],
    );
  }

  Widget _tableRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(value,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

// ── Albümler görünümü ──────────────────────────────────────────────────────────
class _AlbumsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(albumsProvider);
    return albumsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (albums) {
        if (albums.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                  'Henüz albüm yok.\n3+ single biriktirince albüm yapabilirsin.',
                  textAlign: TextAlign.center),
            ),
          );
        }
        return ListView.builder(
          itemCount: albums.length,
          itemBuilder: (context, i) {
            final a = albums[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple.shade100,
                  child: const Icon(Icons.album, color: Colors.deepPurple),
                ),
                title: Text(a.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    '${a.trackCount} parça  •  Ort. kalite ${a.avgQuality}  •  Erişim +${fmtCount(a.popBoost)}'),
                trailing: Text(monthYearLabel(a.releaseMonth),
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Şarkı seçim bottom sheet ──────────────────────────────────────────────────
class _SongSelectionSheet extends StatefulWidget {
  final SongSelectionData data;
  final int groupId;
  final int careerId;
  final int month;
  final int absMonth;
  final int groupPower;
  final int avgChemistry;
  final int walletBalance;
  final double costMult;
  final AppDatabase db;

  const _SongSelectionSheet({
    required this.data,
    required this.groupId,
    required this.careerId,
    required this.month,
    required this.absMonth,
    required this.groupPower,
    required this.avgChemistry,
    required this.walletBalance,
    required this.costMult,
    required this.db,
  });

  @override
  State<_SongSelectionSheet> createState() => _SongSelectionSheetState();
}

class _SongSelectionSheetState extends State<_SongSelectionSheet> {
  int _step = 0; // 0=başlık, 1=tür, 2=söz
  TitleOption? _selectedTitle;
  String _selectedGenre = kSongGenres.first;
  LyricOption? _selectedLyric;
  bool _hasMV = false;
  bool _releasing = false;
  ComebackConcept _concept = kComebackConcepts[1]; // varsayılan Girl-Crush

  late final SongManager _mgr = SongManager(widget.db);
  ({double v, double d, double r, double overall})? _disc;

  @override
  void initState() {
    super.initState();
    _mgr.groupDisciplineAvg(widget.groupId).then((d) {
      if (mounted) setState(() => _disc = d);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Adım göstergesi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  _stepChip(0, 'Başlık'),
                  const SizedBox(width: 6),
                  _stepChip(1, 'Tür'),
                  const SizedBox(width: 6),
                  _stepChip(2, 'Sözler'),
                ],
              ),
            ),
            // ── COMEBACK KONSEPTİ (kalıcı seçim) ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              color: _concept.color.withAlpha(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome,
                          size: 15, color: AppColors.primary),
                      const SizedBox(width: 5),
                      const Text('Comeback Konsepti',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w800)),
                      const Spacer(),
                      Text(_concept.hint,
                          style: TextStyle(
                              fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: kComebackConcepts.map((c) {
                        final sel = _concept.key == c.key;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: GestureDetector(
                            onTap: () => setState(() => _concept = c),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: sel
                                    ? c.color.withAlpha(45)
                                    : AppColors.surfaceHigh,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: sel ? c.color : AppColors.border,
                                    width: sel ? 2 : 1),
                              ),
                              child: Text(c.label,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: sel ? c.color : AppColors.ink)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _step == 0
                  ? _TitleStep(
                      titles: widget.data.titles,
                      selected: _selectedTitle,
                      onSelect: (t) => setState(() => _selectedTitle = t),
                      scrollCtrl: scrollCtrl,
                    )
                  : _step == 1
                      ? _GenreStep(
                          selected: _selectedGenre,
                          onSelect: (g) => setState(() => _selectedGenre = g),
                          mgr: _mgr,
                          disc: _disc,
                          month: widget.month,
                          scrollCtrl: scrollCtrl,
                        )
                      : _LyricStep(
                          lyrics: widget.data.lyrics,
                          selected: _selectedLyric,
                          onSelect: (l) => setState(() => _selectedLyric = l),
                          groupPower: widget.groupPower,
                          avgChem: widget.avgChemistry,
                          titleBonus: _selectedTitle?.qualityBonus ?? 0,
                          genre: _selectedGenre,
                          mgr: _mgr,
                          disc: _disc,
                          month: widget.month,
                          hasMV: _hasMV,
                          walletBalance: widget.walletBalance,
                          costMult: widget.costMult,
                          onToggleMV: (v) => setState(() => _hasMV = v),
                          scrollCtrl: scrollCtrl,
                        ),
            ),
            // Alt buton
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: _step < 2
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white),
                          onPressed:
                              _canNext() ? () => setState(() => _step++) : null,
                          child:
                              Text(_step == 0 ? 'Tür Seç →' : 'Sözleri Seç →'),
                        )
                      : ElevatedButton.icon(
                          icon: _releasing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.publish),
                          label: const Text('Şarkıyı Yayınla!'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              foregroundColor: Colors.white),
                          onPressed: (_releasing || _selectedLyric == null)
                              ? null
                              : _release,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canNext() {
    if (_step == 0) return _selectedTitle != null;
    if (_step == 1) return true; // tür her zaman seçili
    return _selectedLyric != null;
  }

  Future<void> _release() async {
    final cost =
        (SongManager.releaseCost(hasMusicVideo: _hasMV) * widget.costMult)
            .round();
    if (widget.walletBalance < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yetersiz bütçe (gerekli: $cost₺).')));
      return;
    }
    setState(() => _releasing = true);
    try {
      final result = await _mgr.releaseSong(
        groupId: widget.groupId,
        careerId: widget.careerId,
        title: _selectedTitle!.title,
        genre: _selectedGenre,
        month: widget.month,
        absMonth: widget.absMonth,
        groupPower: widget.groupPower,
        avgChemistry: widget.avgChemistry,
        titleQualityBonus: _selectedTitle!.qualityBonus,
        lyricOption: _selectedLyric!,
        hasMusicVideo: _hasMV,
        conceptQBonus: _concept.qBonus,
        conceptFollMult: _concept.follMult,
        conceptPopMult: _concept.popMult,
        conceptRep: _concept.repBonus,
        conceptScandal: _concept.scandal,
      );
      if (mounted) Navigator.pop(context, result);
    } finally {
      if (mounted) setState(() => _releasing = false);
    }
  }

  Widget _stepChip(int index, String label) {
    final active = _step == index;
    final done = _step > index;
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: done
              ? AppColors.success.withAlpha(28)
              : active
                  ? AppColors.primary.withAlpha(22)
                  : AppColors.surfaceHigh,
          border: Border.all(
              color: done
                  ? Colors.green
                  : active
                      ? Colors.pink
                      : AppColors.surfaceHigh),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (done) const Icon(Icons.check, size: 14, color: Colors.green),
            if (!done)
              Text('${index + 1}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.pink : Colors.grey)),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    color: done
                        ? Colors.green
                        : active
                            ? Colors.pink
                            : Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// Adım 1 — Başlık
class _TitleStep extends StatelessWidget {
  final List<TitleOption> titles;
  final TitleOption? selected;
  final void Function(TitleOption) onSelect;
  final ScrollController scrollCtrl;

  const _TitleStep({
    required this.titles,
    required this.selected,
    required this.onSelect,
    required this.scrollCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Başlık Seç',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Başlık, şarkının ilk izlenimini belirler.',
            style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 16),
        ...titles.map((t) {
          final sel = selected == t;
          final bonus = t.qualityBonus;
          final bonusStr = bonus >= 0 ? '+$bonus kalite' : '$bonus kalite';
          return GestureDetector(
            onTap: () => onSelect(t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    sel ? AppColors.primary.withAlpha(22) : AppColors.surface,
                border: Border.all(
                    color: sel ? Colors.pinkAccent : AppColors.surfaceHigh,
                    width: sel ? 2 : 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.title,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(t.hint,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: bonus > 0
                          ? AppColors.success.withAlpha(28)
                          : bonus < 0
                              ? AppColors.danger.withAlpha(28)
                              : AppColors.surfaceHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(bonusStr,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: bonus > 0
                                ? Colors.green
                                : bonus < 0
                                    ? Colors.red
                                    : Colors.grey)),
                  ),
                  if (sel)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check_circle, color: Colors.pinkAccent),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// Adım 2 — Tür (grup yatkınlığı + sezon ipuçlarıyla)
class _GenreStep extends StatelessWidget {
  final String selected;
  final void Function(String) onSelect;
  final SongManager mgr;
  final ({double v, double d, double r, double overall})? disc;
  final int month;
  final ScrollController scrollCtrl;

  const _GenreStep({
    required this.selected,
    required this.onSelect,
    required this.mgr,
    required this.disc,
    required this.month,
    required this.scrollCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Müzik Türü',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text(
            'Grubunuzun yeteneklerine ve mevsime uygun tür seçin. Uygun olmayan tür daha az dinlenir.',
            style: TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 16),
        ...kSongGenres.map((g) {
          final sel = selected == g;
          final fit = disc == null ? 0.0 : mgr.genreFit(disc!, g);
          final season = mgr.seasonFit(g, month);
          final fitInfo = _fitLabel(fit);
          return GestureDetector(
            onTap: () => onSelect(g),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    sel ? AppColors.primary.withAlpha(22) : AppColors.surface,
                border: Border.all(
                    color: sel ? Colors.pinkAccent : AppColors.surfaceHigh,
                    width: sel ? 2 : 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(g,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            _chip(disc == null ? '...' : fitInfo.label,
                                fitInfo.color),
                            if (season > 0) _chip('Sezona uygun', Colors.teal),
                            if (season < 0) _chip('Sezon dışı', Colors.orange),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (sel)
                    const Icon(Icons.check_circle, color: Colors.pinkAccent),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  ({String label, Color color}) _fitLabel(double fit) {
    if (fit >= 6) return (label: 'Grubunuza çok uygun', color: Colors.green);
    if (fit >= 0) return (label: 'Uygun', color: Colors.lightGreen);
    if (fit >= -8) return (label: 'Zorlayıcı', color: Colors.orange);
    return (label: 'Uygun değil', color: Colors.red);
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(90)),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

// Adım 3 — Söz seçimi (gizli kalite bandı + klip seçeneği)
class _LyricStep extends StatelessWidget {
  final List<LyricOption> lyrics;
  final LyricOption? selected;
  final void Function(LyricOption) onSelect;
  final int groupPower;
  final int avgChem;
  final int titleBonus;
  final String genre;
  final SongManager mgr;
  final ({double v, double d, double r, double overall})? disc;
  final int month;
  final bool hasMV;
  final int walletBalance;
  final double costMult;
  final void Function(bool) onToggleMV;
  final ScrollController scrollCtrl;

  const _LyricStep({
    required this.lyrics,
    required this.selected,
    required this.onSelect,
    required this.groupPower,
    required this.avgChem,
    required this.titleBonus,
    required this.genre,
    required this.mgr,
    required this.disc,
    required this.costMult,
    required this.month,
    required this.hasMV,
    required this.walletBalance,
    required this.onToggleMV,
    required this.scrollCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final gFit = disc == null ? 0.0 : mgr.genreFit(disc!, genre);
    final sFit = mgr.seasonFit(genre, month);
    final mvBonus = hasMV ? 7 : 0;
    // Tahmini taban (gizli sayı; sadece banda çevrilecek)
    final estBase =
        groupPower * 0.6 + avgChem * 0.4 + titleBonus + gFit + sFit + mvBonus;
    final cost =
        (SongManager.releaseCost(hasMusicVideo: hasMV) * costMult).round();

    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Şarkı Sözleri',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text(
            'Kesin kalite gizli — sadece tahmini bir izlenim görürsün. Tutup tutmayacağı çıkıştan sonra belli olur.',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 12),

        // Klip seçeneği
        Container(
          decoration: BoxDecoration(
            color: hasMV
                ? (AppColors.dark
                    ? Colors.deepPurple.withAlpha(80)
                    : Colors.deepPurple.shade50)
                : AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: hasMV ? Colors.deepPurple : AppColors.surfaceHigh),
          ),
          child: SwitchListTile(
            value: hasMV,
            onChanged: onToggleMV,
            activeThumbColor: Colors.deepPurple,
            title: const Text('Klip çek (+kalite, +erişim)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(
                'Klipli daha pahalı ama daha çok dinlenir.\nMaliyet: ${(SongManager.baseReleaseCost * costMult).round()}₺ + ${(SongManager.musicVideoCost * costMult).round()}₺ klip'
                '${costMult > 1.01 ? '\n(Prestij Vergisi ×${costMult.toStringAsFixed(1)} dahil)' : ''}'),
            secondary: Icon(Icons.movie,
                color: hasMV ? Colors.deepPurple : Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.payments, size: 16, color: Colors.green),
            const SizedBox(width: 4),
            Text('Toplam maliyet: $cost₺',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('Kasa: $walletBalance₺',
                style: TextStyle(
                    color: walletBalance >= cost ? Colors.grey : Colors.red,
                    fontSize: 12)),
          ],
        ),
        const Divider(height: 24),

        ...lyrics.map((l) {
          final sel = selected == l;
          final est = (estBase + l.qualityBonus).round().clamp(1, 100);
          final band = SongManager.qualityBand(est);
          final driftLabel = l.driftPerMonth <= 2
              ? 'Uzun ömürlü'
              : l.driftPerMonth <= 4
                  ? 'Normal ömür'
                  : l.driftPerMonth <= 5
                      ? 'Kısa ömürlü'
                      : 'Çok kısa ömürlü';

          return GestureDetector(
            onTap: () => onSelect(l),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: sel ? l.color.withAlpha(25) : AppColors.surface,
                border: Border.all(
                    color: sel ? l.color : AppColors.surfaceHigh,
                    width: sel ? 2 : 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(l.icon, color: l.color, size: 20),
                      const SizedBox(width: 8),
                      Text(l.profile,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: l.color)),
                      if (l.coachRecommended)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Koç tavsiyesi',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.brown)),
                        ),
                      if (l.isRisky)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withAlpha(28),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Riskli',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.red)),
                        ),
                      const Spacer(),
                      if (sel)
                        Icon(Icons.check_circle, color: l.color, size: 20),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(l.description,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      // GİZLİ KALİTE → sadece band
                      _tag('Tahmin: ${band.label} ${band.emoji}',
                          Colors.blueGrey),
                      _tag(driftLabel, Colors.teal),
                      _tag('Skandal: %${(l.scandalChance * 100).round()}',
                          l.scandalChance > 0.3 ? Colors.red : Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

// ── Diskografi listesi ────────────────────────────────────────────────────────
class _DiscoView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(songsProvider);
    return songsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (songs) {
        if (songs.isEmpty) {
          return Center(
              child: Text('Henüz şarkı çıkarılmadı.',
                  style: TextStyle(color: AppColors.onBgSoft)));
        }
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, i) {
            final s = songs[i];
            final pos = s.currentChartPosition;
            final offChart = pos == null;
            final quality = s.qualityScore ?? 0;
            final streams = s.totalStreams;
            // Şarkıya özel "albüm kapağı" gradyanı (id'den deterministik)
            const coverGrads = [
              [Color(0xFFE5447F), Color(0xFF7E2A9C)],
              [Color(0xFF6D5BD0), Color(0xFF21B5C4)],
              [Color(0xFFF2B544), Color(0xFFE5447F)],
              [Color(0xFF7C1F46), Color(0xFF6D5BD0)],
              [Color(0xFF21B5C4), Color(0xFF7E2A9C)],
              [Color(0xFF8C2470), Color(0xFFF2B544)],
            ];
            final cg = coverGrads[s.id % coverGrads.length];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: offChart
                                  ? [AppColors.surfaceHigh, AppColors.border]
                                  : cg),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: (offChart ? Colors.grey : cg[0])
                                    .withAlpha(70),
                                blurRadius: 6,
                                offset: const Offset(0, 3)),
                          ],
                        ),
                        child: Icon(Icons.music_note,
                            color: offChart ? Colors.grey : Colors.white,
                            size: 24),
                      ),
                      if (!offChart)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: Text('#$pos',
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.inkAlways)),
                          ),
                        ),
                    ],
                  ),
                ),
                title: Text(s.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${s.genre ?? "—"}  •  Kalite: $quality'
                  '  •  ${_fmtStreams(streams)} stream'
                  '${offChart ? "  •  Grafik dışı" : ""}',
                ),
                trailing: Text(monthYearLabel(s.releaseMonth),
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            );
          },
        );
      },
    );
  }

  String _fmtStreams(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return '$n';
  }
}

// ── Haftalık grafik listesi ───────────────────────────────────────────────────
class _ChartView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartAsync = ref.watch(chartProvider);
    return chartAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (entries) {
        if (entries.isEmpty) {
          return Center(
              child: Text('Grafik verisi yok.',
                  style: TextStyle(color: AppColors.onBgSoft)));
        }
        return Column(
          children: [
            // Renk açıklaması
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Row(
                children: [
                  _legend(Colors.pink.shade100, 'Senin grubun'),
                  const SizedBox(width: 12),
                  _legend(Colors.indigo.shade100, 'Manifesto'),
                  const SizedBox(width: 12),
                  _legend(AppColors.surfaceHigh, 'Diğer'),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, i) {
                  final e = entries[i];
                  Color bg;
                  Color rankColor;
                  if (e.isOurs) {
                    bg = AppColors.primary.withAlpha(22);
                    rankColor = Colors.pinkAccent;
                  } else if (e.isRival) {
                    bg = AppColors.secondary.withAlpha(28);
                    rankColor =
                        AppColors.dark ? Colors.indigo.shade200 : Colors.indigo;
                  } else {
                    bg = AppColors.surface;
                    rankColor = Colors.grey;
                  }

                  // Top-3 madalya renkleri (altın/gümüş/bronz)
                  Gradient? medal;
                  if (e.rank == 1) {
                    medal = AppColors.goldGradient;
                  } else if (e.rank == 2) {
                    medal = const LinearGradient(colors: [
                      Color(0xFFCFD8DC),
                      Color(0xFF90A4AE),
                    ]);
                  } else if (e.rank == 3) {
                    medal = const LinearGradient(colors: [
                      Color(0xFFD7995B),
                      Color(0xFFA76A3A),
                    ]);
                  }

                  return Container(
                    color: bg,
                    child: ListTile(
                      dense: true,
                      leading: SizedBox(
                        width: 36,
                        child: medal != null
                            ? Container(
                                width: 32,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: medal,
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 2)),
                                  ],
                                ),
                                child: Text('${e.rank}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15,
                                        color: Colors.white)),
                              )
                            : Text(
                                '#${e.rank}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: rankColor,
                                ),
                              ),
                      ),
                      title: Text(e.title,
                          style: TextStyle(
                              fontWeight: e.isOurs || e.isRival
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                      subtitle: Text(e.groupName,
                          style: TextStyle(fontSize: 12, color: rankColor)),
                      trailing: Text(
                        _fmtStreams(e.approxStreams),
                        style: TextStyle(
                            fontSize: 12,
                            color: rankColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.onBgSoft)),
      ],
    );
  }

  String _fmtStreams(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return '$n';
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Ortak yardımcılar
// ════════════════════════════════════════════════════════════════════════════
String fmtCount(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
  return '$n';
}

// Stajyer ret gerekçeleri
const List<String> _refusalReasons = [
  'Ailevi sebeplerle şu an katılamam',
  'Bu projeye tam inanmıyorum',
  'Okulumu bitirmek istiyorum',
  'Başka bir ajansla görüşüyorum',
  'Henüz hazır hissetmiyorum',
  'Ailem izin vermiyor',
  'Sağlık sorunlarım var',
];
String _refusalReason() =>
    _refusalReasons[Random().nextInt(_refusalReasons.length)];

// Seçme notu rozeti (S/A/B/C/D/F)
Widget _gradeChip(({String letter, Color color}) grade) {
  return Container(
    width: 24,
    height: 24,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: grade.color,
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: AppColors.ink, width: 1.5),
    ),
    child: Text(grade.letter,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
  );
}

// Şöhret rozeti (kampta + üyelerde). Yüksek şöhret turuncu/kırmızı.
Widget _fameBadge(int fame) {
  final Color c = fame >= 70
      ? Colors.deepOrange
      : fame >= 40
          ? Colors.orange
          : Colors.blueGrey;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: c.withAlpha(28),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: c.withAlpha(110)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('🔥', style: TextStyle(fontSize: 11)),
        const SizedBox(width: 2),
        Text('$fame',
            style:
                TextStyle(fontSize: 12, color: c, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

// Big5 mini-bar göstergesi
class _Big5Bars extends StatelessWidget {
  final GeneratedCharacter c;
  const _Big5Bars(this.c);

  @override
  Widget build(BuildContext context) {
    final rows = <({String label, int val, Color color})>[
      (label: 'Açıklık', val: c.openness, color: Colors.purple),
      (label: 'Özdisiplin', val: c.conscientiousness, color: Colors.blue),
      (label: 'Dışadönüklük', val: c.extraversion, color: Colors.orange),
      (label: 'Uyumluluk', val: c.agreeableness, color: Colors.green),
      (label: 'Duygusal Dengesizlik', val: c.neuroticism, color: Colors.red),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows.map((r) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(r.label, style: const TextStyle(fontSize: 12)),
              ),
              Expanded(
                child: GameBar(value: r.val / 100.0, color: r.color, height: 8),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 26,
                child: Text('${r.val}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  SEKME 6: SOSYAL / PR
// ════════════════════════════════════════════════════════════════════════════
class _SocialTab extends ConsumerWidget {
  const _SocialTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(groupDashboardProvider);
    final isDark = AppColors.dark;

    return dashAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (dash) {
        if (dash == null) {
          return _lockedByGroup(
              'Sosyal medya ve PR yönetimi grup kurulduktan sonra açılır.');
        }
        final g = dash.group;
        final pending = ref.watch(pendingEventsProvider).value ?? [];
        final feed = ref.watch(eventFeedProvider).value ?? [];

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            // ── Sosyal istatistikler (Premium Tasarım) ──
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surface.withAlpha(240)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withAlpha(150)
                        : AppColors.primary.withAlpha(45),
                    blurRadius: isDark ? 20 : 16,
                    offset: Offset(0, isDark ? 10 : 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.buttonGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.people_alt,
                              color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fmtCount(g.socialFollowers),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              'takipçi',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _statBar('İtibar', g.reputation, 100, AppColors.success),
                    const SizedBox(height: 10),
                    _statBar(
                        'Skandal Isısı',
                        g.scandalHeat,
                        100,
                        g.scandalHeat > 50
                            ? AppColors.danger
                            : AppColors.warning),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.trending_up,
                              color: AppColors.primary, size: 16),
                          const SizedBox(width: 6),
                          Text('Erişim: ${fmtCount(g.totalPopularity)}',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bekleyen kararlar ──
            if (pending.isNotEmpty) ...[
              _sectionTitle('🔔 Bekleyen Kararlar'),
              ...pending.map((ev) => _PendingEventCard(ev: ev)),
              const SizedBox(height: 8),
            ],

            // ── Sponsorluk ──
            _sectionTitle('🤝 Sponsorluk'),
            _SponsorCard(group: g),
            const SizedBox(height: 8),

            // ── Reklam anlaşması (aylık 3 hak) ──
            _sectionTitle('📺 Reklam Anlaşması'),
            const _AdDealCard(),
            const SizedBox(height: 8),

            // ── PR aksiyonları (reklam anlaşması hariç) ──
            _sectionTitle('📣 PR Aksiyonları'),
            ...PRManager.campaigns
                .where((c) => c.key != 'ad_deal')
                .map((c) => _PRCampaignCard(campaign: c)),
            const SizedBox(height: 8),

            // ── Ayrı ekranlar: sosyal medya + başarımlar/ödüller ──
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.forum, size: 18),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentBlue,
                        foregroundColor: Colors.white),
                    label: const Text('Sosyal Medya'),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const SocialFeedScreen())),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.emoji_events, size: 18),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white),
                    label: const Text('Başarım & Ödül'),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const AchievementsAwardsScreen())),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Akış ──
            _sectionTitle('📰 Akış'),
            if (feed.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh.withAlpha(150),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Text(
                    'Henüz olay yok. Ay ilerledikçe haberler burada görünecek.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600)),
              )
            else
              ...feed.map((ev) => _FeedCard(ev: ev)),
          ],
        );
      },
    );
  }

  // Bölüm başlıkları için yardımcı widget
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(title,
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.ink)),
    );
  }

  // İstatistik barları için yardımcı widget
  Widget _statBar(String label, int value, int max, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink)),
            Text('$value/$max',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        GameBar(value: value / max, color: color, height: 10),
      ],
    );
  }
}

// ── Bekleyen olay kartı ──
class _PendingEventCard extends ConsumerWidget {
  final Event ev;
  const _PendingEventCard({required this.ev});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = kEventCategoryMeta[ev.category];
    return Card(
      color: AppColors.warning.withAlpha(28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.amber.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(meta?.emoji ?? '🔔', style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(ev.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(ev.description ?? '',
                style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.gavel, size: 18),
                label: const Text('Karar Ver'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white),
                onPressed: () => _showEventDecision(context, ref, ev),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showEventDecision(
    BuildContext context, WidgetRef ref, Event ev) async {
  final db = ref.read(databaseProvider);
  final engine = EventEngine(db);
  // {name}/{rival} yer tutucuları + etkilenen üye avatarları
  final choices = await engine.renderedChoicesForEvent(ev);
  final members = await engine.affectedMembersInfo(ev.id);
  if (!context.mounted) return;

  final meta = kEventCategoryMeta[ev.category];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.74,
        maxChildSize: 0.92,
        builder: (_, scrollCtrl) => SingleChildScrollView(
          controller: scrollCtrl,
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
          child: GamePanel(
            title: ev.title,
            headerIcon: Icons.remove_red_eye,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Etkilenen üye avatarları (varsa)
                if (members.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: members.map((m) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Column(
                          children: [
                            CharacterAvatar(
                              imagePath: m.imagePath,
                              initial: m.name,
                              size: 84,
                              tint: AppColors.surfaceHigh,
                            ),
                            const SizedBox(height: 6),
                            Text(m.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.ink)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 10),
                ],

                // Soru / açıklama
                Text(ev.description ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.ink,
                        height: 1.3)),
                const SizedBox(height: 16),

                // Chunky seçim butonları
                ...choices.asMap().entries.map((entry) {
                  final i = entry.key;
                  final c = entry.value;
                  return ChunkyButton(
                    label: c.label,
                    accent: _accentForCategory(ev.category, meta),
                    onTap: () async {
                      await engine.resolveEvent(ev.id, i);
                      ref.invalidate(pendingEventsProvider);
                      ref.invalidate(eventFeedProvider);
                      ref.invalidate(groupDashboardProvider);
                      ref.invalidate(memberRelationsProvider);
                      ref.invalidate(walletProvider);
                      ref.invalidate(myInventoryProvider);
                      ref.invalidate(songsProvider);
                      ref.invalidate(chartProvider);
                      ref.invalidate(socialPostsProvider);
                      ref.invalidate(transactionsProvider);
                      final outcomeLabel = c.label;
                      final outcomeText = c.outcome;
                      final rootCtx = sheetCtx.mounted
                          ? Navigator.of(sheetCtx, rootNavigator: true).context
                          : null;
                      if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                      if (rootCtx != null && rootCtx.mounted) {
                        showDialog(
                          context: rootCtx,
                          builder: (dialogCtx) => AlertDialog(
                            title: Text(outcomeLabel),
                            content: Text(outcomeText),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogCtx),
                                child: const Text('Tamam'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Color _accentForCategory(String category, dynamic meta) {
  switch (category) {
    case 'rival':
      return AppColors.danger;
    case 'company':
      return AppColors.accentBlue;
    case 'intra_group':
      return AppColors.secondary;
    default:
      return AppColors.primary;
  }
}

// ── Reklam anlaşması kartı (aylık 3 hak) ──
class _AdDealCard extends ConsumerWidget {
  const _AdDealCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final used = ref.watch(adDealsUsedThisMonthProvider);
    final full = used >= kAdDealsPerMonth;
    final ad = PRManager.campaigns.firstWhere((c) => c.key == 'ad_deal');
    final label = full ? 'Bu ay doldu' : 'Reklam Çek';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.withAlpha(40),
                  child: const Icon(Icons.handshake, color: Colors.green),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Reklam Anlaşması',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: full
                        ? AppColors.danger.withAlpha(28)
                        : AppColors.success.withAlpha(28),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Bu ay: $used/$kAdDealsPerMonth',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: full ? AppColors.danger : AppColors.success)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
                'Markayla reklam çek, hızlı gelir kazan — ama her çekim imajı biraz yıpratır. Ayda 3 hak.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: full ? Colors.grey : Colors.green,
                    foregroundColor: Colors.white),
                onPressed: full ? null : () => _runAdDeal(context, ref, ad),
                child: Text(label),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runAdDeal(
      BuildContext context, WidgetRef ref, PRCampaign ad) async {
    final db = ref.read(databaseProvider);
    final career = ref.read(activeCareerProvider).value;
    if (career == null) return;
    final result =
        await PRManager(db).runCampaign(career.id, career.currentMonth, ad);
    if (result.success) {
      ref.read(adDealsUsedThisMonthProvider.notifier).state =
          ref.read(adDealsUsedThisMonthProvider) + 1;
    }
    ref.invalidate(walletProvider);
    ref.invalidate(groupDashboardProvider);
    ref.invalidate(eventFeedProvider);
    ref.invalidate(transactionsProvider);
    if (context.mounted) {
      showActionResult(context, result.message,
          success: result.success,
          title: result.backfired ? '😬 Ters Tepti' : '📺 Reklam Geliri');
    }
  }
}

// ── PR kampanya kartı ──
class _PRCampaignCard extends ConsumerWidget {
  final PRCampaign campaign;
  const _PRCampaignCard({required this.campaign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dash = ref.watch(groupDashboardProvider).value;
    final wallet = ref.watch(walletProvider).value ?? 0;
    final scandalHeat = dash?.group.scandalHeat ?? 0;
    final prUsed = ref.watch(prUsedThisWeekProvider);
    final weekFull = prUsed >= kPrPerWeek;
    final mult = ref.watch(costMultProvider);
    final scaledCost = (campaign.cost * mult).round();

    // Kriz yönetimi sadece skandal varken anlamlı + haftalık PR limiti
    final disabled = (campaign.needsScandal && scandalHeat < 10) ||
        wallet < scaledCost ||
        weekFull;
    final costLabel = weekFull
        ? 'Hafta doldu'
        : (campaign.cost == 0 ? 'Ücretsiz' : '$scaledCost₺');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: campaign.color.withAlpha(40),
          child: Icon(campaign.icon, color: campaign.color),
        ),
        title: Text(campaign.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            Text(campaign.description, style: const TextStyle(fontSize: 12)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: disabled ? Colors.grey : campaign.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10)),
          onPressed: disabled ? null : () => _confirmPR(context, ref, campaign),
          child: Text(costLabel, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }

  void _confirmPR(BuildContext context, WidgetRef ref, PRCampaign c) {
    final mult = ref.read(costMultProvider);
    final scaledCost = (c.cost * mult).round();
    showDialog(
      context: context,
      builder: (dctx) => AlertDialog(
        title: Text(c.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.description),
            const SizedBox(height: 12),
            Text('Maliyet: ${c.cost == 0 ? "Ücretsiz" : "$scaledCost₺"}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (c.backfireChance > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                    '⚠️ Ters tepme riski: %${(c.backfireChance * 100).round()}',
                    style: const TextStyle(color: Colors.orange, fontSize: 12)),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dctx),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: c.color, foregroundColor: Colors.white),
            onPressed: () async {
              final db = ref.read(databaseProvider);
              final career = ref.read(activeCareerProvider).value;
              if (career == null) return;
              final result = await PRManager(db)
                  .runCampaign(career.id, career.currentMonth, c);
              // Başarılı PR haftalık hakkı tüketir
              if (result.success) {
                ref.read(prUsedThisWeekProvider.notifier).state =
                    ref.read(prUsedThisWeekProvider) + 1;
              }
              ref.invalidate(walletProvider);
              ref.invalidate(groupDashboardProvider);
              ref.invalidate(memberRelationsProvider);
              ref.invalidate(eventFeedProvider);
              ref.invalidate(myInventoryProvider);
              if (dctx.mounted) Navigator.pop(dctx);
              if (context.mounted) {
                showActionResult(context, result.message,
                    success: result.success,
                    title: result.backfired ? '😬 Ters Tepti' : '📣 PR Sonucu');
              }
            },
            child: const Text('Başlat'),
          ),
        ],
      ),
    );
  }
}

// ── Sponsor kartı ──
class _SponsorCard extends ConsumerWidget {
  final Group group;
  const _SponsorCard({required this.group});

  Future<void> _openSponsorOffers(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final career = ref.read(activeCareerProvider).value;
    if (career == null) return;
    final gate = await PRManager(db).canGetSponsor(career.id);
    if (!gate.ok) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(gate.reason)));
      }
      return;
    }
    final offers = await PRManager(db).generateSponsorOffers(career.id);
    if (!context.mounted) return;

    final picked = await showDialog<({SponsorOffer offer, int income})>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.handshake, color: Colors.teal),
            const SizedBox(width: 10),
            Text('Sponsor Teklifleri', style: TextStyle(color: AppColors.ink)),
          ],
        ),
        content: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: offers.map((o) {
              final rep = o.offer.repDelta;
              final loy = o.offer.loyaltyDelta;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.dark
                      ? AppColors.surfaceHigh.withAlpha(150)
                      : AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(dctx, o),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${o.offer.emoji}  ${o.offer.name}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: AppColors.ink)),
                          const SizedBox(height: 4),
                          Text(o.offer.blurb,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _sponsorStat('+${fmtCount(o.income)}₺/ay',
                                  AppColors.success),
                              _sponsorStat(
                                  'İtibar ${rep >= 0 ? "+" : ""}$rep',
                                  rep >= 0
                                      ? AppColors.success
                                      : AppColors.danger),
                              _sponsorStat(
                                  'Fandom ${loy >= 0 ? "+" : ""}$loy',
                                  loy >= 0
                                      ? AppColors.primary
                                      : AppColors.danger),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx),
              child: const Text('Şimdilik Reddet',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
    if (picked == null) return;

    final res = await PRManager(db).signSponsorOffer(
        career.id, career.currentMonth, picked.offer, picked.income);
    ref.invalidate(groupDashboardProvider);
    ref.invalidate(eventFeedProvider);
    ref.invalidate(transactionsProvider);
    if (context.mounted) {
      showActionResult(context, res.message,
          success: res.success,
          title: res.success ? '🤝 Sponsor Anlaşması' : '⚠️ Olmadı');
    }
  }

  Widget _sponsorStat(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w800, color: color)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = group.sponsorMonthsLeft > 0;
    final isDark = AppColors.dark;

    return Container(
      decoration: BoxDecoration(
        color: active
            ? (isDark ? const Color(0xFF0F1F1E) : Colors.teal.shade50)
            : (isDark ? AppColors.surface.withAlpha(200) : AppColors.surface),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: active ? Colors.teal.withAlpha(120) : AppColors.border,
            width: 1.5),
        boxShadow: [
          BoxShadow(
            color: (active ? Colors.teal : AppColors.primary)
                .withAlpha(isDark ? 30 : 20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: active
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal.withAlpha(40),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.handshake,
                            color: Colors.teal, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(group.sponsorName ?? 'Sponsor',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: AppColors.ink)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                      'Aylık +${fmtCount(group.sponsorIncome)}₺ • ${group.sponsorMonthsLeft} ay kaldı',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary)),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'En az ${PRManager.sponsorFollowerGate ~/ 1000}K takipçiyle marka teklifleri gelir. ${PRManager.sponsorDurationMonths} ay sabit aylık gelir; her marka farklı para/itibar/fandom etkisi sunar — birini seç.',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          height: 1.4)),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.handshake, size: 18),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      label: const Text('Sponsor Tekliflerini Gör',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      onPressed: () => _openSponsorOffers(context, ref),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Göreceli zaman etiketi (sosyal medya)
String relativeWeekLabel(int deltaWeeks) {
  if (deltaWeeks <= 0) return 'bugün';
  if (deltaWeeks < 4) return '$deltaWeeks hafta önce';
  final months = deltaWeeks ~/ 4;
  return '$months ay önce';
}

// ── Sosyal medya buzz kartı (twitter-vari) ──
class _BuzzCard extends StatelessWidget {
  final SocialPost buzz;
  final int? currentAbsWeek;
  const _BuzzCard({required this.buzz, this.currentAbsWeek});

  @override
  Widget build(BuildContext context) {
    final (Color tint, String tag, bool verified) = switch (buzz.postType) {
      'fan' => (AppColors.primary, 'Hayran', false),
      'member' => (AppColors.secondary, 'Üye', true),
      'rival' => (Colors.orange, 'Rakip Fanı', false),
      _ => (AppColors.danger, 'Hater', false),
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: tint.withAlpha(38),
              child:
                  Text(buzz.avatarEmoji, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(buzz.displayName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      if (verified)
                        const Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Icon(Icons.verified,
                              size: 14, color: AppColors.accentBlue),
                        ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: tint.withAlpha(28),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(tag,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: tint)),
                      ),
                    ],
                  ),
                  Text(
                      currentAbsWeek == null
                          ? buzz.handle
                          : '${buzz.handle} · ${relativeWeekLabel(currentAbsWeek! - buzz.absWeek)}',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(buzz.content, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.favorite_border,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 3),
                      Icon(Icons.mode_comment_outlined,
                          size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 3),
                      Icon(Icons.repeat,
                          size: 14, color: AppColors.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sosyal medya ekranı (biriken gönderiler) ──
class SocialFeedScreen extends ConsumerWidget {
  const SocialFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(socialPostsProvider).value ?? [];
    final career = ref.watch(activeCareerProvider).value;
    final curAbsWeek = career == null
        ? null
        : (career.currentYear - 1) * 48 +
            (career.currentMonth - 1) * 4 +
            career.currentWeek;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.headerGradient)),
        title: const Text('🐦 Sosyal Medya'),
      ),
      body: posts.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                    'Henüz konuşulmuyorsunuz.\nHafta ilerledikçe yorumlar burada birikecek.',
                    textAlign: TextAlign.center),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: posts
                  .map((p) => _BuzzCard(buzz: p, currentAbsWeek: curAbsWeek))
                  .toList(),
            ),
    );
  }
}

// ── Başarımlar & Ödüller ekranı ──
class AchievementsAwardsScreen extends ConsumerWidget {
  const AchievementsAwardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = (ref.watch(achievementsProvider).value ?? [])
        .map((a) => a.achKey)
        .toSet();
    final awards = ref.watch(awardsProvider).value ?? [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.headerGradient)),
        title: const Text('🏅 Başarımlar & Ödüller'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
              'Başarımlar (${unlocked.length}/${AchievementManager.defs.length})',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBgStrong)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AchievementManager.defs.map((d) {
              final on = unlocked.contains(d.$1);
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: on
                      ? AppColors.primary.withAlpha(28)
                      : AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: on ? AppColors.primary : AppColors.border),
                ),
                child: Text(
                  on ? d.$2 : '🔒 ${d.$2}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: on ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('Kazanılan Ödüller (${awards.length})',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBgStrong)),
          const SizedBox(height: 8),
          if (awards.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                  'Henüz ödül yok. Ay/yıl sonlarında ödüller burada görünecek.'),
            )
          else
            ...awards.map((a) => Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: const Icon(Icons.emoji_events,
                        color: Colors.amber, size: 30),
                    title: Text(a.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(monthYearLabel(a.monthOccurred)),
                  ),
                )),
        ],
      ),
    );
  }
}

// ── Ay sonu gelir/gider tablosu popup'ı ──
class _MonthlyReportDialog extends StatelessWidget {
  final TrainingReport report;
  const _MonthlyReportDialog({required this.report});

  @override
  Widget build(BuildContext context) {
    final incomeLabel =
        report.isStreamIncome ? 'Stream Geliri' : 'Yayın Geliri';
    final totalIncome = report.broadcastIncome + report.sponsorIncome;
    final totalExpense = report.idolSalaryPaid + report.totalSalaryPaid;
    final net = totalIncome - totalExpense;

    Widget row(String label, int amount, {bool isExpense = false}) {
      final color = amount == 0
          ? AppColors.textSecondary
          : (isExpense ? AppColors.danger : AppColors.success);
      final sign = amount == 0 ? '' : (isExpense ? '-' : '+');
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            Text('$sign${fmtCount(amount)}₺',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
      );
    }

    return AlertDialog(
      title: const Text('🗓️ Ay Sonu Bilanço'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('GELİRLER',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success)),
            row(incomeLabel, report.broadcastIncome),
            row('Sponsor Geliri', report.sponsorIncome),
            const SizedBox(height: 8),
            const Text('GİDERLER',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.danger)),
            row('İdol Maaşları', report.idolSalaryPaid, isExpense: true),
            row('Koç Maaşları', report.totalSalaryPaid, isExpense: true),
            if (report.idolSalaryDebt > 0)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                    '⚠️ Ödenemeyen maaş borcu: ${report.idolSalaryDebt}₺',
                    style:
                        const TextStyle(fontSize: 12, color: AppColors.danger)),
              ),
            if (report.quitCoaches.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('Ayrılan koç: ${report.quitCoaches.join(", ")}',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ),
            const Divider(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bu Ay Net',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${net >= 0 ? "+" : ""}${fmtCount(net)}₺',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color:
                            net >= 0 ? AppColors.success : AppColors.danger)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kasa',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${fmtCount(report.endingBalance)}₺',
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: AppColors.primary)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const FinanceHistoryScreen()));
          },
          child: const Text('Tüm Hareketler'),
        ),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam')),
      ],
    );
  }
}

// Kategori → (ikon, etiket)
({IconData icon, String label}) _txnMeta(String category) {
  switch (category) {
    case 'song':
      return (icon: Icons.music_note, label: 'Şarkı');
    case 'album':
      return (icon: Icons.album, label: 'Albüm');
    case 'concert':
      return (icon: Icons.mic_external_on, label: 'Konser');
    case 'tour':
      return (icon: Icons.directions_bus, label: 'Tur');
    case 'pr':
      return (icon: Icons.campaign, label: 'PR');
    case 'vacation':
      return (icon: Icons.beach_access, label: 'Tatil');
    case 'care':
      return (icon: Icons.favorite, label: 'Üye İlgisi');
    case 'salary_idol':
      return (icon: Icons.groups, label: 'İdol Maaşı');
    case 'salary_coach':
      return (icon: Icons.school, label: 'Koç Maaşı');
    case 'broadcast':
    case 'stream':
      return (icon: Icons.podcasts, label: 'Yayın');
    case 'sponsor':
      return (icon: Icons.handshake, label: 'Sponsor');
    default:
      return (icon: Icons.bolt, label: 'Olay');
  }
}

// Onboarding rehber bölümleri (Nasıl Oynanır + ilk kez otomatik popup)
const List<({String icon, String title, String body})> kHowToSections = [
  (
    icon: '🎯',
    title: 'Amaç',
    body:
        'Bir kız grubu kur ve büyüt. Ana hedef: bir kariyerde tüm çekirdek başarımları açmak (epik stream serisi bonus). Yol boyunca rakip grup Manifesto\'yu geçmeye çalış.'
  ),
  (
    icon: '🎤',
    title: '1) Seçmeler',
    body:
        'Kamp sekmesinde adaylara bak ve 20 stajyer seç. Bazı adaylar teklifini reddedebilir. Not (S/A/B/C…) potansiyeli kabaca gösterir.'
  ),
  (
    icon: '✂️',
    title: '2) Eleme',
    body:
        'Elindeki 20 stajyeri zamanla 6 kişiye indir. Eğitimle geliştikçe en iyileri seç. Ayda en fazla 2 eleme yapabilirsin.'
  ),
  (
    icon: '👯',
    title: '3) Grup Kur & Debüt',
    body:
        'Kadro 6 kişiye inince Grup sekmesinden gruba bir isim ver ve debüt yap. Artık şarkı, konser ve sosyal medya açılır.'
  ),
  (
    icon: '🎵',
    title: '4) Şarkı & Albüm',
    body:
        'Ayda 1 single çıkar (başlık + tür + söz seç). Listede yükselmek için kaliteli üret. Birikmiş single\'ları albümde topla — hit albüm ödül getirir.'
  ),
  (
    icon: '🎤',
    title: '5) Konser & Tur',
    body:
        'Yeterli takipçiye ulaşınca konser/tur ver. Boyut seç (Kulüp/Salon/Arena). İtibarın düşük, skandalın yüksekse konser ZARAR edebilir!'
  ),
  (
    icon: '📺',
    title: '6) Para & Sponsor',
    body:
        'Reklam anlaşması (ayda 3 hak) ve sponsorluklarla gelir kazan. DİKKAT: büyüdükçe "prestij vergisi" ile tüm masraflar artar — hesap yap, batma.'
  ),
  (
    icon: '⚔️',
    title: '7) Olaylar & Kararlar',
    body:
        'Skandallar, Rodez husumeti, transfer teklifleri… Sosyal sekmesinde kararları yanıtla. Bekleyen bir karar varken haftaya GEÇEMEZSİN.'
  ),
  (
    icon: '⏭️',
    title: '8) Zamanı İlerlet',
    body:
        'Sağ üstteki ileri (⏩) tuşuyla haftayı ilerlet. 4 hafta = 1 ay. Ay sonunda gelir/gider bilançosu çıkar. Cüzdana tıklayıp Mali Geçmiş\'i görebilirsin.'
  ),
];

// "Nasıl Oynanır?" rehberi (menü + ilk kariyerde otomatik açılır)
class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.headerGradient)),
        title: const Text('📖 Nasıl Oynanır?'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          ...kHowToSections.map((s) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.icon, style: const TextStyle(fontSize: 26)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 3),
                            Text(s.body,
                                style:
                                    const TextStyle(fontSize: 13, height: 1.3)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 6),
          Center(
            child: Text('İyi şanslar, menajer! 🌟',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary.withAlpha(200))),
          ),
        ],
      ),
    );
  }
}

// ── Genel başarımlar ekranı (ana menü, kalıcı) ──
class GlobalAchievementsScreen extends ConsumerWidget {
  const GlobalAchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(globalAchievementsProvider).value ?? {};
    const defs = GlobalAchievementManager.defs;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.headerGradient)),
        title: Text('🌟 Genel Başarımlar (${unlocked.length}/${defs.length})'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Card(
            color: Color(0xFFF3EEFF),
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                  '🎯 Ana hedef: bir kariyerde tüm çekirdek başarımları açarak "Koleksiyoncu"yu kazan. Epik stream serisi ekstra şan içindir. Bu başarımlar kariyerler arası kalıcıdır.',
                  style: TextStyle(fontSize: 13)),
            ),
          ),
          const SizedBox(height: 8),
          ...defs.map((d) {
            final on = unlocked.contains(d.$1);
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: on ? null : AppColors.surfaceHigh,
              child: ListTile(
                leading: Icon(
                  on ? Icons.military_tech : Icons.lock_outline,
                  color: on ? Colors.amber : AppColors.textSecondary,
                  size: 32,
                ),
                title: Text(d.$2,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: on ? AppColors.ink : AppColors.textSecondary)),
                subtitle: Text(d.$3, style: const TextStyle(fontSize: 12)),
                trailing: on
                    ? const Icon(Icons.check_circle, color: AppColors.success)
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Mali geçmiş ekranı (aylara göre gruplu işlem defteri) ──
class FinanceHistoryScreen extends ConsumerWidget {
  const FinanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txns = ref.watch(transactionsProvider).value ?? [];
    // absMonth'a göre grupla (sıra korunur — provider desc döndürür)
    final groups = <int, List<Transaction>>{};
    for (final t in txns) {
      groups.putIfAbsent(t.absMonth, () => []).add(t);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.headerGradient)),
        title: const Text('💰 Mali Geçmiş'),
      ),
      body: txns.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                    'Henüz mali hareket yok.\nŞarkı, konser, maaş gibi işlemler burada birikecek.',
                    textAlign: TextAlign.center),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: groups.entries.map((entry) {
                final items = entry.value;
                final net = items.fold<int>(0, (s, t) => s + t.amount);
                final first = items.first;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${first.year}. Yıl • ${first.displayMonth}. Ay',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            Text('${net >= 0 ? "+" : ""}${fmtCount(net)}₺',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: net >= 0
                                        ? AppColors.success
                                        : AppColors.danger)),
                          ],
                        ),
                        const Divider(height: 14),
                        ...items.map((t) {
                          final meta = _txnMeta(t.category);
                          final income = t.amount >= 0;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              children: [
                                Icon(meta.icon,
                                    size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(t.label,
                                      style: const TextStyle(fontSize: 13)),
                                ),
                                Text(
                                    '${income ? "+" : ""}${fmtCount(t.amount)}₺',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: income
                                            ? AppColors.success
                                            : AppColors.danger)),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

// Genel aksiyon sonucu pop-up'ı (snackbar yerine — görsellik için)
void showActionResult(BuildContext context, String message,
    {bool success = true, String? title}) {
  showDialog(
    context: context,
    builder: (dctx) => AlertDialog(
      title: Text(title ?? (success ? '✅ Başarılı' : '⚠️ Olmadı')),
      content: Text(message, style: const TextStyle(fontSize: 14)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(dctx), child: const Text('Tamam')),
      ],
    ),
  );
}

// Sosyal medya buzz pop-up'ı (snackbar yerine — görsellik için)
void showBuzzDialog(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (dctx) => AlertDialog(
      title: const Row(
        children: [
          Text('🐦', style: TextStyle(fontSize: 22)),
          SizedBox(width: 8),
          Text('Sosyal Medyada'),
        ],
      ),
      content: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.accentBlue.withAlpha(18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accentBlue.withAlpha(60)),
        ),
        child: Text(text, style: const TextStyle(fontSize: 14)),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dctx);
            Navigator.of(dctx).push(
                MaterialPageRoute(builder: (_) => const SocialFeedScreen()));
          },
          child: const Text('Akışı Gör'),
        ),
        TextButton(
            onPressed: () => Navigator.pop(dctx), child: const Text('Kapat')),
      ],
    ),
  );
}

// ── Ödül kazanma popup'ı (kupa + yazı) ──
// ── Ödül töreni ekranı (Yılın Grubu için dramatik açılış) ──
class AwardCeremonyScreen extends StatefulWidget {
  final String groupName;
  const AwardCeremonyScreen({super.key, required this.groupName});
  @override
  State<AwardCeremonyScreen> createState() => _AwardCeremonyScreenState();
}

class _AwardCeremonyScreenState extends State<AwardCeremonyScreen> {
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() => _revealed = true);
      playConfetti(context, big: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0716),
      body: Stack(
        children: [
          // Sahne ışıkları
          Positioned(
              top: -60,
              left: 20,
              child: Transform.rotate(
                  angle: 0.3, child: _beam(AppColors.secondary))),
          Positioned(
              top: -60,
              right: 20,
              child:
                  Transform.rotate(angle: -0.3, child: _beam(AppColors.gold))),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🏆  YILIN GRUBU ÖDÜLLERİ  🏆',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1)),
                  const SizedBox(height: 40),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, anim) => ScaleTransition(
                        scale: CurvedAnimation(
                            parent: anim, curve: Curves.elasticOut),
                        child: FadeTransition(opacity: anim, child: child)),
                    child: _revealed
                        ? Column(
                            key: const ValueKey('reveal'),
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.goldGradient,
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.gold.withAlpha(150),
                                        blurRadius: 40,
                                        spreadRadius: 4),
                                  ],
                                ),
                                child: const Icon(Icons.emoji_events,
                                    size: 72, color: Colors.white),
                              ),
                              const SizedBox(height: 24),
                              const Text('VE KAZANAN...',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      letterSpacing: 2)),
                              const SizedBox(height: 8),
                              ShaderMask(
                                shaderCallback: (b) =>
                                    AppColors.goldGradient.createShader(b),
                                child: Text(widget.groupName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800)),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                  'Erişim +300K • Takipçi +50K • İtibar +10',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 12)),
                            ],
                          )
                        : const Column(
                            key: ValueKey('envelope'),
                            children: [
                              Text('✉️', style: TextStyle(fontSize: 90)),
                              SizedBox(height: 16),
                              Text('Zarf açılıyor...',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15)),
                            ],
                          ),
                  ),
                  const SizedBox(height: 48),
                  if (_revealed)
                    GameButton(
                      label: 'Muhteşem!',
                      icon: Icons.celebration,
                      gradient: AppColors.goldGradient,
                      onTap: () => Navigator.pop(context),
                      fullWidth: false,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _beam(Color c) => Container(
        width: 110,
        height: 320,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [c.withAlpha(60), Colors.transparent],
          ),
        ),
      );
}

// ── Ödül kazanma popup'ı (kupa + yazı) ──
class _AwardDialog extends StatelessWidget {
  final String title;
  const _AwardDialog({required this.title});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: AppColors.dark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF3B0D1F), Color(0xFF160314)],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFF6D8), Colors.white],
                ),
          border: Border.all(color: AppColors.gold, width: 2),
          boxShadow: [
            BoxShadow(
                color: AppColors.gold.withAlpha(60),
                blurRadius: 20,
                spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 12),
            const Text('ÖDÜL KAZANDIN!',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 1.5,
                    color: AppColors.gold)),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppColors.dark ? Colors.white : AppColors.ink)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.black87,
                    elevation: 5,
                    shadowColor: AppColors.gold.withAlpha(120),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                onPressed: () => Navigator.pop(context),
                child: const Text('Harika!',
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Gazete küpürü popup'ı (ay sonu manşeti) ──
// ── FLAŞ HABER: üye ayrılığı son dakika popup'ı ──────────────────────────────
class _FlashNewsDialog extends StatelessWidget {
  final List<String> names;
  const _FlashNewsDialog({required this.names});

  @override
  Widget build(BuildContext context) {
    final who = names.join(' ve ');
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: const Color(0xFF16101E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.danger, width: 2),
          boxShadow: [
            BoxShadow(
                color: AppColors.danger.withAlpha(90),
                blurRadius: 24,
                offset: const Offset(0, 8)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kırmızı son dakika bandı
            Container(
              width: double.infinity,
              color: AppColors.danger,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bolt, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text('FLAŞ HABER',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 3)),
                  SizedBox(width: 6),
                  Icon(Icons.bolt, color: Colors.white, size: 18),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              child: Column(
                children: [
                  const Text('💔', style: TextStyle(fontSize: 44)),
                  const SizedBox(height: 10),
                  Text('$who GRUPTAN AYRILDI!'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          height: 1.2)),
                  const SizedBox(height: 8),
                  const Text(
                      'Sosyal medya çalkalanıyor — hayranlar tepkilerini art arda paylaşıyor. Takipçi ve erişim düştü.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: Colors.white30),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kapat'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: Colors.white),
                      icon: const Icon(Icons.forum, size: 18),
                      label: const Text('Yorumları Gör'),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const SocialFeedScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewspaperDialog extends StatelessWidget {
  final String headline;
  const NewspaperDialog({super.key, required this.headline});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Transform.rotate(
        angle: -0.022, // masaya atılmış gazete hissi
        child: Container(
          constraints: const BoxConstraints(maxWidth: 370),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0E1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFF3A3A3A), width: 2),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54, blurRadius: 18, offset: Offset(0, 8))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Manşet görseli (masthead + sahne fotoğrafı PNG içinde)
              _NewspaperImage(),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
                child: Column(
                  children: [
                    Text(headline.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.baloo2(
                            fontWeight: FontWeight.w800,
                            fontSize: 21,
                            height: 1.12,
                            color: const Color(0xFF1A1A1A))),
                    const SizedBox(height: 4),
                    Container(
                        height: 2, width: 90, color: const Color(0xFF3A3A3A)),
                    const SizedBox(height: 6),
                    const Text(
                        'Magazin dünyası çalkalanıyor. Detaylar 3. sayfada...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 12,
                            color: Color(0xFF444444))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kapat',
                      style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Gazete PNG'si varsa gösterir; yoksa sessizce boş döner.
class _NewspaperImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      child: Image.asset(
        'assets/news/newspaper.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}

// ── Akış kartı ──
class _FeedCard extends StatelessWidget {
  final Event ev;
  const _FeedCard({required this.ev});

  @override
  Widget build(BuildContext context) {
    final meta = kEventCategoryMeta[ev.category];
    final isNews = ev.category == 'news';
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      color: isNews ? AppColors.secondary.withAlpha(28) : AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(meta?.emoji ?? '•', style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(ev.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                Text(
                    ev.category == 'award'
                        ? monthYearLabel(ev.monthOccurred)
                        : '${ev.monthOccurred}. ay',
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            if (ev.description != null && ev.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(ev.description!,
                  style: TextStyle(fontSize: 12, color: AppColors.textPrimary)),
            ],
            if (ev.resolutionChoice != null) ...[
              const SizedBox(height: 6),
              Text('Kararın: ${ev.resolutionChoice}',
                  style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.indigo)),
            ],
            if (ev.resolutionOutcome != null &&
                ev.resolutionOutcome!.isNotEmpty &&
                ev.category != 'news') ...[
              const SizedBox(height: 4),
              Text(ev.resolutionOutcome!,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  ÜYELER & İLİŞKİLER EKRANI (ayrı sayfa)
// ════════════════════════════════════════════════════════════════════════════
class MembersRelationshipScreen extends ConsumerWidget {
  const MembersRelationshipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relAsync = ref.watch(memberRelationsProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.headerGradient)),
        title: const Text('Üyeler & İlişkiler'),
      ),
      body: relAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (rel) {
          if (rel == null) {
            return Center(
                child: Text('Aktif grup yok.',
                    style: TextStyle(color: AppColors.onBgSoft)));
          }
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              // ── Şöhret sıralaması ──
              Text('Şöhret Sıralaması',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBgStrong)),
              const SizedBox(height: 6),
              ...rel.members.asMap().entries.map((entry) {
                final i = entry.key;
                final m = entry.value;
                final isCenter = m.idol.id == rel.centerIdolId;
                return Card(
                  color: isCenter ? AppColors.warning.withAlpha(28) : null,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: isCenter
                                  ? Colors.amber
                                  : Colors.deepPurple.shade100,
                              child: Text('${i + 1}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ),
                            const SizedBox(width: 8),
                            if (isCenter)
                              const Text('👑 ', style: TextStyle(fontSize: 15)),
                            Expanded(
                              child: Text(m.char.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ),
                            _fameBadge(m.fame),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(positionTr(m.position),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 8),
                        _miniStat('Moral', m.idol.mood, Colors.green),
                        _miniStat('Sadakat', m.idol.loyalty, Colors.blue),
                        _miniStat('Yorgunluk', m.idol.fatigue, Colors.orange),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),
              Text('Kimya Matrisi',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBgStrong)),
              const SizedBox(height: 4),
              const Text(
                  'Yeşil = dost, kırmızı = gergin. Köşegen kişinin kendisi.',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              _ChemistryMatrix(rel: rel),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _miniStat(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
              width: 70,
              child: Text(label, style: const TextStyle(fontSize: 12))),
          Expanded(
            child: GameBar(
                value: (value / 100).clamp(0.0, 1.0), color: color, height: 7),
          ),
          const SizedBox(width: 6),
          SizedBox(
              width: 26,
              child: Text('$value',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

// Kimya matrisi (NxN ızgara)
class _ChemistryMatrix extends StatelessWidget {
  final MemberRelations rel;
  const _ChemistryMatrix({required this.rel});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1);
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final members = rel.members;
    const cell = 44.0;

    Widget headerCell(String text) => Container(
          width: cell,
          height: cell,
          alignment: Alignment.center,
          child: Text(text,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          // Üst başlık satırı
          Row(
            children: [
              const SizedBox(width: cell, height: cell),
              ...members.map((m) => headerCell(_initials(m.char.name))),
            ],
          ),
          ...members.map((rowM) {
            return Row(
              children: [
                headerCell(_initials(rowM.char.name)),
                ...members.map((colM) {
                  if (rowM.idol.id == colM.idol.id) {
                    return Container(
                      width: cell,
                      height: cell,
                      margin: const EdgeInsets.all(1),
                      color: AppColors.surfaceHigh,
                      alignment: Alignment.center,
                      child:
                          const Text('—', style: TextStyle(color: Colors.grey)),
                    );
                  }
                  final score =
                      rel.chem[_chemKey(rowM.idol.id, colM.idol.id)] ?? 0;
                  final st = relationshipStyle(score);
                  return Container(
                    width: cell,
                    height: cell,
                    margin: const EdgeInsets.all(1),
                    color: st.color.withAlpha(55),
                    alignment: Alignment.center,
                    child: Text(
                      '${score >= 0 ? '+' : ''}$score',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: st.color),
                    ),
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  ANA MENÜ
// ════════════════════════════════════════════════════════════════════════════
class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final career = ref.watch(activeCareerProvider).value;
    final hasActive = career != null;

    return Scaffold(
      body: SafeArea(
        child: FadeInUp(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Spacer(flex: 3),
                // Dönen plak logosu
                const VinylDisc(size: 148),
                const SizedBox(height: 24),
                ShimmerSweep(
                  child: ShaderMask(
                    shaderCallback: (b) =>
                        AppColors.headerGradient.createShader(b),
                    child: Text('GIRLBAND',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(color: Colors.white, letterSpacing: 6)),
                  ),
                ),
                Text('MENAJER',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onBgAccent,
                        letterSpacing: 12)),
                const SizedBox(height: 10),
                Text('Grubunu kur, zirveye taşı.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.onBgSoft)),
                const Spacer(flex: 4),

                if (hasActive) ...[
                  GameButton(
                    label: 'Devam Et — ${career.agencyName}',
                    icon: Icons.play_arrow_rounded,
                    onTap: () => ref.read(inGameProvider.notifier).state = true,
                  ),
                  const SizedBox(height: 12),
                  _menuButton(
                    context,
                    icon: Icons.fiber_new,
                    label: 'Yeni Kariyer',
                    onTap: () => _newCareerFlow(context, ref, hasActive),
                  ),
                ] else
                  GameButton(
                    label: 'Yeni Kariyer Başlat',
                    icon: Icons.fiber_new,
                    onTap: () => _newCareerFlow(context, ref, hasActive),
                  ),
                const SizedBox(height: 12),
                _menuButton(
                  context,
                  icon: Icons.history_edu,
                  label: 'Kariyer Geçmişi',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const CareerHistoryScreen())),
                ),
                const SizedBox(height: 12),
                _menuButton(
                  context,
                  icon: Icons.military_tech,
                  label: 'Genel Başarımlar',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const GlobalAchievementsScreen())),
                ),
                const SizedBox(height: 12),
                _menuButton(
                  context,
                  icon: Icons.help_outline,
                  label: 'Nasıl Oynanır?',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const HowToPlayScreen())),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  icon: const Icon(Icons.settings, size: 18),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const SettingsScreen())),
                  label: const Text('Ayarlar'),
                ),
                const Spacer(flex: 1),
                Text('v1.1  •  🎤  •  iyi eğlenceler!',
                    style: TextStyle(fontSize: 11, color: AppColors.onBgSoft)),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Menü ikincil butonu: beyaz kart + gradient ikon + basınca küçülür
  Widget _menuButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1.5),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withAlpha(28),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Text(label,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink)),
            const Spacer(),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Future<void> _newCareerFlow(
      BuildContext context, WidgetRef ref, bool hasActive) async {
    final ctrl = TextEditingController(text: 'Yıldız Ajans');
    int budget = 20000; // varsayılan: orta
    const diffs = [
      ('Kolay', 50000, AppColors.success),
      ('Orta', 20000, AppColors.accentBlue),
      ('Zor', 10000, AppColors.danger),
    ];
    final ok = await showDialog<bool>(
      context: context,
      builder: (dctx) => StatefulBuilder(
        builder: (dctx, setLocal) => AlertDialog(
          title: const Text('Yeni Kariyer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ajansının adını gir:'),
                const SizedBox(height: 8),
                TextField(
                  controller: ctrl,
                  autofocus: true,
                  maxLength: 24,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Zorluk (başlangıç bütçesi):',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ...diffs.map((d) {
                  final sel = budget == d.$2;
                  return GestureDetector(
                    onTap: () => setLocal(() => budget = d.$2),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: sel ? d.$3.withAlpha(28) : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: sel ? d.$3 : AppColors.border,
                            width: sel ? 2 : 1),
                      ),
                      child: Row(
                        children: [
                          Icon(sel ? Icons.check_circle : Icons.circle_outlined,
                              color: sel ? d.$3 : AppColors.textSecondary,
                              size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(d.$1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800)),
                          ),
                          Text('${d.$2 ~/ 1000}.000₺',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, color: d.$3)),
                        ],
                      ),
                    ),
                  );
                }),
                if (hasActive)
                  const Text(
                      '⚠️ Mevcut aktif kariyerin sona erip geçmişe kaydedilecek.',
                      style: TextStyle(fontSize: 12, color: Colors.orange)),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dctx, false),
                child: const Text('Vazgeç')),
            ElevatedButton(
              onPressed: () => Navigator.pop(dctx, true),
              child: const Text('Başla'),
            ),
          ],
        ),
      ),
    );
    if (ok != true) return;
    final difficulty =
        budget >= 50000 ? 'easy' : (budget <= 10000 ? 'hard' : 'medium');
    await ref.read(activeCareerProvider.notifier).startNewGame(
        agencyName: ctrl.text, budget: budget, difficulty: difficulty);
    // Tüm oyun durumunu tazele
    ref.invalidate(traineeCampProvider);
    ref.invalidate(myInventoryProvider);
    ref.invalidate(walletProvider);
    ref.invalidate(coachPoolProvider);
    ref.invalidate(groupDashboardProvider);
    ref.invalidate(hasActiveGroupProvider);
    ref.invalidate(careerHistoryProvider);
    ref.read(inGameProvider.notifier).state = true;
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  AYARLAR
// ════════════════════════════════════════════════════════════════════════════
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sound = ref.watch(soundEnabledProvider);
    final dark = ref.watch(darkThemeProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.headerGradient)),
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: dark,
                  onChanged: (v) async {
                    AppColors.dark = v;
                    ref.read(darkThemeProvider.notifier).state = v;
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('darkTheme', v);
                  },
                  secondary: Icon(dark ? Icons.dark_mode : Icons.light_mode,
                      color: AppColors.primary),
                  title: const Text('Koyu Tema'),
                  subtitle: const Text('Gece sahnesi görünümü'),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: sound,
                  onChanged: (v) =>
                      ref.read(soundEnabledProvider.notifier).state = v,
                  secondary:
                      const Icon(Icons.volume_up, color: AppColors.primary),
                  title: const Text('Efekt Sesleri'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Tüm Veriyi Sıfırla',
                  style: TextStyle(color: Colors.red)),
              subtitle: const Text(
                  'Tüm kariyerler, idoller ve geçmiş silinir. Geri alınamaz.'),
              onTap: () => _confirmReset(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: const Text('Emin misin?'),
        content: const Text(
            'Bütün oyun verisi kalıcı olarak silinecek. Bu işlem geri alınamaz.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx, false),
              child: const Text('Vazgeç')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dctx, true),
            child: const Text('Sıfırla', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final db = ref.read(databaseProvider);
    await db.resetAllData();
    ref.read(inGameProvider.notifier).state = false;
    ref.invalidate(activeCareerProvider);
    ref.invalidate(careerHistoryProvider);
    ref.invalidate(traineeCampProvider);
    ref.invalidate(myInventoryProvider);
    ref.invalidate(walletProvider);
    if (context.mounted) {
      Navigator.of(context).pop(); // ayarlardan çık
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Tüm veri sıfırlandı.')));
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  KARİYER GEÇMİŞİ
// ════════════════════════════════════════════════════════════════════════════
class CareerHistoryScreen extends ConsumerWidget {
  const CareerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final histAsync = ref.watch(careerHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.headerGradient)),
        title: const Text('Kariyer Geçmişi'),
      ),
      body: histAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                    'Henüz tamamlanmış kariyer yok.\nBir kariyer bitince burada görünür.',
                    textAlign: TextAlign.center),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final h = list[i];
              final awards = h.awardsWon;
              return Card(
                child: ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => CareerDetailScreen(history: h))),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade100,
                    child: Text('#${h.careerNumber}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(h.groupName ?? 'Grupsuz kariyer',
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      if (awards > 0) ...[
                        const SizedBox(width: 6),
                        Text('🏆×$awards',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.amber)),
                      ],
                    ],
                  ),
                  subtitle: Text('${h.agencyName ?? "—"}\n'
                      'Skor: ${h.finalScore ?? 0}  •  Erişim: ${fmtCount(h.finalPopularity ?? 0)}  •  '
                      '${h.monthsPlayed ?? 0} ay'
                      '${h.peakChartPosition != null ? "  •  Zirve #${h.peakChartPosition}" : ""}'),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Kariyer detayı: o kariyere ait grup/üye/şarkı istatistikleri
final careerDetailProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, int>((ref, careerId) async {
  final db = ref.watch(databaseProvider);
  final group = await (db.select(db.groups)
        ..where((t) => t.careerId.equals(careerId))
        ..orderBy([(t) => drift.OrderingTerm.desc(t.id)])
        ..limit(1))
      .getSingleOrNull();
  if (group == null) {
    return {'members': <Map<String, dynamic>>[], 'songs': 0};
  }
  // Üyeler (gruba katılmış herkes — ayrılanlar dahil), katılım sırasına göre
  final memberRows = await (db.select(db.groupMembers).join([
    drift.innerJoin(
        db.playerIdols, db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
    drift.innerJoin(db.generatedCharacters,
        db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
  ])
        ..where(db.groupMembers.groupId.equals(group.id)))
      .get();
  final members = memberRows
      .map((r) => {
            'name': r.readTable(db.generatedCharacters).name,
            'image': r.readTable(db.generatedCharacters).imagePath,
            'rarity': r.readTable(db.generatedCharacters).rarity,
            'left': r.readTable(db.groupMembers).leaveMonth != null,
          })
      .toList();

  final songs = await (db.select(db.songs)
        ..where((t) => t.groupId.equals(group.id)))
      .get();
  final hitSongs = songs.where((s) => (s.peakChartPosition ?? 99) <= 10).length;
  final number1 = songs.where((s) => (s.peakChartPosition ?? 99) <= 1).length;
  final albums = await (db.select(db.albums)
        ..where((t) => t.groupId.equals(group.id)))
      .get();
  final achievements = await AchievementManager(db).getForCareer(careerId);

  return {
    'group': group,
    'members': members,
    'totalSongs': songs.length,
    'hitSongs': hitSongs,
    'number1': number1,
    'albums': albums.length,
    'achievements': achievements.map((a) => a.title).toList(),
  };
});

// Kariyer detay ekranı (geçmişten bir karta tıklayınca)
class CareerDetailScreen extends ConsumerWidget {
  final CareerHistory history;
  const CareerDetailScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(careerDetailProvider(history.careerId));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.headerGradient)),
        title: Text(history.groupName ?? 'Kariyer #${history.careerNumber}'),
      ),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (d) {
          final members = (d['members'] as List).cast<Map<String, dynamic>>();
          final achievements =
              (d['achievements'] as List?)?.cast<String>() ?? [];
          return ListView(
            padding: const EdgeInsets.all(14),
            children: [
              // Özet kartı
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.workspace_premium,
                              color: Colors.amber, size: 30),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(history.groupName ?? 'Grupsuz',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('Ajans: ${history.agencyName ?? "—"}',
                          style: TextStyle(color: AppColors.textSecondary)),
                      const Divider(height: 18),
                      Wrap(
                        spacing: 16,
                        runSpacing: 10,
                        children: [
                          _stat('Final Skor', '${history.finalScore ?? 0}'),
                          _stat('🏆 Ödül', '${history.awardsWon}'),
                          _stat('Süre', '${history.monthsPlayed ?? 0} ay'),
                          _stat(
                              'Erişim', fmtCount(history.finalPopularity ?? 0)),
                          if (history.peakChartPosition != null)
                            _stat('Zirve', '#${history.peakChartPosition}'),
                          _stat('Toplam Şarkı', '${d['totalSongs'] ?? 0}'),
                          _stat('Hit (Top 10)', '${d['hitSongs'] ?? 0}'),
                          _stat('#1 Şarkı', '${d['number1'] ?? 0}'),
                          _stat('Albüm', '${d['albums'] ?? 0}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text('Grup Üyeleri (${members.length})',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...members.map((m) => Card(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: ListTile(
                      leading: CharacterAvatar(
                        imagePath: m['image'] as String?,
                        initial: m['name'] as String,
                        size: 42,
                        tint: AppTheme.rarityColor(m['rarity'] as String)
                            .withAlpha(38),
                      ),
                      title: Text(m['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(m['rarity'] as String),
                      trailing: (m['left'] as bool)
                          ? const Text('ayrıldı',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.danger))
                          : const Text('kadroda',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.success)),
                    ),
                  )),
              if (achievements.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text('Başarımlar (${achievements.length})',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: achievements
                      .map((t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(28),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Text(t,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary)),
                          ))
                      .toList(),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.primary)),
        Text(label,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  KADRO YÖNETİMİ (grup kurulduktan sonra üye ekle / yedeğe al)
// ════════════════════════════════════════════════════════════════════════════
class SquadManagementScreen extends ConsumerWidget {
  const SquadManagementScreen({super.key});

  static const int maxGroupSize = 7;
  static const int minGroupSize = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(groupDashboardProvider);
    final benchAsync = ref.watch(benchIdolsProvider);
    final career = ref.watch(activeCareerProvider).value;
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.headerGradient)),
        title: const Text('Kadro Yönetimi'),
      ),
      body: dashAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (dash) {
          if (dash == null || career == null) {
            return Center(
                child: Text('Aktif grup yok.',
                    style: TextStyle(color: AppColors.onBgSoft)));
          }
          final members = dash.members;
          final bench = benchAsync.value ?? [];

          Future<void> refresh() async {
            ref.invalidate(groupDashboardProvider);
            ref.invalidate(benchIdolsProvider);
            ref.invalidate(memberRelationsProvider);
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Text('Aktif Üyeler (${members.length}/$maxGroupSize)',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBgStrong)),
              const SizedBox(height: 4),
              const Text(
                  'En az 3 üye olmalı. Yedeğe alınan idol şirkette kalır.',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              ...members.map((m) {
                final overall = ((m.char.vocalSkill + m.idol.vocalBonus) +
                        (m.char.danceSkill + m.idol.danceBonus) +
                        (m.char.rapSkill + m.idol.rapBonus)) ~/
                    3;
                final fame = m.char.startingFame + m.idol.popularityBonus;
                final canBench = members.length > minGroupSize;
                return Card(
                  child: ListTile(
                    leading: CharacterAvatar(
                        imagePath: m.char.imagePath,
                        initial: m.char.name,
                        size: 46),
                    title: Row(
                      children: [
                        Flexible(
                          child: Text(m.char.name,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 6),
                        _fameBadge(fame),
                      ],
                    ),
                    subtitle: Text('${positionTr(m.position)} • $overall OVR'),
                    trailing: OutlinedButton(
                      onPressed: !canBench
                          ? null
                          : () async {
                              final ok = await GroupManager(db).benchMember(
                                  dash.group.id,
                                  m.idol.id,
                                  career.currentMonth);
                              await refresh();
                              if (context.mounted && !ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('En az 3 üye kalmalı.')));
                              }
                            },
                      child: const Text('Yedeğe Al'),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
              Text('Yedek İdoller (${bench.length})',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBgStrong)),
              const SizedBox(height: 4),
              const Text('Şirkette olup grupta olmayan idoller.',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              if (bench.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Yedek idol yok.'),
                )
              else
                ...bench.map((b) {
                  final idol = b['idol'] as PlayerIdol;
                  final c = b['character'] as GeneratedCharacter;
                  final overall = ((c.vocalSkill + idol.vocalBonus) +
                          (c.danceSkill + idol.danceBonus) +
                          (c.rapSkill + idol.rapBonus)) ~/
                      3;
                  final fame = c.startingFame + idol.popularityBonus;
                  final canAdd = members.length < maxGroupSize;
                  return Card(
                    child: ListTile(
                      leading: CharacterAvatar(
                          imagePath: c.imagePath, initial: c.name, size: 46),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(c.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 6),
                          _fameBadge(fame),
                        ],
                      ),
                      subtitle: Text(
                          'Şirket idolü • $overall OVR • ${c.rarity.toUpperCase()}'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                canAdd ? Colors.indigo : Colors.grey,
                            foregroundColor: Colors.white),
                        onPressed: !canAdd
                            ? null
                            : () async {
                                await GroupManager(db).addMemberToGroup(
                                    dash.group.id,
                                    idol.id,
                                    career.currentMonth);
                                await refresh();
                              },
                        child: const Text('Gruba Kat'),
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
