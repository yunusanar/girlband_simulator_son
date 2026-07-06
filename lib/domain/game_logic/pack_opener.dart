// Öğrenci No: 202313171033
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';

final packOpenerProvider = Provider<PackOpener>((ref) {
  return PackOpener(ref.watch(databaseProvider));
});

class PackOpener {
  final AppDatabase db;
  final Random _random = Random();

  PackOpener(this.db);

  Future<PlayerIdol?> openBasicPack(PlayerCareer activeCareer) async {
    // 1. Aktif kariyere ait PackPoolItems'ı getir
    final poolItems = await db.select(db.packPoolItems).get(); // Gelişmiş versiyonda where packId = 1 eklenecek
    if (poolItems.isEmpty) return null;

    // 2. Rastgele kart seç (RNG)
    double roll = _random.nextDouble() * 100;
    double cumulative = 0.0;
    int? selectedCharId;

    for (final item in poolItems) {
      cumulative += item.dropRate;
      if (roll <= cumulative) {
        selectedCharId = item.characterId;
        break;
      }
    }
    selectedCharId ??= poolItems.last.characterId;

    // 3. Çekilen karakteri oyuncunun envanterine ekle
    return await db.into(db.playerIdols).insertReturning(
      PlayerIdolsCompanion.insert(
        careerId: activeCareer.id,
        characterId: selectedCharId,
        recruitedMonth: activeCareer.currentMonth,
      ),
    );
  }
}