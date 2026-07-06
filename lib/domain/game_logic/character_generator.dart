// Öğrenci No: 202313171033
import 'dart:math';
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';

/// assets/idols klasöründeki karakter görseli sayısı (1.png .. N.png).
const int idolImageCount = 45;

class CharacterGenerator {
  final AppDatabase db;
  final Random _random = Random();

  // Başlangıç yetenekleri rarity'den bağımsız ve DÜŞÜK olur.
  // Rarity'nin değeri artık POTANSİYEL tavanındadır.
  static const int startMin = 20;
  static const int startMax = 45;

  CharacterGenerator(this.db);

  // ----------------------------------------------------------------
  // Yeni kariyer: ilk stajyer kadrosu + koç havuzu
  // ----------------------------------------------------------------
  Future<void> generateRosterForCareer(int careerId) async {
    await _generateTrainees(careerId: careerId, count: 50, cohortMonth: 1);
    await _assignRosterToPacks(careerId);
    await generateCoachPool(careerId);
  }

  Future<void> addMonthlyTrainees({
    required int careerId,
    required int month,
    int count = 5,
  }) async {
    await _generateTrainees(careerId: careerId, count: count, cohortMonth: month);
  }

  // ----------------------------------------------------------------
  // KOÇ HAVUZU — her disiplinde birkaç koç, değişen kalite/maaş.
  // Bazıları "kelepir" (kalite yüksek maaş makul), bazıları pahalı.
  // ----------------------------------------------------------------
  Future<void> generateCoachPool(int careerId) async {
    const disciplines = ['vocal', 'dance', 'rap'];
    const coachNames = [
      'Selda Hoca', 'Murat Hoca', 'Ayça Hoca', 'Kemal Hoca',
      'Derya Hoca', 'Tarık Hoca', 'Nilay Hoca', 'Onur Hoca',
      'Pınar Hoca', 'Cenk Hoca', 'Burcu Hoca', 'Volkan Hoca',
    ];
    final namesShuffled = [...coachNames]..shuffle(_random);
    int nameIdx = 0;

    final List<CoachesCompanion> coaches = [];
    for (final disc in disciplines) {
      for (int i = 0; i < 3; i++) {
        final quality = 3 + _random.nextInt(5); // 3..7
        final salary = quality * 90 + _random.nextInt(160); // ~270..790
        final name = namesShuffled[nameIdx % namesShuffled.length];
        nameIdx++;

        coaches.add(CoachesCompanion.insert(
          careerId: careerId,
          name: name,
          discipline: disc,
          quality: quality,
          monthlySalary: salary,
        ));
      }
    }

    await db.batch((batch) => batch.insertAll(db.coaches, coaches));
  }

  // ----------------------------------------------------------------
  // ORTAK STAJYER ÜRETİM MOTORU
  // ----------------------------------------------------------------
  Future<void> _generateTrainees({
    required int careerId,
    required int count,
    required int cohortMonth,
  }) async {
    final names = await db.select(db.namePool).get();
    final voices = await (db.select(db.tagPool)
          ..where((t) => t.category.equals('voice_type')))
        .get();
    final traits = await (db.select(db.tagPool)
          ..where((t) => t.category.equals('special_trait')))
        .get();
    final rarities = await db.select(db.rarityTiers).get();
    final personalities = await db.select(db.personalityTraits).get();

    if (names.isEmpty || rarities.isEmpty || personalities.isEmpty) return;

    // Arketip id → ad haritası (Big5 profilini seçmek için)
    final Map<int, String> persName = {for (final p in personalities) p.id: p.traitName};

    final List<GeneratedCharactersCompanion> newRoster = [];

    for (int i = 0; i < count; i++) {
      final name = names[_random.nextInt(names.length)].name;
      final voice = voices.isNotEmpty
          ? voices[_random.nextInt(voices.length)].value
          : null;
      final trait = traits.isNotEmpty
          ? traits[_random.nextInt(traits.length)].value
          : null;
      final personalityId = personalities[_random.nextInt(personalities.length)].id;
      final big5 = _rollBig5(persName[personalityId] ?? '');

      // Rarity = potansiyel aralığı
      final tier = _pickWeightedRarity(rarities);
      final int potMin = tier.statMin;
      final int potMax = tier.statMax;

      // Potansiyel tavanları (gizli)
      final int vocalPot = _inRange(potMin, potMax);
      final int dancePot = _inRange(potMin, potMax);
      final int rapPot = _inRange(potMin, potMax);

      // Başlangıç yetenekleri DÜŞÜK ve potansiyeli aşmaz
      final int vocalStart = min(_inRange(startMin, startMax), vocalPot);
      final int danceStart = min(_inRange(startMin, startMax), dancePot);
      final int rapStart = min(_inRange(startMin, startMax), rapPot);

      // Yatkınlık = en yüksek potansiyelli disiplin
      final primary = _argmaxDiscipline(vocalPot, dancePot, rapPot);

      // İnnate özellikler
      final int visual = _inRange(potMin, potMax);
      final int charisma = _inRange(potMin, potMax);
      final int stamina = _inRange(potMin, potMax);

      // İnnate şöhret: görünüş+karizma + bağımsız gürültü; %15 "internet fenomeni"
      // (yetenekten bağımsız → yeteneksiz ama ünlü adaylar oluşur)
      int fame =
          (visual * 0.25 + charisma * 0.25 + _random.nextInt(36)).round();
      if (_random.nextDouble() < 0.15) fame = 65 + _random.nextInt(31);
      fame = fame.clamp(0, 100);

      // SEÇME NOTU: en yüksek potansiyel (asıl yetenek) ağırlıklı,
      // biraz görünüş katkısı, üstüne ±10 gürültü → kesin tell değil.
      final int topPot = [vocalPot, dancePot, rapPot].reduce(max);
      final double rawAud = topPot * 0.8 + visual * 0.2 + (_random.nextInt(21) - 10);
      final int auditionScore = rawAud.round().clamp(1, 100);

      // İddia: gerçek YATKINLIĞA göre, %30 ters köşe
      final claim = _buildClaim(primary);

      // Rastgele karakter görseli (assets/idols/1..45.png). Her üretimde farklı
      // atanır → her kariyerde/elde farklı resimler farklı karakterlere gelir.
      final imagePath = 'assets/idols/${_random.nextInt(idolImageCount) + 1}.png';

      newRoster.add(GeneratedCharactersCompanion.insert(
        careerId: careerId,
        name: name,
        imagePath: Value(imagePath),
        cohortMonth: Value(cohortMonth),
        rarity: tier.rarityName,
        voiceType: Value(voice),
        specialTrait: Value(trait),
        personalityId: personalityId,
        vocalSkill: vocalStart,
        danceSkill: danceStart,
        rapSkill: rapStart,
        vocalPotential: Value(vocalPot),
        dancePotential: Value(dancePot),
        rapPotential: Value(rapPot),
        primaryDiscipline: Value(primary),
        auditionScore: Value(auditionScore),
        visualScore: visual,
        charisma: charisma,
        staminaBase: stamina,
        claimedRole: Value(claim.role),
        bioSnippet: Value(claim.bio),
        openness: Value(big5.o),
        conscientiousness: Value(big5.c),
        extraversion: Value(big5.e),
        agreeableness: Value(big5.a),
        neuroticism: Value(big5.n),
        startingFame: Value(fame),
      ));
    }

    await db.batch((batch) {
      batch.insertAll(db.generatedCharacters, newRoster);
    });
  }

  // ----------------------------------------------------------------
  // YARDIMCILAR
  // ----------------------------------------------------------------

  // Arketip → Big5 temel profili [O, C, E, A, N], üstüne ±15 gürültü.
  ({int o, int c, int e, int a, int n}) _rollBig5(String archetype) {
    // [Openness, Conscientiousness, Extraversion, Agreeableness, Neuroticism]
    const profiles = <String, List<int>>{
      'Lider Ruhlu':    [60, 80, 75, 60, 30],
      'Asi':            [75, 35, 65, 35, 70],
      'İçine Dönük':    [55, 70, 25, 60, 55],
      'Diva':           [60, 55, 85, 30, 65],
      'Sıcakkanlı':     [55, 60, 70, 85, 35],
      'Mükemmeliyetçi': [50, 90, 45, 55, 50],
      'Serbest Ruhlu':  [85, 40, 60, 65, 45],
    };
    final base = profiles[archetype] ?? const [50, 50, 50, 50, 50];
    int jitter(int v) => (v + _random.nextInt(31) - 15).clamp(1, 99);
    return (
      o: jitter(base[0]),
      c: jitter(base[1]),
      e: jitter(base[2]),
      a: jitter(base[3]),
      n: jitter(base[4]),
    );
  }

  RarityTier _pickWeightedRarity(List<RarityTier> rarities) {
    final double total = rarities.fold(0.0, (s, r) => s + r.poolWeight);
    double roll = _random.nextDouble() * total;
    for (final r in rarities) {
      if (roll < r.poolWeight) return r;
      roll -= r.poolWeight;
    }
    return rarities.last;
  }

  int _inRange(int lo, int hi) {
    if (hi <= lo) return lo;
    return lo + _random.nextInt(hi - lo + 1);
  }

  String _argmaxDiscipline(int v, int d, int r) {
    if (v >= d && v >= r) return 'vocal';
    if (d >= v && d >= r) return 'dance';
    return 'rap';
  }

  _Claim _buildClaim(String primary) {
    const roleTr = {'vocal': 'Vokalist', 'dance': 'Dansçı', 'rap': 'Rapçi'};
    final bool isLying = _random.nextDouble() < 0.30;
    final trueRole = roleTr[primary]!;

    if (!isLying) {
      const bios = {
        'Vokalist': 'Küçüklüğümden beri şarkı söylerim, sesime çok güveniyorum.',
        'Dansçı': 'Müzik duyduğum an bedenim kendiliğinden hareket eder!',
        'Rapçi': 'Sözlerimle herkesi susturabilirim.',
      };
      return _Claim(trueRole, bios[trueRole]!);
    } else {
      final falseRoles = ['Vokalist', 'Dansçı', 'Rapçi']..remove(trueRole);
      final picked = falseRoles[_random.nextInt(falseRoles.length)];
      return _Claim(
        picked,
        'Aslında $picked olarak çok iyi olduğumu düşünüyorum ama sahnede göreceğiz...',
      );
    }
  }

  Future<void> _assignRosterToPacks(int careerId) async {
    final roster = await (db.select(db.generatedCharacters)
          ..where((t) => t.careerId.equals(careerId)))
        .get();
    if (roster.isEmpty) return;
    final items = roster
        .map((c) => PackPoolItemsCompanion.insert(
              packId: 1,
              characterId: c.id,
              dropRate: 100.0 / roster.length,
            ))
        .toList();
    await db.batch((batch) => batch.insertAll(db.packPoolItems, items));
  }
}

class _Claim {
  final String role;
  final String bio;
  _Claim(this.role, this.bio);
}
