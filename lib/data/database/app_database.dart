// Öğrenci No: 202313171033
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/tables.dart';
import '../seed/seed_data.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  PersonalityTraits,
  NamePool,
  TagPool,
  RarityTiers,
  GeneratedCharacters,
  PlayerCareers,
  CurrencyWallets,
  CareerHistories,
  PlayerIdols,
  ChemistryRelations,
  Groups,
  GroupMembers,
  Songs,
  Albums,
  Achievements,
  GlobalAchievements,
  SocialPosts,
  Transactions,
  CardPacks,
  PackPoolItems,
  Coaches,
  Events,
  EventAffectedIdols,
  Rivals,
  RivalMilestones,
  MonthlyStats,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();

        await batch((batch) {
          batch.insertAll(namePool, startingNames);
          batch.insertAll(tagPool, startingTags);
          batch.insertAll(rarityTiers, startingRarities);
          batch.insertAll(personalityTraits, startingPersonalities);
          batch.insertAll(rivals, startingRivals);
          batch.insertAll(rivalMilestones, startingMilestones);
          batch.insertAll(cardPacks, startingPacks);
        });
      },
    );
  }

  /// Tüm oyun verisini siler (kariyerler, idoller, gruplar...). Tohum havuzları
  /// (isim/rarity/koç şablonu/rakip vb.) korunur. Ayarlardaki "sıfırla" kullanır.
  Future<void> resetAllData() async {
    await batch((b) {
      b.deleteWhere(eventAffectedIdols, (_) => const Constant(true));
      b.deleteWhere(events, (_) => const Constant(true));
      b.deleteWhere(achievements, (_) => const Constant(true));
      b.deleteWhere(socialPosts, (_) => const Constant(true));
      b.deleteWhere(transactions, (_) => const Constant(true));
      b.deleteWhere(songs, (_) => const Constant(true));
      b.deleteWhere(albums, (_) => const Constant(true));
      b.deleteWhere(groupMembers, (_) => const Constant(true));
      b.deleteWhere(chemistryRelations, (_) => const Constant(true));
      b.deleteWhere(monthlyStats, (_) => const Constant(true));
      b.deleteWhere(groups, (_) => const Constant(true));
      b.deleteWhere(packPoolItems, (_) => const Constant(true));
      b.deleteWhere(playerIdols, (_) => const Constant(true));
      b.deleteWhere(generatedCharacters, (_) => const Constant(true));
      b.deleteWhere(coaches, (_) => const Constant(true));
      b.deleteWhere(currencyWallets, (_) => const Constant(true));
      b.deleteWhere(careerHistories, (_) => const Constant(true));
      b.deleteWhere(playerCareers, (_) => const Constant(true));
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    // Şema değişti (cohortMonth eklendi) → temiz başlasın diye dosya adı v4.
    final file = File(p.join(dbFolder.path, 'girlband_sim_db_v21.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
