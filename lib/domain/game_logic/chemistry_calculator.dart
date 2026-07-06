// Öğrenci No: 202313171033
import 'dart:math';
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';

/// Şirket içi ikili kimya. Her ay, tüm aktif idol çiftleri arasındaki
/// ilişki skoru yavaşça kayar. İtici güç: kişilik uyumu + ruh hali + gürültü.
/// Skor -100..+100. Çift her zaman (küçükId, büyükId) sırasıyla saklanır.
class ChemistryCalculator {
  final AppDatabase db;
  final Random _rng = Random();

  ChemistryCalculator(this.db);

  Future<void> updateMonthlyChemistry(int careerId, int month) async {
    // 1) Aktif idoller + kişilikleri + ruh halleri
    final rows = await (db.select(db.playerIdols).join([
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId))
    ])
          ..where(db.playerIdols.careerId.equals(careerId) &
              db.playerIdols.status.equals('active')))
        .get();

    final idols = rows.map((r) {
      final idol = r.readTable(db.playerIdols);
      final char = r.readTable(db.generatedCharacters);
      return _IdolInfo(idol.id, char.personalityId, idol.mood,
          char.agreeableness, char.neuroticism);
    }).toList();

    if (idols.length < 2) return;

    // 2) Kişilik modifier haritası
    final persList = await db.select(db.personalityTraits).get();
    final Map<int, int> persMod = {
      for (final p in persList) p.id: p.chemistryModifier
    };

    // 3) Bu idoller arasındaki mevcut ilişkileri çek
    final ids = idols.map((e) => e.id).toList();
    final existingRels = await (db.select(db.chemistryRelations)
          ..where((t) => t.idolAId.isIn(ids) & t.idolBId.isIn(ids)))
        .get();
    final Map<String, ChemistryRelation> relMap = {
      for (final r in existingRels) _key(r.idolAId, r.idolBId): r
    };

    // 4) Tüm çiftleri gez, skoru güncelle/oluştur
    final List<ChemistryRelationsCompanion> toInsert = [];
    final List<(int id, ChemistryRelationsCompanion data)> toUpdate = [];

    for (int i = 0; i < idols.length; i++) {
      for (int j = i + 1; j < idols.length; j++) {
        final a = idols[i];
        final b = idols[j];
        final aId = min(a.id, b.id);
        final bId = max(a.id, b.id);
        final existing = relMap[_key(aId, bId)];
        final current = existing?.chemistryScore ?? 0;

        final delta = _delta(a, b, persMod);
        final newScore = (current + delta).clamp(-100, 100);
        final type = _typeFromScore(newScore);

        if (existing == null) {
          toInsert.add(ChemistryRelationsCompanion.insert(
            idolAId: aId,
            idolBId: bId,
            chemistryScore: Value(newScore),
            relationshipType: Value(type),
            lastUpdatedMonth: month,
          ));
        } else {
          toUpdate.add((
            existing.id,
            ChemistryRelationsCompanion(
              chemistryScore: Value(newScore),
              relationshipType: Value(type),
              lastUpdatedMonth: Value(month),
            )
          ));
        }
      }
    }

    await db.batch((batch) {
      if (toInsert.isNotEmpty) batch.insertAll(db.chemistryRelations, toInsert);
      for (final u in toUpdate) {
        batch.update(db.chemistryRelations, u.$2,
            where: (t) => t.id.equals(u.$1));
      }
    });
  }

  int _delta(_IdolInfo a, _IdolInfo b, Map<int, int> persMod) {
    final modA = persMod[a.personalityId] ?? 0;
    final modB = persMod[b.personalityId] ?? 0;

    // Kişilik eğilimi: ~ -2.5..+2.5 / ay (yavaş kayış)
    final double tendency = (modA + modB) / 4.0;

    // BIG5 — Uyumluluk (Agreeableness): yüksek uyumlu çiftler hızlı bağ kurar.
    // İki uyumun ortalaması 50'nin üstündeyse +, altındaysa -.
    final double agreeAvg = (a.agreeableness + b.agreeableness) / 2.0;
    final double agreeBonus = (agreeAvg - 50) / 25.0; // ~ -2..+2

    // BIG5 — Nevrotiklik: yüksek nevrotiklik ilişkiyi oynaklaştırır ve aşındırır.
    final double neuroAvg = (a.neuroticism + b.neuroticism) / 2.0;
    final double neuroPenalty = -(neuroAvg - 50) / 40.0; // ~ -1.25..+1.25

    // Ruh hali sinerjisi
    final moodAvg = (a.mood + b.mood) ~/ 2;
    final int moodBonus = moodAvg >= 70 ? 1 : (moodAvg <= 40 ? -1 : 0);

    // Nevrotiklik gürültüyü büyütür (oynaklık)
    final int noiseRange = 4 + (neuroAvg ~/ 25); // 4..7
    final int noise = _rng.nextInt(noiseRange + 1) - (noiseRange ~/ 2);

    return (tendency + agreeBonus + neuroPenalty).round() + moodBonus + noise;
  }

  String _typeFromScore(int s) {
    if (s >= 60) return 'best_friends';
    if (s >= 30) return 'friends';
    if (s > -30) return 'neutral';
    if (s > -60) return 'tension';
    return 'rivalry';
  }

  String _key(int a, int b) => '${min(a, b)}_${max(a, b)}';
}

class _IdolInfo {
  final int id;
  final int personalityId;
  final int mood;
  final int agreeableness;
  final int neuroticism;
  _IdolInfo(this.id, this.personalityId, this.mood, this.agreeableness,
      this.neuroticism);
}
