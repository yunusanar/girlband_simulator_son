// Öğrenci No: 202313171033
import 'package:drift/drift.dart';

// ============================================
// ŞABLON HAVUZLARI (procedural generation kaynağı)
// ============================================

class PersonalityTraits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get traitName => text().unique()();
  TextColumn get description => text().nullable()();
  IntColumn get chemistryModifier => integer().withDefault(const Constant(0))();
  RealColumn get moodDecayRate => real().withDefault(const Constant(1.0))();
  RealColumn get scandalChanceModifier => real().withDefault(const Constant(1.0))();
}

class NamePool extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class TagPool extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  TextColumn get value => text()();
}

class RarityTiers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get rarityName => text().unique()();
  IntColumn get statMin => integer()();
  IntColumn get statMax => integer()();
  RealColumn get poolWeight => real()();
}

// ============================================
// GENERATED CHARACTERS
// ============================================

class GeneratedCharacters extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId => integer().references(PlayerCareers, #id)();
  TextColumn get name => text()();
  TextColumn get imagePath => text().nullable()();

  // YENİ: Bu aday hangi ay kampa geldi? (aylık yenileme için)
  IntColumn get cohortMonth => integer().withDefault(const Constant(1))();

  // BAŞLANGIÇ YETENEKLERİ (düşük başlar, eğitimle artar — "current" temel)
  // Efektif güncel değer = bu temel + player_idols.<x>Bonus, tavan = <x>Potential
  IntColumn get vocalSkill => integer()();
  IntColumn get danceSkill => integer()();
  IntColumn get rapSkill => integer()();

  // POTANSİYEL TAVANLARI (gizli! rarity belirler, oyuncuya hiç gösterilmez)
  IntColumn get vocalPotential => integer().withDefault(const Constant(50))();
  IntColumn get dancePotential => integer().withDefault(const Constant(50))();
  IntColumn get rapPotential => integer().withDefault(const Constant(50))();

  // Yatkınlık: en yüksek potansiyele sahip disiplin ('vocal'/'dance'/'rap').
  // Bu disiplinin koçundan daha çok faydalanır.
  TextColumn get primaryDiscipline => text().withDefault(const Constant('vocal'))();

  // SEÇME NOTU: potansiyelin GÜRÜLTÜLÜ okuması (gizli ham puan).
  // Kampta harf notuna (S/A/B/C/D/F) çevrilip gösterilir; kesin sayı görünmez.
  IntColumn get auditionScore => integer().withDefault(const Constant(50))();

  // İnnate (eğitilmeyen) özellikler — rarity aralığından gelir
  IntColumn get visualScore => integer()();
  IntColumn get charisma => integer()();
  IntColumn get staminaBase => integer()();
  IntColumn get personalityId => integer().references(PersonalityTraits, #id)();
  TextColumn get rarity => text()();
  TextColumn get specialTrait => text().nullable()();
  TextColumn get voiceType => text().nullable()();

  // BIG FIVE (OCEAN) kişilik modeli — her biri 0..100
  // Açıklık: yaratıcılık/deneysellik | Özdisiplin: eğitim verimi
  // Dışadönüklük: sahne+PR | Uyumluluk: kimya | Nevrotiklik: skandal/ruh oynaklığı
  IntColumn get openness => integer().withDefault(const Constant(50))();
  IntColumn get conscientiousness => integer().withDefault(const Constant(50))();
  IntColumn get extraversion => integer().withDefault(const Constant(50))();
  IntColumn get agreeableness => integer().withDefault(const Constant(50))();
  IntColumn get neuroticism => integer().withDefault(const Constant(50))();

  // BİREYSEL ŞÖHRET (kampta GÖRÜNÜR — statlar gizli olsa da takipçi bilinir)
  // Yeteneksiz ama ünlü olabilir. Gelir/takipçiyi artırır, almazsan aleyhte konuşur.
  IntColumn get startingFame => integer().withDefault(const Constant(0))();
  // Kamp pazarı durumu: 'available' | 'left' (başka ajansa gitti)
  TextColumn get recruitStatus =>
      text().withDefault(const Constant('available'))();

  // SİS PERDESİ (Fog of War) VE TERS KÖŞE SİSTEMİ
  TextColumn get claimedRole => text().withDefault(const Constant('Bilinmiyor'))();
  TextColumn get bioSnippet => text().nullable()();
  BoolColumn get isVocalRevealed => boolean().withDefault(const Constant(false))();
  BoolColumn get isDanceRevealed => boolean().withDefault(const Constant(false))();
  BoolColumn get isRapRevealed => boolean().withDefault(const Constant(false))();
}

// ============================================
// KARİYER, CÜZDAN, KARİYER GEÇMİŞİ
// ============================================

class PlayerCareers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerNumber => integer()();
  TextColumn get agencyName => text().withDefault(const Constant('Yıldız Ajans'))();
  // Oyun aşaması: recruiting (50→20 seçim) | elimination (20→6 eleme) | debuted
  TextColumn get phase => text().withDefault(const Constant('recruiting'))();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get currentWeek => integer().withDefault(const Constant(1))(); // 1..4
  IntColumn get currentMonth => integer().withDefault(const Constant(1))();
  IntColumn get currentYear => integer().withDefault(const Constant(1))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  IntColumn get finalScore => integer().nullable()();
  IntColumn get awardsWon => integer().withDefault(const Constant(0))();
  TextColumn get legacyBonusApplied => text().nullable()();
  // Zorluk modu: easy | medium | hard (genel başarımlar için)
  TextColumn get difficulty => text().withDefault(const Constant('medium'))();
}

class CurrencyWallets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId => integer().references(PlayerCareers, #id)();
  IntColumn get fanPoints => integer().withDefault(const Constant(0))();
  IntColumn get premiumGems => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [{careerId}];
}

class CareerHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId => integer().references(PlayerCareers, #id)();
  IntColumn get careerNumber => integer()();
  TextColumn get groupName => text().nullable()();
  IntColumn get finalPopularity => integer().nullable()();
  IntColumn get monthsPlayed => integer().nullable()();
  IntColumn get peakChartPosition => integer().nullable()();
  IntColumn get finalScore => integer().nullable()();
  IntColumn get awardsWon => integer().withDefault(const Constant(0))();
  TextColumn get agencyName => text().nullable()();
  TextColumn get unlockedLegacyBonus => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [{careerId}];
}

// ============================================
// OYUNCU IDOL'LERİ & KİMYA
// ============================================

@TableIndex(name: 'idx_player_idols_career', columns: {#careerId})
class PlayerIdols extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId => integer().references(PlayerCareers, #id)();
  IntColumn get characterId => integer().references(GeneratedCharacters, #id)();
  IntColumn get recruitedMonth => integer()();
  IntColumn get currentLevel => integer().withDefault(const Constant(1))();
  IntColumn get vocalBonus => integer().withDefault(const Constant(0))();
  IntColumn get danceBonus => integer().withDefault(const Constant(0))();
  IntColumn get rapBonus => integer().withDefault(const Constant(0))();
  IntColumn get visualBonus => integer().withDefault(const Constant(0))();
  IntColumn get charismaBonus => integer().withDefault(const Constant(0))();
  IntColumn get fatigue => integer().withDefault(const Constant(0))();
  IntColumn get mood => integer().withDefault(const Constant(70))();
  IntColumn get loyalty => integer().withDefault(const Constant(70))();
  // Oyun içi büyüyen bireysel şöhret. Etkili şöhret = char.startingFame + bu.
  IntColumn get popularityBonus => integer().withDefault(const Constant(0))();
  // Rakip transfer baskısıyla yükseltilen maaş zammı (aylık maaşa eklenir)
  IntColumn get salaryBonus => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('active'))();
}

@TableIndex(name: 'idx_chemistry_idols', columns: {#idolAId, #idolBId})
class ChemistryRelations extends Table {
  IntColumn get id => integer().autoIncrement()();

  @ReferenceName('chemistryAsIdolA')
  IntColumn get idolAId => integer().references(PlayerIdols, #id)();

  @ReferenceName('chemistryAsIdolB')
  IntColumn get idolBId => integer().references(PlayerIdols, #id)();

  IntColumn get chemistryScore => integer().withDefault(const Constant(0))();
  TextColumn get relationshipType => text().withDefault(const Constant('neutral'))();
  IntColumn get lastUpdatedMonth => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [{idolAId, idolBId}];
}

// ============================================
// GRUPLAR, ÜYELİKLER, ŞARKILAR
// ============================================

class Groups extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId => integer().references(PlayerCareers, #id)();
  TextColumn get groupName => text()();
  IntColumn get formationMonth => integer()();
  IntColumn get totalPopularity => integer().withDefault(const Constant(0))();
  IntColumn get fanbaseSize => integer().withDefault(const Constant(0))();
  TextColumn get logoPath => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();

  // Sosyal medya & itibar (PR sistemi)
  IntColumn get reputation => integer().withDefault(const Constant(50))();   // 0..100 kamuoyu algısı
  IntColumn get socialFollowers => integer().withDefault(const Constant(5000))();
  IntColumn get scandalHeat => integer().withDefault(const Constant(0))();  // 0..100, her ay azalır

  // Konser / tur cooldown takibi (mutlak ay = (yıl-1)*12 + ay)
  IntColumn get lastConcertMonth => integer().nullable()();
  IntColumn get lastTourMonth => integer().nullable()();
  // Şarkı çıkarma kısıtı (mutlak ay)
  IntColumn get lastReleaseMonth => integer().nullable()();

  // Sponsorluk: aktif marka anlaşması (aylık gelir, kalan ay)
  TextColumn get sponsorName => text().nullable()();
  IntColumn get sponsorIncome => integer().withDefault(const Constant(0))();
  IntColumn get sponsorMonthsLeft => integer().withDefault(const Constant(0))();

  // Fandom: hayran kitlesi adı + sadakati (0..100)
  TextColumn get fandomName => text().nullable()();
  IntColumn get fandomLoyalty => integer().withDefault(const Constant(50))();

  // Bu haftaki takipçi değişimi (UI'da +/- gösterimi için)
  IntColumn get lastFollowerDelta => integer().withDefault(const Constant(0))();
  // Rodez ile husumet ısısı (her atışmada artar, skandala döner)
  IntColumn get rodezFeud => integer().withDefault(const Constant(0))();
  IntColumn get lastRodezMonth => integer().nullable()();
}

@TableIndex(name: 'idx_group_members_group', columns: {#groupId})
class GroupMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().references(Groups, #id)();
  IntColumn get idolId => integer().references(PlayerIdols, #id)();
  TextColumn get position => text()();
  IntColumn get joinMonth => integer()();
  IntColumn get leaveMonth => integer().nullable()();
}

class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().references(Groups, #id)();
  TextColumn get title => text()();
  TextColumn get genre => text().nullable()();
  IntColumn get releaseMonth => integer()();
  IntColumn get qualityScore => integer().nullable()();
  IntColumn get peakChartPosition => integer().nullable()();
  IntColumn get currentChartPosition => integer().nullable()();
  IntColumn get totalStreams => integer().withDefault(const Constant(0))();
  // Seçilen söz profilinin adı — chart drift hızını belirler
  TextColumn get lyricProfile => text().nullable()();
  // Bir albüme dahil edildiyse o albümün id'si (yoksa null = single)
  IntColumn get albumId => integer().nullable()();
}

class Albums extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer().references(Groups, #id)();
  TextColumn get title => text()();
  IntColumn get releaseMonth => integer()(); // mutlak ay
  IntColumn get trackCount => integer()();
  IntColumn get avgQuality => integer()();
  IntColumn get popBoost => integer().withDefault(const Constant(0))();
  TextColumn get concept => text().nullable()();
}

// Başarımlar (her kariyer için kilidi açılan rozetler)
class Achievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId => integer().references(PlayerCareers, #id)();
  TextColumn get achKey => text()();
  TextColumn get title => text()();
  IntColumn get unlockedAbsMonth => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {careerId, achKey}
      ];
}

// Genel (kariyerler-üstü) başarımlar — ana menüde gösterilir, kalıcıdır.
class GlobalAchievements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get achKey => text()();
  TextColumn get title => text()();
  IntColumn get unlockedCareerNumber =>
      integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {achKey}
      ];
}

// Mali işlem defteri (her para hareketi kaydedilir → ay sonu döküm)
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId => integer().references(PlayerCareers, #id)();
  IntColumn get absMonth => integer()(); // gruplama (mutlak ay)
  IntColumn get displayMonth => integer()(); // 1..12
  IntColumn get year => integer()();
  TextColumn get category => text()(); // song|album|concert|tour|pr|vacation|salary_idol|salary_coach|broadcast|stream|sponsor|event
  TextColumn get label => text()();
  IntColumn get amount => integer()(); // + gelir, - gider
}

// Sosyal medya gönderileri (her hafta birikir, silinmez)
class SocialPosts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId => integer().references(PlayerCareers, #id)();
  IntColumn get absWeek => integer()(); // sıralama anahtarı (büyük = yeni)
  TextColumn get postType => text()(); // fan | member | rival | hater
  TextColumn get displayName => text()();
  TextColumn get handle => text()();
  TextColumn get content => text()();
  TextColumn get avatarEmoji => text()();
}

// ============================================
// KOÇLAR (her kariyer için üretilen havuz)
// ============================================

@DataClassName('Coach')
@TableIndex(name: 'idx_coaches_career', columns: {#careerId})
class Coaches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId => integer().references(PlayerCareers, #id)();
  TextColumn get name => text()();
  TextColumn get discipline => text()(); // 'vocal' | 'dance' | 'rap'
  IntColumn get quality => integer()();      // eğitim gücü (örn. 3..7)
  IntColumn get monthlySalary => integer()(); // her ay bütçeden düşer
  BoolColumn get isHired => boolean().withDefault(const Constant(false))();
}

// ============================================
// KART PAKETLERİ & DROP ORANLARI
// ============================================

class CardPacks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get packName => text()();
  TextColumn get packType => text().withDefault(const Constant('basic'))();
  IntColumn get unlockMonth => integer().withDefault(const Constant(1))();
  IntColumn get cost => integer().withDefault(const Constant(0))();
  TextColumn get guaranteedRarity => text().nullable()();
}

class PackPoolItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get packId => integer().references(CardPacks, #id)();
  IntColumn get characterId => integer().references(GeneratedCharacters, #id)();
  RealColumn get dropRate => real()();
}

// ============================================
// RASTGELE OLAYLAR
// ============================================

@TableIndex(name: 'idx_events_career_month', columns: {#careerId, #monthOccurred})
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId => integer().references(PlayerCareers, #id)();
  IntColumn get groupId => integer().nullable().references(Groups, #id)();
  TextColumn get eventType => text()(); // template anahtarı (karar seçenekleri için)
  TextColumn get category => text().withDefault(const Constant('general'))();
  // intra_group | company | rival | pr | social | news
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get monthOccurred => integer()();
  IntColumn get impactValue => integer().withDefault(const Constant(0))();
  BoolColumn get requiresDecision => boolean().withDefault(const Constant(false))();
  BoolColumn get resolved => boolean().withDefault(const Constant(false))();
  TextColumn get resolutionChoice => text().nullable()();
  TextColumn get resolutionOutcome => text().nullable()(); // seçim sonrası gösterilen sonuç
}

class EventAffectedIdols extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId => integer().references(Events, #id)();
  IntColumn get idolId => integer().references(PlayerIdols, #id)();
  TextColumn get effectDetail => text().nullable()();
}

// ============================================
// RAKİP GRUPLAR & MILESTONE'LAR
// ============================================

class Rivals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get rivalName => text()();
  TextColumn get description => text().nullable()();
  IntColumn get memberCount => integer().withDefault(const Constant(5))();
  TextColumn get logoPath => text().nullable()();
}

@TableIndex(name: 'idx_rival_milestones_rival', columns: {#rivalId, #month})
class RivalMilestones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get rivalId => integer().references(Rivals, #id)();
  IntColumn get month => integer()();
  IntColumn get popularityValue => integer()();
  TextColumn get milestoneDescription => text().nullable()();
}

// ============================================
// AYLIK İSTATİSTİK SNAPSHOT
// ============================================

class MonthlyStats extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get careerId => integer().references(PlayerCareers, #id)();
  IntColumn get groupId => integer().references(Groups, #id)();
  IntColumn get month => integer()();
  IntColumn get popularityScore => integer()();
  IntColumn get fanbaseSize => integer()();
  IntColumn get avgChemistry => integer().nullable()();
  IntColumn get avgMood => integer().nullable()();
}
