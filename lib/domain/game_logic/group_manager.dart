// Öğrenci No: 202313171033
import 'dart:math';
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import 'global_achievement_manager.dart';

/// Grup kurma, grup istatistikleri (güç + kimya), rakip karşılaştırması
/// ve aylık popülarite trajektorisi.
class GroupManager {
  final AppDatabase db;
  GroupManager(this.db);

  Future<Group?> getActiveGroup(int careerId) {
    return (db.select(db.groups)
          ..where((t) => t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
  }

  /// PRESTİJ VERGİSİ: takipçi + popülarite arttıkça TÜM masraflar (koç/şarkı/
  /// konser/PR/tatil/albüm) bu çarpanla artar → geç oyun "para basmaz".
  /// Düşük prestij ~1.0 (erken oyun aynı), yüksek prestij 5.0'a kadar.
  static double costMultiplierFor(int followers, int popularity) {
    return (1.0 + followers / 450000.0 + popularity / 1800000.0)
        .clamp(1.0, 5.0);
  }

  /// Aktif gruba göre anlık masraf çarpanı (grup yoksa 1.0 = erken oyun).
  Future<double> currentCostMultiplier(int careerId) async {
    final g = await getActiveGroup(careerId);
    if (g == null) return 1.0;
    return costMultiplierFor(g.socialFollowers, g.totalPopularity);
  }

  // ---------------- GRUP KURMA ----------------
  // Pozisyonlar yeteneğe göre otomatik atanır (v1).
  Future<int> createGroupAuto({
    required int careerId,
    required String name,
    required int month,
    required List<int> idolIds,
  }) async {
    final rows = await (db.select(db.playerIdols).join([
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId))
    ])
          ..where(db.playerIdols.id.isIn(idolIds)))
        .get();

    final infos = rows.map((r) {
      final idol = r.readTable(db.playerIdols);
      final ch = r.readTable(db.generatedCharacters);
      return _PickInfo(
        id: idol.id,
        vocal: ch.vocalSkill + idol.vocalBonus,
        dance: ch.danceSkill + idol.danceBonus,
        rap: ch.rapSkill + idol.rapBonus,
        visual: ch.visualScore,
        charisma: ch.charisma,
      );
    }).toList();

    final Map<int, String> positions = {};
    void assignMax(String pos, int Function(_PickInfo) sel) {
      final remaining =
          infos.where((i) => !positions.containsKey(i.id)).toList();
      if (remaining.isEmpty) return;
      remaining.sort((a, b) => sel(b).compareTo(sel(a)));
      positions[remaining.first.id] = pos;
    }

    assignMax('leader', (i) => i.charisma);
    assignMax('main_vocal', (i) => i.vocal);
    assignMax('lead_dancer', (i) => i.dance);
    assignMax('rapper', (i) => i.rap);
    assignMax('visual', (i) => i.visual);
    for (final i in infos) {
      positions.putIfAbsent(i.id, () => 'member');
    }

    final groupId = await db.into(db.groups).insert(GroupsCompanion.insert(
          careerId: careerId,
          groupName: name,
          formationMonth: month,
          fandomName: Value('$name Fanları'),
        ));

    await db.batch((b) {
      for (final i in infos) {
        b.insert(
          db.groupMembers,
          GroupMembersCompanion.insert(
            groupId: groupId,
            idolId: i.id,
            position: positions[i.id]!,
            joinMonth: month,
          ),
        );
      }
    });

    // Grup kuruldu → debüt aşaması
    await (db.update(db.playerCareers)..where((t) => t.id.equals(careerId)))
        .write(const PlayerCareersCompanion(phase: Value('debuted')));

    return groupId;
  }

  /// Eleme: stajyeri tamamen kadrodan ÇIKARIR (gider, yedek olmaz). Yalnızca
  /// nihai 10→6 seçiminde seçilmeyen 4 kişi 'reserve' (yedek) olur.
  Future<void> eliminateIdol(int idolId) async {
    await (db.update(db.playerIdols)..where((t) => t.id.equals(idolId)))
        .write(const PlayerIdolsCompanion(status: Value('released')));
  }

  // ---------------- İSTATİSTİK YARDIMCILARI ----------------

  Future<List<({PlayerIdol idol, GeneratedCharacter char, String position})>>
      membersFull(int groupId) async {
    final rows = await (db.select(db.groupMembers).join([
      innerJoin(db.playerIdols,
          db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.groupMembers.groupId.equals(groupId) &
              db.groupMembers.leaveMonth.isNull()))
        .get();

    return rows.map((r) {
      final gm = r.readTable(db.groupMembers);
      return (
        idol: r.readTable(db.playerIdols),
        char: r.readTable(db.generatedCharacters),
        position: gm.position,
      );
    }).toList();
  }

  int memberOverall(PlayerIdol idol, GeneratedCharacter ch) {
    final v = ch.vocalSkill + idol.vocalBonus;
    final d = ch.danceSkill + idol.danceBonus;
    final r = ch.rapSkill + idol.rapBonus;
    final skill = (v + d + r) / 3.0;
    final star = (ch.visualScore + ch.charisma) / 2.0;
    return (skill * 0.7 + star * 0.3).round();
  }

  Future<int> avgChemistryForIds(List<int> ids) async {
    if (ids.length < 2) return 0;
    final rels = await (db.select(db.chemistryRelations)
          ..where((t) => t.idolAId.isIn(ids) & t.idolBId.isIn(ids)))
        .get();
    final pairCount = ids.length * (ids.length - 1) ~/ 2;
    final sum = rels.fold<int>(0, (s, r) => s + r.chemistryScore);
    return (sum / pairCount).round();
  }

  /// Rakip popülaritesi. [absMonth] = MUTLAK ay ((yıl-1)*12 + ay) — böylece
  /// rakip yıllar boyu BÜYÜR (hareketli hedef). Son milestone'dan sonra
  /// son segmentin eğimiyle doğrusal devam eder.
  Future<({String name, int popularity})> rivalStatusAt(int absMonth) async {
    final rival = await (db.select(db.rivals)..limit(1)).getSingleOrNull();
    if (rival == null) return (name: 'Rakip', popularity: 0);

    final stones = await (db.select(db.rivalMilestones)
          ..where((t) => t.rivalId.equals(rival.id))
          ..orderBy([(t) => OrderingTerm(expression: t.month)]))
        .get();
    if (stones.isEmpty) return (name: rival.rivalName, popularity: 0);

    if (absMonth <= stones.first.month) {
      return (name: rival.rivalName, popularity: stones.first.popularityValue);
    }
    // Son milestone'u geçtiyse → son segment eğimiyle extrapolasyon (büyümeye devam)
    if (absMonth >= stones.last.month) {
      if (stones.length >= 2) {
        final a = stones[stones.length - 2];
        final b = stones.last;
        final slope =
            (b.popularityValue - a.popularityValue) / (b.month - a.month);
        final pop =
            b.popularityValue + ((absMonth - b.month) * slope).round();
        return (name: rival.rivalName, popularity: pop);
      }
      return (name: rival.rivalName, popularity: stones.last.popularityValue);
    }
    for (int i = 0; i < stones.length - 1; i++) {
      final a = stones[i];
      final b = stones[i + 1];
      if (absMonth >= a.month && absMonth <= b.month) {
        final t = (absMonth - a.month) / (b.month - a.month);
        final pop = a.popularityValue +
            ((b.popularityValue - a.popularityValue) * t).round();
        return (name: rival.rivalName, popularity: pop);
      }
    }
    return (name: rival.rivalName, popularity: stones.last.popularityValue);
  }

  /// Göreceli popülarite çarpanı: rakibe yaklaştıkça kazanç AZALIR (son düzlük
  /// zor olsun). 0.7×rakip altı → tam; 0.7..1.0 → 1.0'dan 0.3'e iner; geçtiyse 0.25.
  double popGainFactor(int currentPop, int rivalPop) {
    if (rivalPop <= 0) return 1.0;
    final ratio = currentPop / rivalPop;
    // Rakibe yaklaştıkça kazanç çok daha sert düşer (son düzlük çetin):
    // 0.45 altı tam hız, 0.45..1.0 arası 1.0 → 0.12'ye iner, geçtiyse 0.1.
    if (ratio < 0.45) return 1.0;
    if (ratio >= 1.0) return 0.1;
    return (1.0 - (ratio - 0.45) / 0.55 * 0.88).clamp(0.12, 1.0);
  }

  /// Bu kariyer için anlık popülarite kazanç çarpanı (konser/tur/albüm/trajektori
  /// hepsi bunu kullanır). Grubun mevcut popülaritesi rakibe göre değerlendirilir.
  Future<double> currentPopGainFactor(int careerId) async {
    final g = await getActiveGroup(careerId);
    if (g == null) return 1.0;
    final career = await (db.select(db.playerCareers)
          ..where((t) => t.id.equals(careerId)))
        .getSingleOrNull();
    if (career == null) return 1.0;
    final absMonth = (career.currentYear - 1) * 12 + career.currentMonth;
    final rival = await rivalStatusAt(absMonth);
    return popGainFactor(g.totalPopularity, rival.popularity);
  }

  // ---------------- AYLIK TRAJEKTORİ ----------------
  // Popülarite: (güç × 400 × kimya_çarpanı) + şarkı bonusu
  // (Dengelendi — rakibe ulaşmak uzun soluklu bir hedef olsun diye yavaşlatıldı.)
  Future<void> advanceGroupTrajectory(int careerId, int month,
      {int songBonus = 0}) async {
    final g = await getActiveGroup(careerId);
    if (g == null) return;

    final members = await membersFull(g.id);
    if (members.isEmpty) return;

    final ids = members.map((m) => m.idol.id).toList();
    final power = members
            .map((m) => memberOverall(m.idol, m.char))
            .fold<int>(0, (s, o) => s + o) /
        members.length;

    final chem = await avgChemistryForIds(ids);
    final double mult = 1.0 + (chem / 333.0);

    // Star power: en popüler üye (center) grubu hızlandırır
    int maxFame = 0;
    for (final m in members) {
      final f = m.char.startingFame + m.idol.popularityBonus;
      if (f > maxFame) maxFame = f;
    }
    final int starBonus = maxFame * 120;

    // Göreceli çarpan: rakibe yaklaştıkça kazanç azalır (hareketli hedef)
    final double gainFactor = await currentPopGainFactor(careerId);

    // İTİBAR & SKANDAL çarpanı: yüksek itibar büyütür, skandal kısar/küçültür
    final double repFactor = 0.6 + g.reputation / 100.0; // 0.6..1.6
    final double scandalFactor = g.scandalHeat >= 80
        ? 0.3
        : g.scandalHeat >= 50
            ? 0.7
            : 1.0;

    int delta = (((power * 400 * mult) + songBonus + starBonus) *
            gainFactor *
            repFactor *
            scandalFactor)
        .round();
    if (delta < 0) delta = 0;

    int newPop = g.totalPopularity + delta;
    int newFollowers = g.socialFollowers;

    // Düşük itibar ya da yüksek skandal → fan kaçışı (takipçi + popülarite erir)
    if (g.reputation < 40 || g.scandalHeat > 60) {
      newPop = (newPop * 0.97).round();
      newFollowers = (newFollowers * 0.95).round();
    }

    await (db.update(db.groups)..where((t) => t.id.equals(g.id))).write(
      GroupsCompanion(
        totalPopularity: Value(newPop),
        socialFollowers: Value(newFollowers),
        fanbaseSize: Value(newPop * 10),
      ),
    );
  }

  // ---------------- BİREYSEL ŞÖHRET & İÇ REKABET ----------------
  // Her ay: üyeler pozisyon+yeteneğe göre bireysel şöhret kazanır.
  // Şöhret uçurumu büyükse kıskançlık → kimya ve moral düşer.
  Future<void> updateMemberPopularityAndRivalry(int careerId, int month) async {
    final g = await getActiveGroup(careerId);
    if (g == null) return;
    final members = await membersFull(g.id);
    if (members.isEmpty) return;

    // 1) Şöhret kazanımı
    for (final m in members) {
      final w = _positionFameWeight(m.position);
      final overall = memberOverall(m.idol, m.char);
      final gain = (w * (2 + overall / 30.0)).round();
      await (db.update(db.playerIdols)..where((t) => t.id.equals(m.idol.id)))
          .write(PlayerIdolsCompanion(
        popularityBonus: Value(m.idol.popularityBonus + gain),
      ));
    }

    // 2) Kıskançlık: en popüler üye ortalamanın çok üstündeyse gerilim
    final fames = members
        .map((m) => m.char.startingFame + m.idol.popularityBonus)
        .toList();
    final maxFame = fames.reduce((a, b) => a > b ? a : b);
    final avgFame = fames.fold<int>(0, (s, f) => s + f) / fames.length;

    if (avgFame > 0 && maxFame > avgFame * 1.6 && members.length >= 2) {
      // Center'ı bul
      int centerIdolId = members.first.idol.id;
      int best = -1;
      for (final m in members) {
        final f = m.char.startingFame + m.idol.popularityBonus;
        if (f > best) {
          best = f;
          centerIdolId = m.idol.id;
        }
      }
      // Diğer üyelerin morali düşer (favorileştirme algısı)
      for (final m in members) {
        if (m.idol.id == centerIdolId) continue;
        await (db.update(db.playerIdols)..where((t) => t.id.equals(m.idol.id)))
            .write(PlayerIdolsCompanion(
          mood: Value((m.idol.mood - 3).clamp(0, 100)),
        ));
      }
      // Center'ın diğerleriyle kimyası gerilir
      final otherIds =
          members.where((m) => m.idol.id != centerIdolId).map((m) => m.idol.id);
      for (final oid in otherIds) {
        final a = centerIdolId < oid ? centerIdolId : oid;
        final b = centerIdolId < oid ? oid : centerIdolId;
        final rel = await (db.select(db.chemistryRelations)
              ..where((t) => t.idolAId.equals(a) & t.idolBId.equals(b))
              ..limit(1))
            .getSingleOrNull();
        if (rel != null) {
          await (db.update(db.chemistryRelations)
                ..where((t) => t.id.equals(rel.id)))
              .write(ChemistryRelationsCompanion(
            chemistryScore: Value((rel.chemistryScore - 3).clamp(-100, 100)),
          ));
        }
      }
    }
  }

  double _positionFameWeight(String position) {
    switch (position) {
      case 'visual':
        return 1.3;
      case 'main_vocal':
        return 1.2;
      case 'leader':
        return 1.15;
      case 'rapper':
      case 'lead_dancer':
        return 1.0;
      default:
        return 0.8;
    }
  }

  // ---------------- ÇÖKME MEKANİĞİ ----------------

  /// Maaş ödenemediyse grup üyelerinin loyalitisini ve moralini düşürür.
  /// Herhangi bir üyenin loyaliti 20'nin altına düşerse grubu dağıtır.
  /// Grubu dağıttıysa true döner.
  Future<bool> handleDebtAndCheckDisband(int careerId, int month) async {
    final g = await getActiveGroup(careerId);
    if (g == null) return false;

    final memberRows = await (db.select(db.groupMembers)
          ..where(
              (t) => t.groupId.equals(g.id) & t.leaveMonth.isNull()))
        .get();

    bool shouldDisband = false;
    for (final m in memberRows) {
      final idol = await (db.select(db.playerIdols)
            ..where((t) => t.id.equals(m.idolId)))
          .getSingleOrNull();
      if (idol == null) continue;
      final newLoyalty = (idol.loyalty - 20).clamp(0, 100);
      final newMood = (idol.mood - 15).clamp(0, 100);
      await (db.update(db.playerIdols)
            ..where((t) => t.id.equals(idol.id)))
          .write(PlayerIdolsCompanion(
        loyalty: Value(newLoyalty),
        mood: Value(newMood),
      ));
      if (newLoyalty < 20) shouldDisband = true;
    }

    if (shouldDisband) {
      await disbandGroup(
        groupId: g.id,
        careerId: careerId,
        month: month,
        reason: 'Maaşlar ödenemedi. İdoller morallerini kaybederek grubu terk etti.',
      );
      return true;
    }
    return false;
  }

  /// Sadakati çok düşen üyeler gruptan ayrılır. Aktif üye 3'ün altına düşerse
  /// grup tamamen dağılır. Ayrılan üyelerin adlarını ve dağılma bilgisini döner.
  Future<({List<String> departed, bool disbanded})> checkMemberDepartures(
      int careerId, int month) async {
    final g = await getActiveGroup(careerId);
    if (g == null) return (departed: const <String>[], disbanded: false);

    final rows = await (db.select(db.groupMembers).join([
      innerJoin(
          db.playerIdols, db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.groupMembers.groupId.equals(g.id) &
              db.groupMembers.leaveMonth.isNull()))
        .get();

    final departed = <String>[];
    int remaining = rows.length;
    for (final row in rows) {
      final gm = row.readTable(db.groupMembers);
      final idol = row.readTable(db.playerIdols);
      final ch = row.readTable(db.generatedCharacters);
      // Sadakat dibe vurursa ayrılır (moral krizi ayrı bir karar olayıyla işlenir).
      final lowLoyalty = idol.loyalty < 12;
      if (lowLoyalty) {
        await (db.update(db.groupMembers)..where((t) => t.id.equals(gm.id)))
            .write(GroupMembersCompanion(leaveMonth: Value(month)));
        await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
            .write(const PlayerIdolsCompanion(status: Value('released')));
        departed.add(ch.name);
        remaining--;

        await db.into(db.events).insert(EventsCompanion.insert(
              careerId: careerId,
              groupId: Value(g.id),
              eventType: 'member_left',
              category: const Value('intra_group'),
              title: '${ch.name} Gruptan Ayrıldı',
              description: Value(
                  '${ch.name} sadakatini tamamen yitirdi ve grubu terk etti.'),
              monthOccurred: month,
              impactValue: const Value(-50),
              resolved: const Value(true),
            ));
        // Ayrılığın bedeli: takipçi/popülarite düşer + fanlar tepki verir
        await applyDepartureFallout(
            careerId, ch.name, ch.startingFame + idol.popularityBonus, month);
      }
    }

    if (remaining < 3) {
      await disbandGroup(
        groupId: g.id,
        careerId: careerId,
        month: month,
        reason:
            'Çok fazla üye ayrıldı; grup ayakta kalamadı ve dağıldı.',
      );
      return (departed: departed, disbanded: true);
    }
    return (departed: departed, disbanded: false);
  }

  /// Üye ayrılığının bedeli: takipçi + popülarite düşer, ivme kırılır, fanlar
  /// tepki gösterir (fandom sadakati düşer). Şöhretli üye giderse daha sert.
  Future<void> applyDepartureFallout(
      int careerId, String name, int memberFame, int month) async {
    final g = await getActiveGroup(careerId);
    if (g == null) return;
    // Şöhret ne kadar büyükse o kadar çok hayran ayrılır (%8..%22 takipçi)
    final famePct = (0.08 + (memberFame / 100.0) * 0.14).clamp(0.08, 0.22);
    final followerLoss = (g.socialFollowers * famePct).round();
    final popLoss = (g.totalPopularity * (famePct * 0.8)).round();
    await (db.update(db.groups)..where((t) => t.id.equals(g.id))).write(
      GroupsCompanion(
        socialFollowers:
            Value((g.socialFollowers - followerLoss).clamp(0, 1 << 31)),
        totalPopularity:
            Value((g.totalPopularity - popLoss).clamp(0, 1 << 31)),
        fandomLoyalty: Value((g.fandomLoyalty - 10).clamp(0, 100)),
        scandalHeat: Value((g.scandalHeat + 8).clamp(0, 100)),
      ),
    );
    await db.into(db.events).insert(EventsCompanion.insert(
          careerId: careerId,
          groupId: Value(g.id),
          eventType: 'fan_outrage',
          category: const Value('social'),
          title: 'Fanlar Ayağa Kalktı! 💔',
          description: Value(
              '$name\'in ayrılığına hayranlar büyük tepki gösterdi. Takipçi -${_fmtK(followerLoss)}, erişim -${_fmtK(popLoss)}. Sosyal medya karıştı.'),
          monthOccurred: month,
          impactValue: Value(-followerLoss),
          resolved: const Value(true),
        ));
  }

  static String _fmtK(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return '$n';
  }

  /// Tek bir üyeyi gruptan çıkarır. Aktif üye 3'ün altına düşerse grup dağılır.
  /// (disbanded, name) döner.
  Future<({bool disbanded, String name})> removeMember(
      int careerId, int groupId, int idolId, int month,
      {String? reason}) async {
    final gmRow = await (db.select(db.groupMembers)
          ..where((t) =>
              t.groupId.equals(groupId) &
              t.idolId.equals(idolId) &
              t.leaveMonth.isNull())
          ..limit(1))
        .getSingleOrNull();
    final charRow = await (db.select(db.playerIdols).join([
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.playerIdols.id.equals(idolId)))
        .getSingleOrNull();
    final name = charRow?.readTable(db.generatedCharacters).name ?? 'Üye';
    final idolRow = charRow?.readTable(db.playerIdols);
    final ch = charRow?.readTable(db.generatedCharacters);
    final fame = (ch?.startingFame ?? 0) + (idolRow?.popularityBonus ?? 0);

    if (gmRow != null) {
      await (db.update(db.groupMembers)..where((t) => t.id.equals(gmRow.id)))
          .write(GroupMembersCompanion(leaveMonth: Value(month)));
    }
    await (db.update(db.playerIdols)..where((t) => t.id.equals(idolId)))
        .write(const PlayerIdolsCompanion(status: Value('released')));

    await db.into(db.events).insert(EventsCompanion.insert(
          careerId: careerId,
          groupId: Value(groupId),
          eventType: 'member_removed',
          category: const Value('intra_group'),
          title: '$name Gruptan Çıkarıldı',
          description: Value(reason ?? '$name menajer kararıyla gruptan ayrıldı.'),
          monthOccurred: month,
          impactValue: const Value(-30),
          resolved: const Value(true),
        ));
    // Ayrılığın bedeli (şöhretli üye giderse fanlar daha sert tepki verir)
    await applyDepartureFallout(careerId, name, fame, month);

    final remaining = await (db.select(db.groupMembers)
          ..where(
              (t) => t.groupId.equals(groupId) & t.leaveMonth.isNull()))
        .get();
    if (remaining.length < 3) {
      await disbandGroup(
        groupId: groupId,
        careerId: careerId,
        month: month,
        reason: 'Üye sayısı 3\'ün altına düştü; grup dağıldı.',
      );
      return (disbanded: true, name: name);
    }
    return (disbanded: false, name: name);
  }

  /// Grup kurulduktan sonra şirketteki bir yedek idolü gruba katar.
  Future<void> addMemberToGroup(
      int groupId, int idolId, int month) async {
    // Zaten aktif üye mi? (çift kayıt önle)
    final existing = await (db.select(db.groupMembers)
          ..where((t) =>
              t.groupId.equals(groupId) &
              t.idolId.equals(idolId) &
              t.leaveMonth.isNull())
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) return;

    // Yedekten gruba katılınca tekrar aktif olur
    await (db.update(db.playerIdols)..where((t) => t.id.equals(idolId)))
        .write(const PlayerIdolsCompanion(status: Value('active')));
    await db.into(db.groupMembers).insert(GroupMembersCompanion.insert(
          groupId: groupId,
          idolId: idolId,
          position: 'member',
          joinMonth: month,
        ));
  }

  /// Üyeyi gruptan çıkarıp YEDEĞE alır (silinmez, kadroya geri çağrılabilir).
  /// Aktif üye 3'ün altına düşecekse engeller ve false döner.
  Future<bool> benchMember(int groupId, int idolId, int month) async {
    final active = await (db.select(db.groupMembers)
          ..where((t) => t.groupId.equals(groupId) & t.leaveMonth.isNull()))
        .get();
    if (active.length <= 3) return false; // min 3 üye

    final row = active.where((m) => m.idolId == idolId).toList();
    if (row.isEmpty) return false;
    await (db.update(db.groupMembers)..where((t) => t.id.equals(row.first.id)))
        .write(GroupMembersCompanion(leaveMonth: Value(month)));
    await (db.update(db.playerIdols)..where((t) => t.id.equals(idolId)))
        .write(const PlayerIdolsCompanion(status: Value('reserve')));
    return true;
  }

  /// Skandal ısısı yüksekse (>=80) grup gerilir: her ay kimya, moral ve sadakat
  /// aşınır. Düşen kimya çatışma krizlerini, düşen sadakat üye kaçışını besler.
  /// Baskı uygulandıysa true döner (UI uyarısı için).
  final Random _awardRng = Random();

  /// Ay sonu garip ödülü (~%35). Duruma göre uygun ödülü seçer, 'award'
  /// kategorili olay olarak kaydeder ve başlığını döner (Başarımlar&Ödüller).
  // month = MUTLAK ay ((yıl-1)*12+ay) — ödül gösteriminde yıl çıksın diye.
  Future<String?> maybeMonthlyAward(int careerId, int month) async {
    final g = await getActiveGroup(careerId);
    if (g == null) return null;
    if (_awardRng.nextDouble() > 0.35) return null;

    final candidates = <String>[];
    if (g.socialFollowers >= 50000) candidates.add('🚀 Ayın Çıkış Yapan Grubu');
    if (g.scandalHeat >= 40) candidates.add('🌶️ Ayın En Çok Konuşulanı');
    if (g.reputation >= 60) candidates.add('✨ Ayın Saygın Grubu');
    if (g.fandomLoyalty >= 60) candidates.add('💜 En Sadık Fandom Ödülü');
    candidates.addAll([
      '🎤 Ayın Karaoke Şampiyonu',
      '📸 En Çok Selfie Çeken Grup',
      '🍕 Stüdyoda En Çok Pizza Yiyen Grup',
      '😴 En Çok Uyuyakalan Idol Grubu',
      '🎁 Ayın Sürpriz Ödülü',
    ]);
    final title = candidates[_awardRng.nextInt(candidates.length)];

    await db.into(db.events).insert(EventsCompanion.insert(
          careerId: careerId,
          groupId: Value(g.id),
          eventType: 'monthly_award',
          category: const Value('award'),
          title: title,
          description: Value('Ödül kazanıldı: $title'),
          monthOccurred: month,
          resolved: const Value(true),
        ));
    return title;
  }

  /// Ay sonu gazete manşeti (~%45). Gruba dair manşet üretir → UI gazete popup.
  Future<String?> maybeNewspaperHeadline(int careerId, int month) async {
    final g = await getActiveGroup(careerId);
    if (g == null) return null;
    if (_awardRng.nextDouble() > 0.45) return null;

    final grup = g.groupName;
    final pool = <String>[];
    if (g.scandalHeat >= 60) {
      pool.addAll([
        '$grup SKANDAL DALGASINDA: Magazin yıkıldı!',
        'GÜNDEM SARSILDI: $grup hakkında şok iddialar',
        'PERDE ARKASI: $grup\'ta gerilim tırmanıyor',
      ]);
    }
    if (g.reputation >= 70) {
      pool.addAll([
        '$grup ZİRVEDE: Eleştirmenler tek ses',
        'BAŞARI ÖYKÜSÜ: $grup sektörü sallıyor',
      ]);
    }
    if (g.socialFollowers >= 200000) {
      pool.add('FENOMEN: $grup sosyal medyayı ele geçirdi');
    }
    pool.addAll([
      '$grup hayranlarını yine şaşırttı',
      'KULİS: $grup için büyük planlar konuşuluyor',
      '$grup\'ın yeni adımı merakla bekleniyor',
    ]);
    return pool[_awardRng.nextInt(pool.length)];
  }

  Future<bool> applyScandalPressure(int careerId, int month) async {
    final g = await getActiveGroup(careerId);
    if (g == null || g.scandalHeat < 80) return false;

    // Fandom da skandaldan etkilenir (sadakat düşer)
    await (db.update(db.groups)..where((t) => t.id.equals(g.id))).write(
        GroupsCompanion(
            fandomLoyalty: Value((g.fandomLoyalty - 8).clamp(0, 100))));

    final members = await (db.select(db.groupMembers)
          ..where((t) => t.groupId.equals(g.id) & t.leaveMonth.isNull()))
        .get();
    final ids = members.map((m) => m.idolId).toList();

    // Moral + sadakat aşınması
    for (final idolId in ids) {
      final idol = await (db.select(db.playerIdols)
            ..where((t) => t.id.equals(idolId)))
          .getSingleOrNull();
      if (idol == null) continue;
      await (db.update(db.playerIdols)..where((t) => t.id.equals(idolId)))
          .write(PlayerIdolsCompanion(
        mood: Value((idol.mood - 4).clamp(0, 100)),
        loyalty: Value((idol.loyalty - 3).clamp(0, 100)),
      ));
    }

    // Kimya aşınması (tüm çiftler) → çatışma krizini besler
    if (ids.length >= 2) {
      final rels = await (db.select(db.chemistryRelations)
            ..where((t) => t.idolAId.isIn(ids) & t.idolBId.isIn(ids)))
          .get();
      for (final r in rels) {
        await (db.update(db.chemistryRelations)
              ..where((t) => t.id.equals(r.id)))
            .write(ChemistryRelationsCompanion(
                chemistryScore: Value((r.chemistryScore - 5).clamp(-100, 100))));
      }
    }
    return true;
  }

  /// Skandal ısısı kritik eşiğe ulaşınca grup dağılır. Dağıttıysa true.
  Future<bool> checkScandalCollapse(int careerId, int month) async {
    final g = await getActiveGroup(careerId);
    if (g == null) return false;
    if (g.scandalHeat >= 95) {
      await disbandGroup(
        groupId: g.id,
        careerId: careerId,
        month: month,
        reason:
            'Skandal kontrolden çıktı (ısı ${g.scandalHeat}/100). Sponsorlar çekildi, grup dağıldı.',
      );
      return true;
    }
    return false;
  }

  Future<void> disbandGroup({
    required int groupId,
    required int careerId,
    required int month,
    required String reason,
  }) async {
    await (db.update(db.groups)..where((t) => t.id.equals(groupId)))
        .write(const GroupsCompanion(status: Value('disbanded')));

    final memberRows = await (db.select(db.groupMembers)
          ..where(
              (t) => t.groupId.equals(groupId) & t.leaveMonth.isNull()))
        .get();

    for (final m in memberRows) {
      await (db.update(db.groupMembers)
            ..where((t) => t.id.equals(m.id)))
          .write(GroupMembersCompanion(leaveMonth: Value(month)));
      await (db.update(db.playerIdols)
            ..where((t) => t.id.equals(m.idolId)))
          .write(const PlayerIdolsCompanion(status: Value('released')));
    }

    await db.into(db.events).insert(EventsCompanion.insert(
      careerId: careerId,
      groupId: Value(groupId),
      eventType: 'group_disbanded',
      title: 'Grup Dağıldı!',
      description: Value(reason),
      monthOccurred: month,
      impactValue: const Value(-100),
    ));

    // Grup dağılması = kariyer biter. Önce arşivle, sonra kapat.
    await archiveCareer(careerId);
    await (db.update(db.playerCareers)..where((t) => t.id.equals(careerId)))
        .write(const PlayerCareersCompanion(status: Value('ended')));
  }

  /// Kariyeri özetleyip CareerHistories'e yazar (geçmiş ekranı için).
  Future<void> archiveCareer(int careerId) async {
    final career = await (db.select(db.playerCareers)
          ..where((t) => t.id.equals(careerId)))
        .getSingleOrNull();
    if (career == null) return;

    // Kariyer bitişi genel başarımları (kusursuz kariyer, hanedan vb.)
    await GlobalAchievementManager(db).checkOnCareerEnd(careerId);

    // Bu kariyere ait en güncel grup (aktif ya da dağılmış)
    final group = await (db.select(db.groups)
          ..where((t) => t.careerId.equals(careerId))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();

    int? peak;
    if (group != null) {
      final songs = await (db.select(db.songs)
            ..where((t) => t.groupId.equals(group.id)))
          .get();
      for (final s in songs) {
        if (s.peakChartPosition != null) {
          peak = peak == null
              ? s.peakChartPosition
              : (s.peakChartPosition! < peak ? s.peakChartPosition : peak);
        }
      }
    }

    final monthsPlayed =
        (career.currentYear - 1) * 12 + career.currentMonth;
    final pop = group?.totalPopularity ?? 0;
    final followers = group?.socialFollowers ?? 0;
    final rep = group?.reputation ?? 0;

    // Final skor: popülarite + takipçi + itibar + ödüller + zirve bonusu
    final score = (pop ~/ 1000) +
        (followers ~/ 1000) +
        rep * 50 +
        career.awardsWon * 1000 +
        (peak != null ? (101 - peak) * 20 : 0);

    await (db.update(db.playerCareers)..where((t) => t.id.equals(careerId)))
        .write(PlayerCareersCompanion(finalScore: Value(score)));

    await db.into(db.careerHistories).insertOnConflictUpdate(
          CareerHistoriesCompanion.insert(
            careerId: careerId,
            careerNumber: career.careerNumber,
            agencyName: Value(career.agencyName),
            groupName: Value(group?.groupName),
            finalPopularity: Value(pop),
            monthsPlayed: Value(monthsPlayed),
            peakChartPosition: Value(peak),
            finalScore: Value(score),
            awardsWon: Value(career.awardsWon),
          ),
        );
  }

  /// Bir albümde zirvesi ≤10 olan en az bir şarkı varsa o albüm "hit" sayılır.
  Future<int> _hitAlbumCount(int groupId) async {
    final albums =
        await (db.select(db.albums)..where((t) => t.groupId.equals(groupId)))
            .get();
    int count = 0;
    for (final a in albums) {
      final hit = await (db.select(db.songs)
            ..where((t) =>
                t.albumId.equals(a.id) &
                t.peakChartPosition.isSmallerOrEqualValue(10))
            ..limit(1))
          .getSingleOrNull();
      if (hit != null) count++;
    }
    return count;
  }

  /// Yıl sonu ödülü: rakibi geçtiysen ya da itibar çok yüksekse "Yılın Grubu".
  /// Şart: 1M takipçi + en az 1 hit albüm. (won, title) döner.
  Future<({bool won, String title})> runYearEndAwards(
      int careerId, int month, int year) async {
    final g = await getActiveGroup(careerId);
    if (g == null) return (won: false, title: '');

    final rival = await rivalStatusAt((year - 1) * 12 + month);
    final beatRival = rival.popularity > 0 && g.totalPopularity >= rival.popularity;
    final highRep = g.reputation >= 85;

    // ZORUNLU ŞARTLAR: en az 1M takipçi + en az 1 hit albüm (title track peak ≤ 10)
    final hasMillion = g.socialFollowers >= 1000000;
    final hitAlbumCount = await _hitAlbumCount(g.id);
    final eligible = hasMillion && hitAlbumCount >= 1;

    if (!eligible || (!beatRival && !highRep)) {
      // Aday oldun ama kazanamadın (akışa düş)
      await db.into(db.events).insert(EventsCompanion.insert(
            careerId: careerId,
            groupId: Value(g.id),
            eventType: 'award_lost',
            category: const Value('pr'),
            title: '🏆 ${year - 1}. Yıl Ödülleri',
            description: Value(eligible
                ? 'Yılın Grubu adaylığına kaldınız ama ödülü kaçırdınız. Gelecek yıl tekrar!'
                : 'Yılın Grubu şartlarını karşılayamadınız (1M takipçi + 1 hit albüm gerekiyor).'),
            monthOccurred: month,
            resolved: const Value(true),
          ));
      return (won: false, title: '');
    }

    // KAZANDIN
    await (db.update(db.groups)..where((t) => t.id.equals(g.id))).write(
      GroupsCompanion(
        totalPopularity: Value(g.totalPopularity + 300000),
        socialFollowers: Value(g.socialFollowers + 50000),
        reputation: Value((g.reputation + 10).clamp(0, 100)),
      ),
    );
    // Üyelerin morali yükselir
    final members = await (db.select(db.groupMembers)
          ..where((t) => t.groupId.equals(g.id) & t.leaveMonth.isNull()))
        .get();
    for (final m in members) {
      final idol = await (db.select(db.playerIdols)
            ..where((t) => t.id.equals(m.idolId)))
          .getSingleOrNull();
      if (idol == null) continue;
      await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
          .write(PlayerIdolsCompanion(
        mood: Value((idol.mood + 8).clamp(0, 100)),
        loyalty: Value((idol.loyalty + 5).clamp(0, 100)),
      ));
    }
    // Ödül sayacını artır
    final career = await (db.select(db.playerCareers)
          ..where((t) => t.id.equals(careerId)))
        .getSingleOrNull();
    if (career != null) {
      await (db.update(db.playerCareers)..where((t) => t.id.equals(careerId)))
          .write(PlayerCareersCompanion(awardsWon: Value(career.awardsWon + 1)));
    }

    await db.into(db.events).insert(EventsCompanion.insert(
          careerId: careerId,
          groupId: Value(g.id),
          eventType: 'award_won',
          category: const Value('award'),
          title: '🏆 YILIN GRUBU: ${g.groupName}!',
          description: const Value(
              'Tebrikler! Grubun yılın en iyisi seçildi. Erişim +300K, takipçi +50K, itibar +10.'),
          // Mutlak ay (yıl gösterimi için)
          monthOccurred: (year - 1) * 12 + month,
          impactValue: const Value(300000),
          resolved: const Value(true),
        ));
    return (won: true, title: 'Yılın Grubu');
  }
}

class _PickInfo {
  final int id;
  final int vocal, dance, rap, visual, charisma;
  _PickInfo({
    required this.id,
    required this.vocal,
    required this.dance,
    required this.rap,
    required this.visual,
    required this.charisma,
  });
}
