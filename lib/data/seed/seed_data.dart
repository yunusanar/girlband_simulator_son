// Öğrenci No: 202313171033
import 'package:drift/drift.dart';
import '../database/app_database.dart'; 

// İsim havuzu (DB'deki karakter isimleri buradan rastgele seçilir).
List<NamePoolCompanion> get startingNames => const [
  'Elif', 'Zeynep', 'Defne', 'Asya', 'Aylin', 'Cemre', 'Duru', 'Ece',
  'Nehir', 'Mira', 'Lara', 'Ada', 'Eylül', 'Naz', 'İpek', 'Melis',
  'Selin', 'Derin', 'Yağmur', 'Buse', 'Su', 'Beren', 'Ela', 'Azra',
  'Bade', 'İmge', 'Pera', 'Rüya', 'Sena', 'Nazlı', 'Umay', 'Çağla',
  'Damla', 'Esma', 'Gökçe', 'Hira', 'İklim', 'Kumsal', 'Leyla', 'Müge',
  'Nisa', 'Öykü', 'Pınar', 'Reyhan', 'Şevval', 'Tuana', 'Yade', 'Ecrin',
  'Alya', 'Beliz', 'Ceylin', 'Dila', 'Efnan', 'Feray', 'Gizem', 'Helin',
  'Irmak', 'Jale', 'İlayda', 'Lina', 'Masal', 'Nil', 'Cansu', 'Peri',
].map((n) => NamePoolCompanion(name: Value(n))).toList();

List<TagPoolCompanion> get startingTags => [
  const TagPoolCompanion(category: Value('voice_type'), value: Value('soprano')),
  const TagPoolCompanion(category: Value('voice_type'), value: Value('alto')),
  const TagPoolCompanion(category: Value('voice_type'), value: Value('rap_vocal')),
  const TagPoolCompanion(category: Value('special_trait'), value: Value('hayran_favorisi')),
  const TagPoolCompanion(category: Value('special_trait'), value: Value('skandal_yatkin')),
  const TagPoolCompanion(category: Value('special_trait'), value: Value('viral_potansiyel')),
];

// Potansiyel dağılımı yukarı çekildi (daha az F'li aday).
List<RarityTiersCompanion> get startingRarities => [
  const RarityTiersCompanion(rarityName: Value('common'), statMin: Value(42), statMax: Value(62), poolWeight: Value(45.0)),
  const RarityTiersCompanion(rarityName: Value('rare'), statMin: Value(58), statMax: Value(74), poolWeight: Value(35.0)),
  const RarityTiersCompanion(rarityName: Value('epic'), statMin: Value(72), statMax: Value(87), poolWeight: Value(16.0)),
  const RarityTiersCompanion(rarityName: Value('legendary'), statMin: Value(86), statMax: Value(99), poolWeight: Value(4.0)),
];

// Arketipler artık birer Big5 profili üretir (character_generator'da haritalanır).
List<PersonalityTraitsCompanion> get startingPersonalities => [
  const PersonalityTraitsCompanion(traitName: Value('Lider Ruhlu'), chemistryModifier: Value(5), moodDecayRate: Value(0.8), scandalChanceModifier: Value(0.7)),
  const PersonalityTraitsCompanion(traitName: Value('Asi'), chemistryModifier: Value(-3), moodDecayRate: Value(1.3), scandalChanceModifier: Value(1.8)),
  const PersonalityTraitsCompanion(traitName: Value('İçine Dönük'), chemistryModifier: Value(2), moodDecayRate: Value(1.1), scandalChanceModifier: Value(0.5)),
  const PersonalityTraitsCompanion(traitName: Value('Diva'), chemistryModifier: Value(-5), moodDecayRate: Value(1.0), scandalChanceModifier: Value(1.4)),
  const PersonalityTraitsCompanion(traitName: Value('Sıcakkanlı'), chemistryModifier: Value(7), moodDecayRate: Value(0.9), scandalChanceModifier: Value(0.6)),
  const PersonalityTraitsCompanion(traitName: Value('Mükemmeliyetçi'), chemistryModifier: Value(1), moodDecayRate: Value(1.0), scandalChanceModifier: Value(0.8)),
  const PersonalityTraitsCompanion(traitName: Value('Serbest Ruhlu'), chemistryModifier: Value(2), moodDecayRate: Value(1.1), scandalChanceModifier: Value(1.2)),
];

List<RivalsCompanion> get startingRivals => [
  const RivalsCompanion(rivalName: Value('Manifesto'), memberCount: Value(4)),
];

List<RivalMilestonesCompanion> get startingMilestones => [
  // Manifesto yüksek başlar ve SÜREKLI büyür → yakalaması zor hareketli hedef
  const RivalMilestonesCompanion(rivalId: Value(1), month: Value(1),  popularityValue: Value(2300000)),
  const RivalMilestonesCompanion(rivalId: Value(1), month: Value(18), popularityValue: Value(3500000)),
  const RivalMilestonesCompanion(rivalId: Value(1), month: Value(36), popularityValue: Value(5000000)),
];

List<CardPacksCompanion> get startingPacks => [
  const CardPacksCompanion(packName: Value('Başlangıç Paketi'), packType: Value('basic'), unlockMonth: Value(1), cost: Value(0)),
];