// Öğrenci No: 202313171033
import 'dart:math';
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import 'group_manager.dart';
import 'global_achievement_manager.dart';
import 'achievement_manager.dart';
import 'ledger.dart';

// ─── Etki paketi ──────────────────────────────────────────────────────────────
/// Bir olay/seçim sonucunda uygulanacak toplu değişiklikler.
class EventEffect {
  final int popularity;
  final int money;
  final int reputation;   // 0..100 clamp
  final int followers;
  final int scandalHeat;  // 0..100 clamp
  final int moodAll;
  final int loyaltyAll;
  final int chemistryAll; // gruptaki tüm çiftlere
  final int moodTarget;   // sadece olayın hedef üyesine
  final int loyaltyTarget;

  const EventEffect({
    this.popularity = 0,
    this.money = 0,
    this.reputation = 0,
    this.followers = 0,
    this.scandalHeat = 0,
    this.moodAll = 0,
    this.loyaltyAll = 0,
    this.chemistryAll = 0,
    this.moodTarget = 0,
    this.loyaltyTarget = 0,
  });

  /// İnsan-okur kısa özet (UI rozetleri için).
  List<({String text, bool good})> get badges {
    final out = <({String text, bool good})>[];
    void add(String label, int v, {bool moneyLike = false, bool inverse = false}) {
      if (v == 0) return;
      final sign = v > 0 ? '+' : '';
      final good = inverse ? v < 0 : v > 0;
      out.add((text: '$label $sign${moneyLike ? "$v₺" : "$v"}', good: good));
    }
    add('Erişim', popularity);
    add('Para', money, moneyLike: true);
    add('İtibar', reputation);
    add('Takipçi', followers);
    add('Skandal', scandalHeat, inverse: true);
    add('Moral', moodAll);
    add('Sadakat', loyaltyAll);
    add('Kimya', chemistryAll);
    add('Üye morali', moodTarget);
    add('Üye sadakati', loyaltyTarget);
    return out;
  }
}

// ─── Seçim ────────────────────────────────────────────────────────────────────
class EventChoice {
  final String label;
  final String outcome; // seçim sonrası gösterilen sonuç metni
  final EventEffect effect;
  const EventChoice(this.label, this.outcome, this.effect);
}

// ─── Olay şablonu ─────────────────────────────────────────────────────────────
class EventTemplate {
  final String key;
  final String category; // intra_group | company | rival | pr | social | news
  final String title;
  final String description;
  final List<EventChoice> choices; // boş → otomatik (haber/akış) olayı
  final EventEffect autoEffect;
  final bool targeted; // true → bir üyeyi hedef alır; {name} yerine ad yazılır

  const EventTemplate({
    required this.key,
    required this.category,
    required this.title,
    required this.description,
    this.choices = const [],
    this.autoEffect = const EventEffect(),
    this.targeted = false,
  });

  bool get requiresDecision => choices.isNotEmpty;
}

// ─── Kategori meta ────────────────────────────────────────────────────────────
const Map<String, ({String label, String emoji})> kEventCategoryMeta = {
  'intra_group': (label: 'Grup İçi', emoji: '👥'),
  'company': (label: 'Şirket', emoji: '🏢'),
  'rival': (label: 'Rakip', emoji: '⚔️'),
  'pr': (label: 'PR', emoji: '📣'),
  'social': (label: 'Sosyal Medya', emoji: '📱'),
  'news': (label: 'Haber', emoji: '📰'),
};

// ══════════════════════════════════════════════════════════════════════════════
//  EVENT ENGINE
// ══════════════════════════════════════════════════════════════════════════════
class EventEngine {
  final AppDatabase db;
  final Random _rng = Random();
  EventEngine(this.db);

  static final Map<String, EventTemplate> _byKey = {
    for (final t in _catalog) t.key: t
  };

  EventTemplate? templateFor(String key) => _byKey[key];
  List<EventChoice> choicesFor(String key) => _byKey[key]?.choices ?? const [];

  /// Bir olayın hedef üyesinin adı (varsa). UI seçim metinlerinde {name} için.
  Future<String?> affectedMemberName(int eventId) async {
    final aff = await (db.select(db.eventAffectedIdols)
          ..where((t) => t.eventId.equals(eventId))
          ..limit(1))
        .getSingleOrNull();
    if (aff == null) return null;
    final row = await (db.select(db.playerIdols).join([
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.playerIdols.id.equals(aff.idolId)))
        .getSingleOrNull();
    return row?.readTable(db.generatedCharacters).name;
  }

  /// Olayın etkilediği üyelerin (avatar için) ad + görsel bilgisi.
  Future<List<({String name, String? imagePath})>> affectedMembersInfo(
      int eventId) async {
    final affected = await (db.select(db.eventAffectedIdols)
          ..where((t) => t.eventId.equals(eventId)))
        .get();
    final out = <({String name, String? imagePath})>[];
    for (final a in affected) {
      final row = await (db.select(db.playerIdols).join([
        innerJoin(db.generatedCharacters,
            db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
      ])
            ..where(db.playerIdols.id.equals(a.idolId)))
          .getSingleOrNull();
      if (row == null) continue;
      final ch = row.readTable(db.generatedCharacters);
      out.add((name: ch.name, imagePath: ch.imagePath));
    }
    return out;
  }

  /// {name}/{rival} yer tutucularını seçim metninde çözer.
  static String renderChoiceText(String text, String? name) {
    var out = name == null ? text : text.replaceAll('{name}', name);
    return out.replaceAll('{rival}', 'rakip');
  }

  /// UI için: seçimleri hedef üyenin adıyla render ederek döndürür.
  Future<List<EventChoice>> renderedChoicesForEvent(Event ev) async {
    final base = choicesFor(ev.eventType);
    if (base.isEmpty) return base;
    final name = await affectedMemberName(ev.id);
    return base
        .map((c) => EventChoice(
              renderChoiceText(c.label, name),
              renderChoiceText(c.outcome, name),
              c.effect,
            ))
        .toList();
  }

  // ── Haftalık olay üretimi ────────────────────────────────────────────────────
  /// Her hafta çağrılır. [isNewMonth] true ise skandal söner + haber yazılır.
  Future<({List<String> headlines, int pending})> generateWeeklyEvents(
      int careerId, int month, bool isNewMonth) async {
    final group = await (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();

    // Olaylar yalnızca debüt sonrası (grup kurulduktan sonra) işler.
    if (group == null) return (headlines: const <String>[], pending: 0);

    // Skandal ısısı ay sınırında söner
    if (isNewMonth && group.scandalHeat > 0) {
      await (db.update(db.groups)..where((t) => t.id.equals(group.id))).write(
        GroupsCompanion(
            scandalHeat: Value((group.scandalHeat - 15).clamp(0, 100))),
      );
    }

    final headlines = <String>[];

    // Bekleyen karar var mı? Varsa yeni karar olayı üretme (yığılmasın).
    final pendingCount = await _pendingDecisionCount(careerId);

    // Bağlam
    final ctx = await _buildContext(careerId, group, month);

    // 1) Karar olayı. Öncelik: Megastar düeti (2M) → Rodez → çatışma → genel.
    if (pendingCount == 0) {
      final megastarMade =
          await _maybeGenerateMegastarDuet(careerId, group, month);
      final rodezMade = megastarMade
          ? false
          : await _maybeGenerateRodezFeud(careerId, group, month, isNewMonth);
      final crisisMade = (megastarMade || rodezMade)
          ? false
          : await _maybeGenerateConflictCrisis(careerId, group.id, month);
      if (megastarMade) {
        headlines.add('🌟 Megastar düet teklif etti!');
      } else if (rodezMade) {
        headlines.add('⚔️ Rodez yine sahnede!');
      } else if (crisisMade) {
        headlines.add('🔥 Grup içi kriz patladı!');
      } else if (_rng.nextDouble() < 0.32) {
        final candidate = _pickDecisionEvent(ctx);
        if (candidate != null) {
          final renderedTitle = await _insertEvent(
              careerId, group.id, candidate, month,
              resolved: false);
          headlines.add('🔔 $renderedTitle');
        }
      }
    }

    // 2) Otomatik olay (haftalık ~%55 — daha hareketli/skandallı)
    if (_rng.nextDouble() < 0.55) {
      final auto = _pickAutoEvent(ctx);
      if (auto != null) {
        final target = auto.targeted ? await _pickRandomMember(group.id) : null;
        await _applyEffect(careerId, group.id, auto.autoEffect,
            targetIdolId: target?.idolId);
        await _insertEvent(careerId, group.id, auto, month,
            resolved: true,
            outcome: _describeEffect(auto.autoEffect),
            targetName: target?.name,
            targetIdolId: target?.idolId);
        final t = _render(auto.title, target?.name);
        headlines.add('${kEventCategoryMeta[auto.category]?.emoji ?? "•"} $t');
      }
    }

    // 3) Haber raporu (sadece ay sınırında, akış şişmesin)
    if (isNewMonth) {
      final news = _composeNews(ctx, group);
      await db.into(db.events).insert(EventsCompanion.insert(
            careerId: careerId,
            groupId: Value(group.id),
            eventType: 'news_auto',
            category: const Value('news'),
            title: news.$1,
            description: Value(news.$2),
            monthOccurred: month,
            resolved: const Value(true),
          ));
    }

    final newPending = await _pendingDecisionCount(careerId);
    return (headlines: headlines, pending: newPending);
  }

  // ── Karar uygulama ──────────────────────────────────────────────────────────
  Future<void> resolveEvent(int eventId, int choiceIndex) async {
    final ev = await (db.select(db.events)..where((t) => t.id.equals(eventId)))
        .getSingleOrNull();
    if (ev == null || ev.resolved) return;

    // Çatışma krizi özel mantıkla çözülür (üye kovma vb.)
    if (ev.eventType == 'conflict_crisis') {
      await _resolveConflict(ev, choiceIndex);
      return;
    }
    // Rakip düellosu: sonuç üyenin yeteneğine bağlı
    if (ev.eventType == 'rival_battle') {
      await _resolveBattle(ev, choiceIndex);
      return;
    }
    // Megastar düet teklifini kabul (idx0) → düet şarkısı + başarım
    if (ev.eventType == 'megastar_duet' && choiceIndex == 0) {
      await _resolveMegastarDuet(ev);
      return;
    }
    // Düete katıl (idx0) → diskografiye bir düet şarkısı eklenir
    if (ev.eventType == 'rival_collab' && choiceIndex == 0) {
      await _resolveDuet(ev);
      return;
    }
    // Moral krizi: tut (idx0, ağır koşullar) ya da bırak (idx1)
    if (ev.eventType == 'morale_quit_threat') {
      await _resolveMoraleQuit(ev, choiceIndex);
      return;
    }
    // Sözleşme sızıntısı: koşulları iyileştir (idx 0) → kalıcı maaş artışı
    if (ev.eventType == 'scandal_contract_leak' && choiceIndex == 0) {
      await _resolveContractImprove(ev);
      return;
    }
    // Deneysel konsept (idx 0) → riskli: ya eleştirmenler bayılır ya flop olur
    if (ev.eventType == 'intra_creative' && choiceIndex == 0) {
      await _resolveExperimental(ev);
      return;
    }
    // Solo teklifine izin (idx 0) → büyük skandal + fandom bölünmesi + fan twitleri
    if (ev.eventType == 'target_solo_offer' && choiceIndex == 0) {
      await _resolveSoloOffer(ev);
      return;
    }
    // Transfer: idx0 maaş zammı, idx1 ikna (ilişkiye bağlı), idx2 umursama → ayrılır
    if (ev.eventType == 'company_poach' && choiceIndex == 0) {
      await _resolvePoachRaise(ev);
      return;
    }
    if (ev.eventType == 'company_poach' && choiceIndex == 1) {
      await _resolvePoachPersuade(ev);
      return;
    }
    if (ev.eventType == 'company_poach' && choiceIndex == 2) {
      await _resolvePoachIgnore(ev);
      return;
    }

    final choices = choicesFor(ev.eventType);
    if (choiceIndex < 0 || choiceIndex >= choices.length) return;
    final choice = choices[choiceIndex];

    // Hedefli olaysa, etkilenen üyeyi bul
    final affected = await (db.select(db.eventAffectedIdols)
          ..where((t) => t.eventId.equals(eventId))
          ..limit(1))
        .getSingleOrNull();

    await _applyEffect(ev.careerId, ev.groupId, choice.effect,
        targetIdolId: affected?.idolId);

    final name = await affectedMemberName(eventId);
    await (db.update(db.events)..where((t) => t.id.equals(eventId))).write(
      EventsCompanion(
        resolved: const Value(true),
        resolutionChoice: Value(renderChoiceText(choice.label, name)),
        resolutionOutcome: Value(renderChoiceText(choice.outcome, name)),
      ),
    );
  }

  // ── MORAL KRİZİ (düşük moralli üye ayrılma tehdidi) ──────────────────────────

  /// Morali 20'nin altına düşen üye adlarını döner (UYARI popup'ı için).
  Future<List<String>> lowMoraleMembers(int careerId) async {
    final group = await (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
    if (group == null) return [];
    final rows = await (db.select(db.groupMembers).join([
      innerJoin(
          db.playerIdols, db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.groupMembers.groupId.equals(group.id) &
              db.groupMembers.leaveMonth.isNull()))
        .get();
    final out = <String>[];
    for (final r in rows) {
      final idol = r.readTable(db.playerIdols);
      if (idol.mood >= 10 && idol.mood < 20) {
        out.add(r.readTable(db.generatedCharacters).name);
      }
    }
    return out;
  }

  /// Morali 10'un ALTINDA bir üye varsa "ayrılmak istiyor" karar olayı üretir
  /// (bekleyen karar yoksa). true dönerse olay oluştu.
  Future<bool> maybeGenerateMoraleQuit(int careerId, int month) async {
    if (await _pendingDecisionCount(careerId) > 0) return false;
    final group = await (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
    if (group == null) return false;
    final rows = await (db.select(db.groupMembers).join([
      innerJoin(
          db.playerIdols, db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.groupMembers.groupId.equals(group.id) &
              db.groupMembers.leaveMonth.isNull()))
        .get();
    if (rows.length <= 3) return false; // min kadro: tehdit yerine direkt kalır
    // En düşük moralli üye
    rows.sort((a, b) => a
        .readTable(db.playerIdols)
        .mood
        .compareTo(b.readTable(db.playerIdols).mood));
    final low = rows.first;
    final idol = low.readTable(db.playerIdols);
    final ch = low.readTable(db.generatedCharacters);
    if (idol.mood >= 10) return false;

    final tmpl = _byKey['morale_quit_threat']!;
    await _insertEvent(careerId, group.id, tmpl, month,
        resolved: false, targetName: ch.name, targetIdolId: idol.id);
    return true;
  }

  /// Megastar düet teklifi: grup 2M takipçiye ulaşınca BİR KEZ çıkar.
  Future<bool> _maybeGenerateMegastarDuet(
      int careerId, Group group, int month) async {
    if (group.socialFollowers < 1500000) return false;
    // Daha önce teklif edildiyse tekrar çıkmasın
    final existing = await (db.select(db.events)
          ..where((t) =>
              t.careerId.equals(careerId) &
              t.eventType.equals('megastar_duet'))
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) return false;
    await _insertEvent(careerId, group.id, _byKey['megastar_duet']!, month,
        resolved: false);
    return true;
  }

  // ── RODEZ HUSUMETİ (baş düşman, 6 ayda bir kızışır) ──────────────────────────

  /// Rodez husumeti oyunda YALNIZCA 2 KEZ çıkar: 1.'de diss atar, 2.'de son
  /// gönderme (görmezden gelinir) ve husumet biter. ~6 ay aralıkla.
  Future<bool> _maybeGenerateRodezFeud(
      int careerId, Group group, int month, bool isNewMonth) async {
    if (!isNewMonth) return false;
    if (group.rodezFeud >= 2) return false; // en fazla 2 kez
    final career = await (db.select(db.playerCareers)
          ..where((t) => t.id.equals(careerId)))
        .getSingleOrNull();
    if (career == null) return false;
    final absMonth = (career.currentYear - 1) * 12 + month;

    if (group.lastRodezMonth != null) {
      if (absMonth - group.lastRodezMonth! < 6) return false;
    } else {
      // İlk husumet için grup biraz tanınsın (≥40K takipçi)
      if (group.socialFollowers < 40000) return false;
    }

    final newFeud = group.rodezFeud + 1;
    // 1. çıkış: diss; 2. çıkış: son gönderme (kapanış)
    final tmpl =
        newFeud >= 2 ? _byKey['rodez_final']! : _byKey['rodez_diss']!;

    await _insertEvent(careerId, group.id, tmpl, month, resolved: false);
    await (db.update(db.groups)..where((t) => t.id.equals(group.id))).write(
      GroupsCompanion(
        rodezFeud: Value(newFeud),
        lastRodezMonth: Value(absMonth),
      ),
    );
    return true;
  }

  // ── ÇATIŞMA KRİZİ (iki üye) ─────────────────────────────────────────────────

  /// Kimyası kritik dibe vuran (< -55) bir çift varsa kriz olayı üretir.
  Future<bool> _maybeGenerateConflictCrisis(
      int careerId, int groupId, int month) async {
    final rows = await (db.select(db.groupMembers).join([
      innerJoin(
          db.playerIdols, db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.groupMembers.groupId.equals(groupId) &
              db.groupMembers.leaveMonth.isNull()))
        .get();
    if (rows.length < 2) return false;

    final idToName = <int, String>{};
    final ids = <int>[];
    for (final r in rows) {
      final idol = r.readTable(db.playerIdols);
      final ch = r.readTable(db.generatedCharacters);
      idToName[idol.id] = ch.name;
      ids.add(idol.id);
    }

    final rels = await (db.select(db.chemistryRelations)
          ..where((t) => t.idolAId.isIn(ids) & t.idolBId.isIn(ids)))
        .get();
    ChemistryRelation? worst;
    for (final r in rels) {
      if (r.chemistryScore < -55) {
        if (worst == null || r.chemistryScore < worst.chemistryScore) worst = r;
      }
    }
    if (worst == null) return false;

    // %70 ihtimalle kriz patlar
    if (_rng.nextDouble() > 0.70) return false;

    final name1 = idToName[worst.idolAId] ?? 'Üye';
    final name2 = idToName[worst.idolBId] ?? 'Üye';
    final tmpl = _byKey['conflict_crisis']!;

    final eventId = await db.into(db.events).insert(EventsCompanion.insert(
          careerId: careerId,
          groupId: Value(groupId),
          eventType: 'conflict_crisis',
          category: const Value('intra_group'),
          title: tmpl.title.replaceAll('{name1}', name1).replaceAll('{name2}', name2),
          description: Value(tmpl.description
              .replaceAll('{name1}', name1)
              .replaceAll('{name2}', name2)),
          monthOccurred: month,
          requiresDecision: const Value(true),
          resolved: const Value(false),
        ));
    // İki üyeyi de bağla
    await db.into(db.eventAffectedIdols).insert(
        EventAffectedIdolsCompanion.insert(
            eventId: eventId, idolId: worst.idolAId));
    await db.into(db.eventAffectedIdols).insert(
        EventAffectedIdolsCompanion.insert(
            eventId: eventId, idolId: worst.idolBId));
    return true;
  }

  Future<void> _resolveConflict(Event ev, int idx) async {
    final affected = await (db.select(db.eventAffectedIdols)
          ..where((t) => t.eventId.equals(ev.id)))
        .get();
    if (affected.length < 2 || ev.groupId == null) {
      await (db.update(db.events)..where((t) => t.id.equals(ev.id)))
          .write(const EventsCompanion(resolved: Value(true)));
      return;
    }
    final aId = affected[0].idolId;
    final bId = affected[1].idolId;

    String label;
    String outcome;

    switch (idx) {
      case 0: // Kriz yönetimi: PAHALI profesyonel arabuluculuk
        label = 'Profesyonel arabuluculuk';
        // Maliyet grubun büyüklüğüyle ölçeklenir (ünlü grup = pahalı danışman)
        final cg = ev.groupId == null
            ? null
            : await (db.select(db.groups)..where((t) => t.id.equals(ev.groupId!)))
                .getSingleOrNull();
        final cost = cg == null
            ? 12000
            : (8000 + cg.socialFollowers * 0.04).round().clamp(8000, 120000);
        await _applyEffect(
            ev.careerId, ev.groupId, EventEffect(money: -cost));
        if (_rng.nextDouble() < 0.7) {
          await _adjustPairChem(aId, bId, 45);
          await _adjustMoodPair(aId, bId, 6);
          outcome =
              'Pahalı ama işe yaradı! Profesyonel danışman taraflarını barıştırdı (-$cost₺).';
        } else {
          await _adjustPairChem(aId, bId, 12);
          outcome =
              'Danışmana $cost₺ ödedin ama tam barış sağlanamadı, gerginlik sürüyor.';
        }
        break;
      case 1: // Sıkı disiplin uygula
        label = 'Sıkı disiplin uygula';
        await _adjustPairChem(aId, bId, 20);
        await _applyEffect(ev.careerId, ev.groupId,
            const EventEffect(moodAll: -5, loyaltyAll: -3));
        outcome = 'İkisini de hizaya çektin; gerginlik azaldı ama moraller düştü.';
        break;
      case 2: // Zayıf üyeyi gruptan çıkar
        label = 'Zayıf üyeyi gruptan çıkar';
        final weaker = await _weakerOf(aId, bId);
        final gm = GroupManager(db);
        final res = await gm.removeMember(
            ev.careerId, ev.groupId!, weaker, ev.monthOccurred,
            reason: 'Grup içi çatışmayı çözmek için kadrodan çıkarıldı.');
        outcome = res.disbanded
            ? '${res.name} çıkarıldı ama üye sayısı yetersiz kaldı — grup dağıldı!'
            : '${res.name} gruptan çıkarıldı, çatışma sona erdi.';
        break;
      default: // Görmezden gel
        label = 'Görmezden gel';
        await _adjustPairChem(aId, bId, -8);
        await _applyEffect(
            ev.careerId, ev.groupId, const EventEffect(loyaltyAll: -4));
        outcome =
            'Sorunu görmezden geldin; gerginlik sürüyor ve sadakat aşınıyor.';
        break;
    }

    await (db.update(db.events)..where((t) => t.id.equals(ev.id))).write(
      EventsCompanion(
        resolved: const Value(true),
        resolutionChoice: Value(label),
        resolutionOutcome: Value(outcome),
      ),
    );
  }

  /// Rakip düellosu: kabul edilirse üyenin en güçlü efektif yeteneği rakibin
  /// rastgele gücüne karşı yarışır.
  Future<void> _resolveBattle(Event ev, int idx) async {
    final affected = await (db.select(db.eventAffectedIdols)
          ..where((t) => t.eventId.equals(ev.id))
          ..limit(1))
        .getSingleOrNull();

    String label;
    String outcome;

    if (idx == 1 || affected == null) {
      // Reddet
      label = 'Reddet (güvenli)';
      await _applyEffect(
          ev.careerId, ev.groupId, const EventEffect(followers: -2000, reputation: 1));
      outcome = 'Düelloya girilmedi; bazı fanlar hayal kırıklığına uğradı.';
    } else {
      label = 'Meydan okumayı kabul et';
      final row = await (db.select(db.playerIdols).join([
        innerJoin(db.generatedCharacters,
            db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
      ])
            ..where(db.playerIdols.id.equals(affected.idolId)))
          .getSingleOrNull();
      int ourSkill = 40;
      if (row != null) {
        final idol = row.readTable(db.playerIdols);
        final ch = row.readTable(db.generatedCharacters);
        final v = ch.vocalSkill + idol.vocalBonus;
        final d = ch.danceSkill + idol.danceBonus;
        final r = ch.rapSkill + idol.rapBonus;
        ourSkill = [v, d, r].reduce((a, b) => a > b ? a : b);
      }
      final rivalSkill = 55 + _rng.nextInt(36); // 55..90 (rakip güçlü)
      if (ourSkill >= rivalSkill) {
        await _applyEffect(
            ev.careerId,
            ev.groupId,
            const EventEffect(
                popularity: 130000,
                followers: 35000,
                reputation: 6,
                moodTarget: 10),
            targetIdolId: affected.idolId);
        outcome =
            'ZAFER! Üyen ($ourSkill) rakibi ($rivalSkill) ezdi geçti. Büyük çıkış!';
      } else {
        await _applyEffect(
            ev.careerId,
            ev.groupId,
            const EventEffect(
                reputation: -5,
                scandalHeat: 8,
                followers: 4000,
                moodTarget: -8),
            targetIdolId: affected.idolId);
        outcome =
            'Mağlubiyet. Üyen ($ourSkill) rakibe ($rivalSkill) yenildi; prestij sarsıldı.';
      }
    }

    await (db.update(db.events)..where((t) => t.id.equals(ev.id))).write(
      EventsCompanion(
        resolved: const Value(true),
        resolutionChoice: Value(label),
        resolutionOutcome: Value(outcome),
      ),
    );
  }

  /// Transfer görmezden gelinince hedef üye rakip şirkete transfer olur.
  Future<void> _resolvePoachIgnore(Event ev) async {
    final affected = await (db.select(db.eventAffectedIdols)
          ..where((t) => t.eventId.equals(ev.id))
          ..limit(1))
        .getSingleOrNull();
    final name = await affectedMemberName(ev.id) ?? 'Üye';
    String outcome;
    if (affected != null) {
      final gm = GroupManager(db);
      if (ev.groupId != null) {
        // Grupta → çıkar (3 altına düşerse grup dağılır)
        final res = await gm.removeMember(
            ev.careerId, ev.groupId!, affected.idolId, ev.monthOccurred,
            reason: '$name rakip şirkete transfer oldu.');
        outcome = res.disbanded
            ? '$name transfer oldu ve kadro yetersiz kaldı — grup dağıldı!'
            : '$name rakip şirkete transfer oldu.';
      } else {
        // Pre-debüt → kadrodan çıkar
        await gm.eliminateIdol(affected.idolId);
        outcome = '$name rakip şirkete transfer oldu, kadrodan ayrıldı.';
      }
    } else {
      outcome = 'Üye ayrıldı.';
    }
    await (db.update(db.events)..where((t) => t.id.equals(ev.id))).write(
      EventsCompanion(
        resolved: const Value(true),
        resolutionChoice: const Value('Umursama'),
        resolutionOutcome: Value(outcome),
      ),
    );
  }

  /// Deneysel konsept: yüksek varyans. Açıklık yüksekse başarı şansı artar.
  /// Başarı → eleştirmen + viral patlama; flop → para/itibar/moral kaybı.
  Future<void> _resolveExperimental(Event ev) async {
    final gid = ev.groupId;
    // Grubun ortalama "açıklık" (openness) puanı başarı şansını belirler
    double successChance = 0.5;
    if (gid != null) {
      final rows = await (db.select(db.groupMembers).join([
        innerJoin(db.playerIdols,
            db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
        innerJoin(db.generatedCharacters,
            db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
      ])
            ..where(db.groupMembers.groupId.equals(gid) &
                db.groupMembers.leaveMonth.isNull()))
          .get();
      if (rows.isNotEmpty) {
        double o = 0;
        for (final r in rows) {
          o += r.readTable(db.generatedCharacters).openness;
        }
        final avgO = o / rows.length;
        successChance = (0.35 + (avgO - 50) / 100.0).clamp(0.25, 0.8);
      }
    }

    String outcome;
    if (_rng.nextDouble() < successChance) {
      // BAŞARI: eleştirmen + viral
      await _applyEffect(
          ev.careerId,
          gid,
          const EventEffect(
              reputation: 8,
              followers: 35000,
              popularity: 90000,
              chemistryAll: 6,
              moodAll: 5));
      await _insertFanReactionPosts(ev.careerId, [
        'Bu yeni konsept BAŞKA! Sanatsal cesaret işte bu 👏🔥',
        'Eleştirmenler bile övüyor, çok gururluyum 🥹💜',
        'Risk aldılar ve kazandılar, efsane bir dönüş!',
      ]);
      outcome =
          'Risk tuttu! Eleştirmenler bayıldı, konsept viral oldu. İtibar +8, takipçi +35K, erişim +90K.';
    } else {
      // FLOP: maliyet + tepki
      await _applyEffect(
          ev.careerId,
          gid,
          const EventEffect(
              money: -8000,
              reputation: -5,
              followers: -12000,
              scandalHeat: 10,
              moodAll: -6,
              chemistryAll: -4));
      await _insertFanReactionPosts(ev.careerId, [
        'Bu konsept neydi ya? Hiç anlamadım, eski tarzınız daha iyiydi 😬',
        'Deney başarısız... umarım eski formuna döner 😕',
        'Cesur ama olmamış, açıkçası hayal kırıklığı.',
      ]);
      outcome =
          'Deney tuttu mu? Hayır. Eleştiri yağdı, prodüksiyon parası boşa gitti. -8000₺, itibar -5, takipçi -12K.';
    }

    await (db.update(db.events)..where((t) => t.id.equals(ev.id))).write(
      EventsCompanion(
        resolved: const Value(true),
        resolutionChoice: const Value('Deneyselliği destekle'),
        resolutionOutcome: Value(outcome),
      ),
    );
  }

  /// Solo projeye izin: büyük olay. Solo şöhret patlar ama fandom bölünür,
  /// grup içi kıskançlık + skandal büyür, hayranlar tepki twitleri atar.
  Future<void> _resolveSoloOffer(Event ev) async {
    final affected = await (db.select(db.eventAffectedIdols)
          ..where((t) => t.eventId.equals(ev.id))
          ..limit(1))
        .getSingleOrNull();
    final name = await affectedMemberName(ev.id) ?? 'Üye';
    final gid = ev.groupId;

    // Solo yıldıza büyük popülarite/şöhret; gruba karışık etki
    if (affected != null) {
      final idol = await (db.select(db.playerIdols)
            ..where((t) => t.id.equals(affected.idolId)))
          .getSingleOrNull();
      if (idol != null) {
        await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
            .write(PlayerIdolsCompanion(
          popularityBonus: Value(idol.popularityBonus + 25),
          mood: Value((idol.mood + 14).clamp(0, 100)),
          loyalty: Value((idol.loyalty + 8).clamp(0, 100)),
        ));
      }
    }
    // Büyük skandal + fandom bölünmesi (diğer üyeler kıskanır)
    await _applyEffect(
        ev.careerId,
        gid,
        const EventEffect(
            popularity: 45000,
            followers: 18000,
            scandalHeat: 28,
            chemistryAll: -16,
            moodAll: -6));
    if (gid != null) {
      final g = await (db.select(db.groups)..where((t) => t.id.equals(gid)))
          .getSingleOrNull();
      if (g != null) {
        await (db.update(db.groups)..where((t) => t.id.equals(gid))).write(
            GroupsCompanion(
                fandomLoyalty: Value((g.fandomLoyalty - 12).clamp(0, 100))));
      }
    }
    // Hayran tepki twitleri (2 adet: biri destek, biri ihanet hissi)
    await _insertFanReactionPosts(ev.careerId, [
      '$name solo çıkıyormuş?? Grup için endişeleniyorum şimdi 😟 #${'solo'}',
      '$name\'in solo projesi efsane olacak, sonuna kadar destek! 🔥💜',
      'Grup dağılıyor mu yoksa... $name solo derken aklım karıştı 😭',
    ]);

    await (db.update(db.events)..where((t) => t.id.equals(ev.id))).write(
      EventsCompanion(
        resolved: const Value(true),
        resolutionChoice: const Value('Solo projeye izin ver'),
        resolutionOutcome: Value(
            '$name solo sahneye çıktı! Büyük gündem oldu — erişim +45K, skandal yükseldi, fandom ikiye bölündü, grup içi kıskançlık arttı.'),
      ),
    );
  }

  /// Belirli bir olaya özel hayran tepki gönderileri ekler (sosyal medyaya birikir).
  Future<void> _insertFanReactionPosts(
      int careerId, List<String> texts) async {
    final career = await (db.select(db.playerCareers)
          ..where((t) => t.id.equals(careerId)))
        .getSingleOrNull();
    if (career == null) return;
    final group = await (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
    final fan = group?.fandomName ?? 'Hayranlar';
    final absWeek = (career.currentYear - 1) * 48 +
        (career.currentMonth - 1) * 4 +
        career.currentWeek;
    // En fazla 2 tepki gönderisi (rastgele seç)
    final shuffled = [...texts]..shuffle(_rng);
    for (final t in shuffled.take(2)) {
      await db.into(db.socialPosts).insert(SocialPostsCompanion.insert(
            careerId: careerId,
            absWeek: absWeek,
            postType: 'fan',
            displayName: fan,
            handle: '@${fan.toLowerCase().replaceAll(' ', '_')}',
            content: t,
            avatarEmoji: '💜',
          ));
    }
  }

  static const List<String> _duetTitles = [
    'İki Kalp', 'Karşı Karşıya', 'Gece & Gündüz', 'Aynı Sahne',
    'Birlikte', 'Yankı', 'Köprü', 'Ortak Yol',
  ];
  // Düet/feat sanatçıları (RAKİP DEĞİL — Manifesto kullanılmaz)
  static const List<String> _featArtists = [
    'Aslı Moon', 'Deniz Volkan', 'Lavin', 'Mavi', 'Eko & Çınar',
    'Selin Aru', 'Kuzey', 'Roya', 'Bahar Işık', 'Tilda',
  ];

  /// Düete katılınca: diskografiye bir düet single'ı eklenir (iyi kalite,
  /// listeye üst sıradan girer) + birleşik fan kitlesi etkisi.
  Future<int> _absMonthOf(int careerId) async {
    final c = await (db.select(db.playerCareers)
          ..where((t) => t.id.equals(careerId)))
        .getSingleOrNull();
    if (c == null) return 1;
    return (c.currentYear - 1) * 12 + c.currentMonth;
  }

  Future<void> _resolveDuet(Event ev) async {
    final gid = ev.groupId;
    if (gid != null) {
      final absMonth = await _absMonthOf(ev.careerId);
      final feat = _featArtists[_rng.nextInt(_featArtists.length)];
      final title =
          '${_duetTitles[_rng.nextInt(_duetTitles.length)]} (feat. $feat)';
      final quality = 70 + _rng.nextInt(16); // 70-85 (düet = güçlü çıkış)
      final startPos = (101 - quality).clamp(1, 30);
      await db.into(db.songs).insert(SongsCompanion.insert(
            groupId: gid,
            title: title,
            genre: const Value('Düet'),
            releaseMonth: absMonth,
            qualityScore: Value(quality),
            currentChartPosition: Value(startPos),
            peakChartPosition: Value(startPos),
            lyricProfile: const Value('Düet'),
          ));
    }
    await _applyEffect(ev.careerId, gid,
        const EventEffect(popularity: 150000, followers: 40000, reputation: 4));
    await (db.update(db.events)..where((t) => t.id.equals(ev.id))).write(
      const EventsCompanion(
        resolved: Value(true),
        resolutionChoice: Value('Düete katıl'),
        resolutionOutcome: Value(
            'İki fan kitlesi birleşti, büyük çıkış oldu! Düet single\'ı diskografinize eklendi.'),
      ),
    );
  }

  static const List<String> _megastars = [
    'Aria Yıldız', 'Kenan Soylu', 'Lara Deniz', 'Efe Kaan', 'Sıla Nur',
  ];

  /// Megastar düetini kabul: çok güçlü bir düet single'ı + büyük çıkış +
  /// "Megastar Düeti" genel başarımı.
  Future<void> _resolveMegastarDuet(Event ev) async {
    final gid = ev.groupId;
    if (gid != null) {
      final absMonth = await _absMonthOf(ev.careerId);
      final star = _megastars[_rng.nextInt(_megastars.length)];
      final title =
          '${_duetTitles[_rng.nextInt(_duetTitles.length)]} (feat. $star)';
      final quality = 88 + _rng.nextInt(10); // 88-97 (megastar = dev çıkış)
      final startPos = (101 - quality).clamp(1, 5);
      await db.into(db.songs).insert(SongsCompanion.insert(
            groupId: gid,
            title: title,
            genre: const Value('Düet'),
            releaseMonth: absMonth,
            qualityScore: Value(quality),
            currentChartPosition: Value(startPos),
            peakChartPosition: Value(startPos),
            lyricProfile: const Value('Düet'),
          ));
    }
    await _applyEffect(ev.careerId, gid,
        const EventEffect(popularity: 400000, followers: 150000, reputation: 8));
    await GlobalAchievementManager(db).unlock('megastar_duet');
    await AchievementManager(db)
        .unlockOne(ev.careerId, 'megastar', ev.monthOccurred);
    await (db.update(db.events)..where((t) => t.id.equals(ev.id))).write(
      const EventsCompanion(
        resolved: Value(true),
        resolutionChoice: Value('Kabul et'),
        resolutionOutcome: Value(
            'Megastar düeti bomba gibi patladı! Şarkı diskografinize girdi, takipçi ve erişim uçtu.'),
      ),
    );
  }

  /// Moral krizi çözümü. idx0: ağır koşullarla tut (büyük kalıcı zam + ayrıcalık
  /// + peşin ödeme, moral/sadakat toparlanır). idx1: bırak gitsin (transfer + fallout).
  Future<void> _resolveMoraleQuit(Event ev, int choiceIndex) async {
    final affected = await (db.select(db.eventAffectedIdols)
          ..where((t) => t.eventId.equals(ev.id))
          ..limit(1))
        .getSingleOrNull();
    final name = await affectedMemberName(ev.id) ?? 'Üye';
    String outcome;

    if (choiceIndex == 0 && affected != null) {
      final idol = await (db.select(db.playerIdols)
            ..where((t) => t.id.equals(affected.idolId)))
          .getSingleOrNull();
      // Ağır koşullar: kalıcı +600 maaş zammı + büyük peşin ayrıcalık ödemesi
      const raise = 600;
      const signing = 12000;
      if (idol != null) {
        await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
            .write(PlayerIdolsCompanion(
          salaryBonus: Value(idol.salaryBonus + raise),
          mood: Value((idol.mood + 45).clamp(0, 100)),
          loyalty: Value((idol.loyalty + 25).clamp(0, 100)),
          fatigue: Value((idol.fatigue - 20).clamp(0, 100)),
        ));
      }
      await _applyEffect(ev.careerId, ev.groupId,
          const EventEffect(money: -signing));
      outcome =
          '$name ağır koşulları kabul ettiğinde kaldı: peşin -$signing₺ + aylık maaşına kalıcı +$raise₺. Morali toparlandı.';
    } else {
      // Bırak gitsin → transfer + ayrılık bedeli
      if (affected != null && ev.groupId != null) {
        final gm = GroupManager(db);
        final res = await gm.removeMember(
            ev.careerId, ev.groupId!, affected.idolId, ev.monthOccurred,
            reason: '$name morali tükendiği için gruptan ayrıldı.');
        outcome = res.disbanded
            ? '$name ayrıldı ve kadro yetersiz kaldı — grup dağıldı!'
            : '$name grubu terk etti. Fanlar üzgün, takipçi/erişim düştü.';
      } else {
        outcome = '$name ayrıldı.';
      }
    }

    await (db.update(db.events)..where((t) => t.id.equals(ev.id))).write(
      EventsCompanion(
        resolved: const Value(true),
        resolutionChoice: Value(
            choiceIndex == 0 ? 'Ağır koşulları kabul et' : 'Bırak gitsin'),
        resolutionOutcome: Value(outcome),
      ),
    );
  }

  /// Sözleşme sızıntısında koşulları iyileştir: TÜM aktif üyelere kalıcı maaş
  /// zammı (salaryBonus +250/üye) + güven/itibar tazelenmesi. Aylık gider artar.
  Future<void> _resolveContractImprove(Event ev) async {
    if (ev.groupId != null) {
      final members = await (db.select(db.groupMembers)
            ..where((t) =>
                t.groupId.equals(ev.groupId!) & t.leaveMonth.isNull()))
          .get();
      for (final m in members) {
        final idol = await (db.select(db.playerIdols)
              ..where((t) => t.id.equals(m.idolId)))
            .getSingleOrNull();
        if (idol == null) continue;
        await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
            .write(PlayerIdolsCompanion(
          salaryBonus: Value(idol.salaryBonus + 250),
          loyalty: Value((idol.loyalty + 8).clamp(0, 100)),
          mood: Value((idol.mood + 4).clamp(0, 100)),
        ));
      }
    }
    await _applyEffect(ev.careerId, ev.groupId,
        const EventEffect(reputation: 4, scandalHeat: -10));
    await (db.update(db.events)..where((t) => t.id.equals(ev.id))).write(
      const EventsCompanion(
        resolved: Value(true),
        resolutionChoice: Value('Koşulları iyileştir'),
        resolutionOutcome: Value(
            'Üyelerin maaşlarını kalıcı olarak yükselttin (aylık gider arttı). Güven ve itibar tazelendi, skandal söndü.'),
      ),
    );
  }

  /// Menajer ikna girişimi: sonuç üyenin grup arkadaşlarıyla KİMYASINA bağlı.
  /// İyi ilişki → kalır; kötü ilişki → ikna tutmaz, transfer olur.
  Future<void> _resolvePoachPersuade(Event ev) async {
    final affected = await (db.select(db.eventAffectedIdols)
          ..where((t) => t.eventId.equals(ev.id))
          ..limit(1))
        .getSingleOrNull();
    final name = await affectedMemberName(ev.id) ?? 'Üye';
    final gid = ev.groupId;

    // Pre-debüt (grup yok) → sadakate göre basit şans
    double stayChance = 0.5;
    if (affected == null) {
      stayChance = 0.6;
    } else if (gid != null) {
      // Grup arkadaşlarıyla ortalama kimya
      final mates = await (db.select(db.groupMembers)
            ..where((t) =>
                t.groupId.equals(gid) & t.leaveMonth.isNull()))
          .get();
      final otherIds = mates
          .map((m) => m.idolId)
          .where((id) => id != affected.idolId)
          .toList();
      if (otherIds.isNotEmpty) {
        final rels = await (db.select(db.chemistryRelations)
              ..where((t) =>
                  (t.idolAId.equals(affected.idolId) &
                      t.idolBId.isIn(otherIds)) |
                  (t.idolBId.equals(affected.idolId) &
                      t.idolAId.isIn(otherIds))))
            .get();
        if (rels.isNotEmpty) {
          final avg =
              rels.map((r) => r.chemistryScore).reduce((a, b) => a + b) /
                  rels.length;
          // avgChem -50 → ~%5 kal, 0 → ~%50, +50 → ~%95
          stayChance = (0.5 + avg / 110.0).clamp(0.05, 0.95);
        }
      }
    }

    String outcome;
    if (_rng.nextDouble() < stayChance) {
      await _applyEffect(ev.careerId, gid,
          const EventEffect(loyaltyTarget: 6, moodTarget: 3),
          targetIdolId: affected?.idolId);
      outcome =
          '$name grup arkadaşlarını çok seviyor — menajer ikna etti, kaldı! Sadakati arttı.';
    } else {
      // İkna tutmadı → transfer
      if (affected != null) {
        final gm = GroupManager(db);
        if (gid != null) {
          final res = await gm.removeMember(
              ev.careerId, gid, affected.idolId, ev.monthOccurred,
              reason: '$name ikna edilemedi, rakip şirkete transfer oldu.');
          outcome = res.disbanded
              ? '$name ikna olmadı ve transfer oldu — kadro yetersiz kaldı, grup dağıldı!'
              : '$name grup içinde mutlu değildi; ikna tutmadı ve rakibe transfer oldu.';
        } else {
          await gm.eliminateIdol(affected.idolId);
          outcome = '$name ikna olmadı ve şirketten ayrıldı.';
        }
      } else {
        outcome = '$name ikna olmadı ve ayrıldı.';
      }
    }

    await (db.update(db.events)..where((t) => t.id.equals(ev.id))).write(
      EventsCompanion(
        resolved: const Value(true),
        resolutionChoice: const Value('Menajer ikna etsin'),
        resolutionOutcome: Value(outcome),
      ),
    );
  }

  /// Transfer baskısında üyeyi tutmak için KALICI maaş zammı (salaryBonus) +
  /// peşin imza primi. Nadirliğe/şöhrete göre zam ölçeklenir.
  Future<void> _resolvePoachRaise(Event ev) async {
    final affected = await (db.select(db.eventAffectedIdols)
          ..where((t) => t.eventId.equals(ev.id))
          ..limit(1))
        .getSingleOrNull();
    final name = await affectedMemberName(ev.id) ?? 'Üye';
    String outcome;
    if (affected != null) {
      final row = await (db.select(db.playerIdols).join([
        innerJoin(db.generatedCharacters,
            db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
      ])
            ..where(db.playerIdols.id.equals(affected.idolId)))
          .getSingleOrNull();
      final idol = row?.readTable(db.playerIdols);
      final ch = row?.readTable(db.generatedCharacters);
      final rarity = ch?.rarity ?? 'common';
      // Nadirliğe göre aylık kalıcı zam
      final raise = switch (rarity) {
        'legendary' => 1200,
        'epic' => 800,
        'rare' => 500,
        _ => 300,
      };
      final signingBonus = raise * 5; // peşin imza primi
      if (idol != null) {
        await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
            .write(PlayerIdolsCompanion(
          salaryBonus: Value(idol.salaryBonus + raise),
          loyalty: Value((idol.loyalty + 16).clamp(0, 100)),
          mood: Value((idol.mood + 6).clamp(0, 100)),
        ));
      }
      await _applyEffect(ev.careerId, ev.groupId, EventEffect(money: -signingBonus));
      outcome =
          '$name\'i tuttunuz! Peşin imza primi -$signingBonus₺ ve aylık maaşına kalıcı +$raise₺ zam yapıldı.';
    } else {
      outcome = '$name elinizde kaldı.';
    }
    await (db.update(db.events)..where((t) => t.id.equals(ev.id))).write(
      EventsCompanion(
        resolved: const Value(true),
        resolutionChoice: const Value('Maaşına büyük zam yap'),
        resolutionOutcome: Value(outcome),
      ),
    );
  }

  Future<void> _adjustPairChem(int a, int b, int delta) async {
    final lo = a < b ? a : b;
    final hi = a < b ? b : a;
    final rel = await (db.select(db.chemistryRelations)
          ..where((t) => t.idolAId.equals(lo) & t.idolBId.equals(hi))
          ..limit(1))
        .getSingleOrNull();
    if (rel == null) return;
    await (db.update(db.chemistryRelations)..where((t) => t.id.equals(rel.id)))
        .write(ChemistryRelationsCompanion(
            chemistryScore: Value((rel.chemistryScore + delta).clamp(-100, 100))));
  }

  Future<void> _adjustMoodPair(int a, int b, int delta) async {
    for (final id in [a, b]) {
      final idol = await (db.select(db.playerIdols)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (idol == null) continue;
      await (db.update(db.playerIdols)..where((t) => t.id.equals(id))).write(
          PlayerIdolsCompanion(mood: Value((idol.mood + delta).clamp(0, 100))));
    }
  }

  /// Şöhret+sadakat toplamı düşük olan üyeyi döndürür (kovulacak olan).
  Future<int> _weakerOf(int a, int b) async {
    Future<int> score(int id) async {
      final row = await (db.select(db.playerIdols).join([
        innerJoin(db.generatedCharacters,
            db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
      ])
            ..where(db.playerIdols.id.equals(id)))
          .getSingleOrNull();
      if (row == null) return 0;
      final idol = row.readTable(db.playerIdols);
      final ch = row.readTable(db.generatedCharacters);
      return ch.startingFame + idol.popularityBonus + idol.loyalty;
    }
    return (await score(a)) <= (await score(b)) ? a : b;
  }

  // ── Etki uygulama ───────────────────────────────────────────────────────────
  Future<void> _applyEffect(int careerId, int? groupId, EventEffect e,
      {int? targetIdolId}) async {
    // Para
    if (e.money != 0) {
      final w = await (db.select(db.currencyWallets)
            ..where((t) => t.careerId.equals(careerId)))
          .getSingleOrNull();
      if (w != null) {
        await (db.update(db.currencyWallets)
              ..where((t) => t.careerId.equals(careerId)))
            .write(CurrencyWalletsCompanion(
                fanPoints: Value((w.fanPoints + e.money).clamp(0, 1 << 31))));
      }
      await Ledger.record(db, careerId, 'event',
          e.money > 0 ? 'Olay geliri' : 'Olay gideri', e.money);
    }

    if (groupId == null) return;
    final g = await (db.select(db.groups)..where((t) => t.id.equals(groupId)))
        .getSingleOrNull();
    if (g == null) return;

    // Grup alanları
    await (db.update(db.groups)..where((t) => t.id.equals(groupId))).write(
      GroupsCompanion(
        totalPopularity: Value((g.totalPopularity + e.popularity).clamp(0, 1 << 31)),
        reputation: Value((g.reputation + e.reputation).clamp(0, 100)),
        socialFollowers: Value((g.socialFollowers + e.followers).clamp(0, 1 << 31)),
        scandalHeat: Value((g.scandalHeat + e.scandalHeat).clamp(0, 100)),
      ),
    );

    // Üyeler (moral / sadakat)
    if (e.moodAll != 0 || e.loyaltyAll != 0) {
      final members = await (db.select(db.groupMembers)
            ..where(
                (t) => t.groupId.equals(groupId) & t.leaveMonth.isNull()))
          .get();
      for (final m in members) {
        final idol = await (db.select(db.playerIdols)
              ..where((t) => t.id.equals(m.idolId)))
            .getSingleOrNull();
        if (idol == null) continue;
        await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
            .write(PlayerIdolsCompanion(
          mood: Value((idol.mood + e.moodAll).clamp(0, 100)),
          loyalty: Value((idol.loyalty + e.loyaltyAll).clamp(0, 100)),
        ));
      }
    }

    // Kimya (tüm çiftler)
    if (e.chemistryAll != 0) {
      final members = await (db.select(db.groupMembers)
            ..where(
                (t) => t.groupId.equals(groupId) & t.leaveMonth.isNull()))
          .get();
      final ids = members.map((m) => m.idolId).toList();
      if (ids.length >= 2) {
        final rels = await (db.select(db.chemistryRelations)
              ..where((t) => t.idolAId.isIn(ids) & t.idolBId.isIn(ids)))
            .get();
        for (final r in rels) {
          await (db.update(db.chemistryRelations)
                ..where((t) => t.id.equals(r.id)))
              .write(ChemistryRelationsCompanion(
                  chemistryScore:
                      Value((r.chemistryScore + e.chemistryAll).clamp(-100, 100))));
        }
      }
    }

    // Hedefli üye etkisi (sadece olayın öznesi olan idol)
    if (targetIdolId != null && (e.moodTarget != 0 || e.loyaltyTarget != 0)) {
      final idol = await (db.select(db.playerIdols)
            ..where((t) => t.id.equals(targetIdolId)))
          .getSingleOrNull();
      if (idol != null) {
        await (db.update(db.playerIdols)..where((t) => t.id.equals(idol.id)))
            .write(PlayerIdolsCompanion(
          mood: Value((idol.mood + e.moodTarget).clamp(0, 100)),
          loyalty: Value((idol.loyalty + e.loyaltyTarget).clamp(0, 100)),
        ));
      }
    }
  }

  // Rastgele aktif grup üyesi (hedefli olaylar için)
  Future<({int idolId, String name})?> _pickRandomMember(int groupId) async {
    final rows = await (db.select(db.groupMembers).join([
      innerJoin(
          db.playerIdols, db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.groupMembers.groupId.equals(groupId) &
              db.groupMembers.leaveMonth.isNull()))
        .get();
    if (rows.isEmpty) return null;
    final pick = rows[_rng.nextInt(rows.length)];
    return (
      idolId: pick.readTable(db.playerIdols).id,
      name: pick.readTable(db.generatedCharacters).name,
    );
  }

  String _render(String text, String? name) =>
      name == null ? text : text.replaceAll('{name}', name);

  // Rakip grubun üye isimleri (dalaşma olayları için)
  static const List<String> rivalMemberNames = [
    'Selin', 'Derin', 'Yağmur', 'Buse', 'Melis'
  ];
  String _randomRivalMember() =>
      rivalMemberNames[_rng.nextInt(rivalMemberNames.length)];

  // ── Bağlam + seçim ──────────────────────────────────────────────────────────
  Future<_EventContext> _buildContext(
      int careerId, Group? group, int month) async {
    double avgN = 50, avgA = 50, avgO = 50, avgE = 50, avgMood = 70, avgFatigue = 0;
    int chemAvg = 0;
    int rivalPop = 0;

    if (group != null) {
      final rows = await (db.select(db.groupMembers).join([
        innerJoin(db.playerIdols,
            db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
        innerJoin(db.generatedCharacters,
            db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
      ])
            ..where(db.groupMembers.groupId.equals(group.id) &
                db.groupMembers.leaveMonth.isNull()))
          .get();

      if (rows.isNotEmpty) {
        double n = 0, a = 0, o = 0, e = 0, mood = 0, fat = 0;
        final ids = <int>[];
        for (final row in rows) {
          final ch = row.readTable(db.generatedCharacters);
          final idol = row.readTable(db.playerIdols);
          n += ch.neuroticism;
          a += ch.agreeableness;
          o += ch.openness;
          e += ch.extraversion;
          mood += idol.mood;
          fat += idol.fatigue;
          ids.add(idol.id);
        }
        final len = rows.length;
        avgN = n / len; avgA = a / len; avgO = o / len; avgE = e / len;
        avgMood = mood / len;
        avgFatigue = fat / len;

        if (ids.length >= 2) {
          final rels = await (db.select(db.chemistryRelations)
                ..where((t) => t.idolAId.isIn(ids) & t.idolBId.isIn(ids)))
              .get();
          final pairs = ids.length * (ids.length - 1) ~/ 2;
          chemAvg = rels.isEmpty
              ? 0
              : (rels.fold<int>(0, (s, r) => s + r.chemistryScore) / pairs).round();
        }
      }

      // rakip popülaritesi (kabaca)
      final rival = await (db.select(db.rivals)..limit(1)).getSingleOrNull();
      if (rival != null) {
        final stones = await (db.select(db.rivalMilestones)
              ..where((t) => t.rivalId.equals(rival.id))
              ..orderBy([(t) => OrderingTerm(expression: t.month)]))
            .get();
        if (stones.isNotEmpty) rivalPop = stones.last.popularityValue;
      }
    }

    return _EventContext(
      hasGroup: group != null,
      avgNeuroticism: avgN,
      avgAgreeableness: avgA,
      avgOpenness: avgO,
      avgExtraversion: avgE,
      avgMood: avgMood,
      avgFatigue: avgFatigue,
      chemAvg: chemAvg,
      scandalHeat: group?.scandalHeat ?? 0,
      reputation: group?.reputation ?? 50,
      popularity: group?.totalPopularity ?? 0,
      rivalPop: rivalPop,
    );
  }

  EventTemplate? _pickDecisionEvent(_EventContext ctx) {
    if (!ctx.hasGroup) {
      // Pre-debut: sadece şirket olayları (sponsorluk artık ayrı sistemde)
      return _weightedPick({
        'company_poach': 1.0,
      });
    }
    final weights = <String, double>{
      // company_sponsorship KALDIRILDI — sponsorluk Sosyal sekmesindeki
      // 3-teklifli özel sistemle yönetiliyor (çift sistem karışıklığı önlendi).
      'company_poach': 0.8,
      'rival_diss': 1.0,
      'rival_collab': 0.8,
      'rival_chart_battle': 0.7,
      'social_fan_outrage': ctx.scandalHeat > 30 ? 1.6 : 0.5,
      'social_paparazzi': 0.7,
      // Hedefli (üye bazlı) karar olayları
      'target_magazine': ctx.avgNeuroticism > 50 ? 1.4 : 0.9,
      'target_solo_offer': ctx.avgExtraversion > 55 ? 1.2 : 0.7,
      'target_rival_diss': 1.1,
      // YÜKSEK RİSKLİ SKANDALLAR — nevrotiklik/skandal ısısı yükseldikçe artar
      'scandal_major': ctx.avgNeuroticism > 55 ? 1.6 : 0.7,
      'scandal_contract_leak': ctx.scandalHeat > 25 ? 1.4 : 0.5,
      'scandal_member_meltdown': ctx.avgNeuroticism > 60 || ctx.avgMood < 50 || ctx.avgFatigue > 65 ? 1.7 : 0.4,
      // RAKİP ÜYELERİYLE BİREYSEL DALAŞMALAR (Cluster ④)
      'rival_member_shade': 1.2,
      'rival_member_dating': ctx.avgExtraversion > 50 ? 1.1 : 0.6,
      'rival_battle': 1.0,
      // rodez_diss rastgele DEĞİL — _maybeGenerateRodezFeud ile 6 ayda bir tetiklenir
    };
    // Big5'e bağlı grup içi olaylar
    weights['intra_conflict'] = ctx.avgAgreeableness < 45 || ctx.chemAvg < 0 ? 1.8 : 0.6;
    weights['intra_creative'] = ctx.avgOpenness > 60 ? 1.4 : 0.6;
    weights['intra_dating'] = ctx.avgExtraversion > 60 ? 1.2 : 0.5;
    weights['intra_burnout'] =
        ctx.avgMood < 55 || ctx.avgFatigue > 60 ? 1.8 : 0.4;
    return _weightedPick(weights);
  }

  EventTemplate? _pickAutoEvent(_EventContext ctx) {
    final weights = <String, double>{
      'auto_viral': ctx.avgExtraversion > 55 ? 1.2 : 0.7,
      'auto_fan_gift': ctx.reputation > 55 ? 1.0 : 0.5,
      'auto_radio_play': 0.9,
      // SKANDAL/DEDİKODU ağırlıkları YÜKSELTİLDİ (bol bol skandal)
      'auto_minor_gossip': ctx.avgNeuroticism > 50 ? 2.2 : 1.4,
      'auto_member_gossip': ctx.avgNeuroticism > 50 ? 2.4 : 1.5,
      'auto_member_scandal_remark': 1.8,
      // Hedefli olumlu
      'auto_member_praised': ctx.reputation > 50 ? 1.0 : 0.6,
    };
    if (ctx.rivalPop > 0) {
      // Rakip bizim hakkımızda konuşur
      weights['auto_rival_talks'] = 1.0;
    }
    if (ctx.popularity > ctx.rivalPop * 0.5 && ctx.rivalPop > 0) {
      weights['auto_award_buzz'] = 1.0;
    }
    return _weightedPick(weights);
  }

  EventTemplate? _weightedPick(Map<String, double> weights) {
    final entries = weights.entries.where((e) => _byKey.containsKey(e.key)).toList();
    if (entries.isEmpty) return null;
    final total = entries.fold<double>(0, (s, e) => s + e.value);
    double roll = _rng.nextDouble() * total;
    for (final e in entries) {
      if (roll < e.value) return _byKey[e.key];
      roll -= e.value;
    }
    return _byKey[entries.last.key];
  }

  // ── Haber kompozisyonu ──────────────────────────────────────────────────────
  (String, String) _composeNews(_EventContext ctx, Group g) {
    if (g.scandalHeat > 50) {
      return ('📰 Magazin: "${g.groupName} hakkında sular durulmuyor"',
          'Sosyal medyada grup hakkındaki tartışmalar gündemdeki yerini koruyor. İtibar: ${g.reputation}/100');
    }
    if (ctx.rivalPop > 0 && g.totalPopularity >= ctx.rivalPop) {
      return ('📰 Manşet: "${g.groupName} zirveyi devraldı!"',
          'Müzik basını ${g.groupName} grubunu yılın çıkışı olarak gösteriyor.');
    }
    if (g.reputation >= 70) {
      return ('📰 Eleştirmen: "${g.groupName} sahnede olgunlaşıyor"',
          'Profesyonel duruşları ve fan ilişkileri övgü topluyor. Takipçi: ${_fmt(g.socialFollowers)}');
    }
    if (g.totalPopularity > 0) {
      return ('📰 Haftalık bülten: "${g.groupName} istikrarlı"',
          'Grup adımlarını sağlam atıyor. Erişim: ${_fmt(g.totalPopularity)}, takipçi: ${_fmt(g.socialFollowers)}');
    }
    return ('📰 "${g.groupName} sahneye hazırlanıyor"',
        'Yeni grup için ilk sinyaller geliyor.');
  }

  // ── Yardımcılar ─────────────────────────────────────────────────────────────
  Future<int> _pendingDecisionCount(int careerId) async {
    final rows = await (db.select(db.events)
          ..where((t) =>
              t.careerId.equals(careerId) &
              t.requiresDecision.equals(true) &
              t.resolved.equals(false)))
        .get();
    return rows.length;
  }

  /// Olayı ekler ve render edilmiş BAŞLIĞI döndürür (snackbar için).
  Future<String> _insertEvent(
      int careerId, int? groupId, EventTemplate t, int month,
      {required bool resolved,
      String? outcome,
      String? targetName,
      int? targetIdolId}) async {
    // Hedefli olaysa üyeyi şimdi seç (karar olayları için targetName gelmez)
    int? affectedIdol = targetIdolId;
    String? name = targetName;
    if (t.targeted && affectedIdol == null && groupId != null) {
      final picked = await _pickRandomMember(groupId);
      affectedIdol = picked?.idolId;
      name = picked?.name;
    }

    // {rival} adı olay için BİR KEZ seçilir (başlık ve açıklamada aynı olsun)
    final rivalName = _randomRivalMember();
    String render(String s) {
      var out = _render(s, name);
      if (out.contains('{rival}')) {
        out = out.replaceAll('{rival}', rivalName);
      }
      return out;
    }

    final renderedTitle = render(t.title);
    final eventId = await db.into(db.events).insert(EventsCompanion.insert(
          careerId: careerId,
          groupId: Value(groupId),
          eventType: t.key,
          category: Value(t.category),
          title: renderedTitle,
          description: Value(render(t.description)),
          monthOccurred: month,
          requiresDecision: Value(t.requiresDecision),
          resolved: Value(resolved),
          resolutionOutcome: Value(outcome),
        ));

    if (affectedIdol != null) {
      await db.into(db.eventAffectedIdols).insert(
            EventAffectedIdolsCompanion.insert(
              eventId: eventId,
              idolId: affectedIdol,
            ),
          );
    }
    return renderedTitle;
  }

  String _describeEffect(EventEffect e) {
    final parts = e.badges.map((b) => b.text).toList();
    return parts.isEmpty ? '' : parts.join('  •  ');
  }

  static String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return '$n';
  }

  // ════════════════════════════════════════════════════════════════════════════
  //  OLAY KATALOĞU
  // ════════════════════════════════════════════════════════════════════════════
  static const List<EventTemplate> _catalog = [
    // ─── GRUP İÇİ ───────────────────────────────────────────────────────────
    EventTemplate(
      key: 'intra_conflict',
      category: 'intra_group',
      title: 'Üyeler Arasında Gerginlik',
      description:
          'Prova sırasında iki üye sahne düzeni yüzünden tartıştı. Atmosfer gergin.',
      choices: [
        EventChoice('Arabuluculuk yap',
            'Sakin bir konuşmayla tarafları yakınlaştırdın. Bağlar onarıldı.',
            EventEffect(chemistryAll: 6, moodAll: 3, loyaltyAll: 2)),
        EventChoice('Bir tarafı tut',
            'Net durdun ama diğer taraf küstü. Kararlılık bazılarınca takdir edildi.',
            EventEffect(chemistryAll: -5, moodAll: -3, reputation: 2)),
        EventChoice('Görmezden gel',
            'Sorun büyümeden dağıldı ama altta bir kırgınlık kaldı.',
            EventEffect(chemistryAll: -3, moodAll: -1)),
      ],
    ),
    EventTemplate(
      key: 'intra_creative',
      category: 'intra_group',
      title: 'Yaratıcı Anlaşmazlık',
      description:
          'Bir üye gruba çok daha deneysel bir konsept öneriyor. Diğerleri tereddütlü.',
      choices: [
        EventChoice('Deneyselliği destekle',
            'Risk aldınız; basın "cesur" diye yazdı. Takipçi arttı.',
            EventEffect(reputation: 4, followers: 12000, popularity: 40000, chemistryAll: 3)),
        EventChoice('Güvenli yolu seç',
            'Bilindik formülde kaldınız. İstikrarlı ama heyecansız.',
            EventEffect(moodAll: -2, reputation: 1)),
        EventChoice('Uzlaşı bul',
            'İkisini harmanladınız. Herkes biraz tatmin oldu.',
            EventEffect(chemistryAll: 4, moodAll: 2)),
      ],
    ),
    EventTemplate(
      key: 'intra_dating',
      category: 'intra_group',
      title: 'Aşk Söylentisi',
      description:
          'Bir üyenin ünlü biriyle görüldüğü iddia ediliyor. Fanlar ikiye bölündü.',
      choices: [
        EventChoice('Yalanla',
            'Şirket sert bir açıklama yaptı. Konu kapandı ama bazı fanlar kuşkulu.',
            EventEffect(scandalHeat: -10, reputation: 2, followers: -3000)),
        EventChoice('Doğrula ve sahip çık',
            'Samimiyet bazı fanları büyüledi, bazılarını üzdü.',
            EventEffect(followers: 15000, scandalHeat: 10, moodAll: 4)),
        EventChoice('Sessiz kal',
            'Gizem korundu, dedikodu kendiliğinden söndü.',
            EventEffect(scandalHeat: 5, followers: 4000)),
      ],
    ),
    EventTemplate(
      key: 'intra_burnout',
      category: 'intra_group',
      title: 'Tükenmişlik Sinyali',
      description:
          'Yoğun tempo üyeleri yıprattı. Bir üye kısa bir mola istiyor.',
      choices: [
        EventChoice('Mola ver',
            'Dinlenen ekip tazelendi; moral ve sadakat yükseldi.',
            EventEffect(money: -1500, moodAll: 10, loyaltyAll: 6, popularity: -20000)),
        EventChoice('Programa devam',
            'Tempoyu korudunuz ama yorgunluk moralleri düşürdü.',
            EventEffect(moodAll: -8, loyaltyAll: -4, scandalHeat: 5)),
      ],
    ),

    // ─── ŞİRKET ─────────────────────────────────────────────────────────────
    EventTemplate(
      key: 'company_sponsorship',
      category: 'company',
      title: 'Sponsorluk Teklifi',
      description:
          'Bir kozmetik markası grupla anlaşmak istiyor. Cazip bir bütçe sunuyorlar.',
      choices: [
        EventChoice('Anlaşmayı kabul et',
            'Kasaya ciddi gelir girdi; ama "fazla ticari" eleştirisi de geldi.',
            EventEffect(money: 4000, reputation: -4, followers: 6000)),
        EventChoice('Pazarlık et',
            'Daha dengeli bir anlaşma yaptınız. İmaj korundu.',
            EventEffect(money: 2500, reputation: 1, followers: 3000)),
        EventChoice('Reddet',
            'Bağımsız imajınızı korudunuz; eleştirmenler beğendi.',
            EventEffect(reputation: 5, money: 0)),
      ],
    ),
    EventTemplate(
      key: 'company_poach',
      category: 'company',
      title: 'Transfer Girişimi: {name}',
      description:
          'Rakip bir şirket {name}\'e göz dikti, daha iyi koşullar vaat ediyor. '
          'Görmezden gelirsen {name} ayrılabilir!',
      targeted: true,
      choices: [
        EventChoice('Maaşına büyük zam yap',
            '{name} elinizde kaldı ama artık aylık maaşı kalıcı olarak yükseldi.',
            EventEffect()), // özel: _resolvePoachRaise
        EventChoice('Menajer ikna etsin',
            '{name} grup arkadaşlarıyla arası iyiyse kalır, kötüyse yine de gider.',
            EventEffect()), // özel: _resolvePoachPersuade
        EventChoice('Umursama',
            'Riski görmezden geldin; {name} rakip şirkete transfer oldu!',
            EventEffect()),
      ],
    ),

    // ─── RAKİP ──────────────────────────────────────────────────────────────
    EventTemplate(
      key: 'rival_diss',
      category: 'rival',
      title: 'Rakipten İğneleme',
      description:
          'Rakip grup bir röportajda size üstü kapalı laf attı. Basın tepkinizi bekliyor.',
      choices: [
        EventChoice('Sahnede cevap ver',
            'Güçlü bir performansla cevap verdiniz; fanlar coştu.',
            EventEffect(popularity: 80000, followers: 18000, reputation: 3)),
        EventChoice('Sosyal medyadan tartış',
            'Atışma viral oldu ama bir kısmı çirkinleşti.',
            EventEffect(followers: 25000, scandalHeat: 15, reputation: -3)),
        EventChoice('Sınıfını koru, sus',
            'Olgun duruşunuz eleştirmenlerce takdir edildi.',
            EventEffect(reputation: 6, popularity: 10000)),
      ],
    ),
    EventTemplate(
      key: 'rival_collab',
      category: 'rival',
      title: 'Düet Teklifi',
      description:
          'Rakip grup ortak bir single önerdi. Risk de var, fırsat da.',
      choices: [
        EventChoice('Düete katıl',
            'İki fan kitlesi birleşti; büyük çıkış oldu.',
            EventEffect(popularity: 150000, followers: 40000, reputation: 4)),
        EventChoice('Kibarca reddet',
            'Bağımsızlığınızı korudunuz; sürpriz bir saygı kazandınız.',
            EventEffect(reputation: 3)),
      ],
    ),
    EventTemplate(
      key: 'rival_chart_battle',
      category: 'rival',
      title: 'Aynı Hafta Çıkış',
      description:
          'Rakip grup sizinle aynı hafta single çıkarıyor. Doğrudan kapışma kaçınılmaz.',
      choices: [
        EventChoice('Tarihte kal, kapış',
            'Riski göze aldınız ve listede öne geçtiniz!',
            EventEffect(popularity: 120000, followers: 20000, reputation: 5)),
        EventChoice('Çıkışı ertele',
            'Çakışmayı önlediniz; güvenli ama momentum kırıldı.',
            EventEffect(popularity: -15000, moodAll: -2)),
      ],
    ),

    // ─── SOSYAL MEDYA (karar) ─────────────────────────────────────────────────
    EventTemplate(
      key: 'social_fan_outrage',
      category: 'social',
      title: 'Fan Tepkisi',
      description:
          'Bir paylaşım yanlış anlaşıldı ve fanların bir kısmı tepkili.',
      choices: [
        EventChoice('Özür açıklaması yap',
            'Hızlı ve içten özür krizi yatıştırdı.',
            EventEffect(scandalHeat: -25, reputation: 4, followers: -2000)),
        EventChoice('Açıkla ve savun',
            'Niyetinizi anlattınız; bir kısmı ikna oldu.',
            EventEffect(scandalHeat: -10, reputation: 1)),
        EventChoice('Görmezden gel',
            'Tepki kısa sürede söndü ama iz bıraktı.',
            EventEffect(scandalHeat: 5, reputation: -3, followers: -5000)),
      ],
    ),
    EventTemplate(
      key: 'social_paparazzi',
      category: 'social',
      title: 'Paparazzi Kareleri',
      description:
          'Üyelerin günlük hayatından samimi kareler basına düştü.',
      choices: [
        EventChoice('PR açıklaması yap',
            'Durumu kontrollü yönettiniz; merak ilgiye döndü.',
            EventEffect(followers: 8000, reputation: 2)),
        EventChoice('Umursama',
            'Görmezden geldiniz; bazıları olumlu, bazıları olumsuz baktı.',
            EventEffect(followers: 3000, scandalHeat: 5)),
      ],
    ),

    // ─── OTOMATİK / AKIŞ ──────────────────────────────────────────────────────
    EventTemplate(
      key: 'auto_viral',
      category: 'social',
      title: 'Bir Klip Viral Oldu!',
      description: 'Sahne arkası bir an internette hızla yayıldı.',
      autoEffect: EventEffect(followers: 20000, popularity: 50000, moodAll: 3),
    ),
    EventTemplate(
      key: 'auto_fan_gift',
      category: 'social',
      title: 'Fanlardan Sürpriz',
      description: 'Hayran kulübü gruba destek kampanyası başlattı.',
      autoEffect: EventEffect(followers: 8000, reputation: 3, moodAll: 4, loyaltyAll: 2),
    ),
    EventTemplate(
      key: 'auto_minor_gossip',
      category: 'social',
      title: 'Küçük Bir Dedikodu',
      description: 'Magazin köşelerinde adınız geçti, önemli bir şey değil.',
      autoEffect: EventEffect(scandalHeat: 8, followers: 2000),
    ),
    EventTemplate(
      key: 'auto_radio_play',
      category: 'pr',
      title: 'Radyo Çalım Listesi',
      description: 'Şarkılarınız ulusal radyolarda dönmeye başladı.',
      autoEffect: EventEffect(popularity: 30000, followers: 5000),
    ),
    EventTemplate(
      key: 'auto_award_buzz',
      category: 'pr',
      title: 'Ödül Konuşmaları',
      description: 'Müzik ödülleri için adınız anılmaya başlandı.',
      autoEffect: EventEffect(reputation: 5, popularity: 60000, followers: 10000, moodAll: 4),
    ),

    // ─── HEDEFLİ OTOMATİK (üye bazlı) ─────────────────────────────────────────
    EventTemplate(
      key: 'auto_member_praised',
      category: 'social',
      title: '{name} Övgü Topladı',
      description:
          '{name} bir sahnedeki performansıyla sosyal medyada öne çıktı.',
      targeted: true,
      autoEffect: EventEffect(
          followers: 9000, reputation: 2, popularity: 25000, moodTarget: 8),
    ),
    EventTemplate(
      key: 'auto_member_gossip',
      category: 'social',
      title: '{name} Hakkında Dedikodu',
      description:
          '{name} ile ilgili asılsız bir iddia magazin gündemine düştü.',
      targeted: true,
      autoEffect: EventEffect(scandalHeat: 12, moodTarget: -8, followers: 2000),
    ),
    EventTemplate(
      key: 'auto_member_scandal_remark',
      category: 'social',
      title: '{name}\'in Açıklaması Olay Oldu',
      description:
          '{name}\'in bir röportajdaki sözleri yanlış anlaşıldı ve sosyal medyada büyük tepki çekti.',
      targeted: true,
      autoEffect: EventEffect(
          scandalHeat: 20, reputation: -4, moodTarget: -6, followers: -3000),
    ),
    EventTemplate(
      key: 'auto_rival_talks',
      category: 'rival',
      title: 'Rakip Grup Hakkımızda Konuştu',
      description:
          'Rakip grup bir röportajda sizi rakip olarak gördüğünü söyledi. Bu, gözlerin size çevrilmesini sağladı.',
      autoEffect: EventEffect(popularity: 35000, followers: 6000, reputation: 2),
    ),

    // ─── HEDEFLİ KARAR (üye bazlı) ────────────────────────────────────────────
    EventTemplate(
      key: 'target_magazine',
      category: 'social',
      title: '{name} Magazine Yakalandı',
      description:
          '{name} gece bir mekândan çıkarken görüntülendi. Haber hızla yayılıyor.',
      targeted: true,
      choices: [
        EventChoice('Şeffaf açıklama yap',
            'Dürüst tavır takdir gördü; {name} rahatladı.',
            EventEffect(reputation: 3, scandalHeat: -8, moodTarget: 4)),
        EventChoice('Avukatla bastır',
            'Haber kaldırıldı ama "kapatma" söylentisi çıktı.',
            EventEffect(money: -1500, scandalHeat: 5, followers: -2000)),
        EventChoice('Görmezden gel',
            'Konu büyüdü; {name} bu durumdan etkilendi.',
            EventEffect(scandalHeat: 15, moodTarget: -10, loyaltyTarget: -4)),
      ],
    ),
    EventTemplate(
      key: 'target_solo_offer',
      category: 'company',
      title: '{name}\'e Solo Teklifi',
      description:
          '{name} bir yapımcıdan solo proje teklifi aldı. Karar grup dengesini etkileyebilir.',
      targeted: true,
      choices: [
        EventChoice('Solo projeye izin ver',
            '{name} solo sahneye çıktı! Magazin çalkalandı, fandom ikiye bölündü, grup içi kıskançlık tavan yaptı.',
            EventEffect()), // özel: _resolveSoloOffer (büyük skandal + fan tepkisi)
        EventChoice('Grup önceliği, reddet',
            '{name} bu karara çok kırıldı; sana küstü, sahnede isteksiz ve düşük performans gösteriyor.',
            EventEffect(
                chemistryAll: 4,
                moodAll: 1,
                moodTarget: -20,
                loyaltyTarget: -18)),
      ],
    ),
    EventTemplate(
      key: 'target_rival_diss',
      category: 'rival',
      title: 'Rakipten {name}\'e Gönderme',
      description:
          'Rakip grubun bir üyesi, {name}\'i hedef alan imalı bir paylaşım yaptı.',
      targeted: true,
      choices: [
        EventChoice('{name} sahnede cevap versin',
            '{name} güçlü bir karşılık verdi; fanlar arkasında durdu.',
            EventEffect(popularity: 60000, followers: 15000, moodTarget: 6)),
        EventChoice('Diplomatik açıklama',
            'Olgun duruş itibar kazandırdı.',
            EventEffect(reputation: 5, popularity: 8000)),
        EventChoice('Sosyal medyada atış',
            'Atışma viral oldu ama çirkinleşti; {name} yıprandı.',
            EventEffect(
                followers: 22000, scandalHeat: 15, reputation: -4, moodTarget: -5)),
      ],
    ),

    // ─── RAKİP ÜYELERİYLE BİREYSEL DALAŞMALAR (Cluster ④) ─────────────────────
    EventTemplate(
      key: 'rival_member_shade',
      category: 'rival',
      title: 'Rakipten {name}\'e Laf: {rival}',
      description:
          'Rakip grubun üyesi {rival}, bir yayında {name}\'i küçümseyen sözler söyledi. Fanlar tepkinizi bekliyor.',
      targeted: true,
      choices: [
        EventChoice('{name} sahnede rövanşı alsın',
            '{name} sahnede rakibe fark attı; fanlar çıldırdı.',
            EventEffect(popularity: 55000, followers: 16000, moodTarget: 6)),
        EventChoice('Sınıf farkı koy, görmezden gel',
            'Olgun duruşunuz itibar kazandırdı.',
            EventEffect(reputation: 6, popularity: 10000)),
        EventChoice('Sosyal medyada it dalaşı',
            'Atışma viral oldu ama çirkinleşti; {name} yıprandı.',
            EventEffect(
                followers: 24000, scandalHeat: 16, reputation: -5, moodTarget: -6)),
      ],
    ),
    EventTemplate(
      key: 'rival_member_dating',
      category: 'rival',
      title: 'Yasak Aşk: {name} & {rival}',
      description:
          '{name} ile rakip gruptan {rival}\'in gizlice görüştüğü iddia ediliyor. İki hayran kitlesi de karıştı.',
      targeted: true,
      choices: [
        EventChoice('İlişkiyi sahiplen',
            'Romantik hikâye gündem oldu; ilgi patladı ama riskli.',
            EventEffect(
                followers: 26000, popularity: 30000, scandalHeat: 18, moodTarget: 4)),
        EventChoice('Kesin dille yalanla',
            'Şirket açıklaması konuyu kapattı.',
            EventEffect(scandalHeat: -8, reputation: 2, followers: -3000)),
      ],
    ),
    EventTemplate(
      key: 'rodez_diss',
      category: 'rival',
      title: 'Rodez Diss Attı! 🎤🔥',
      description:
          '"Rodez" mahlaslı rapçi, yeni parçasında grubuna açık göndermeler yaptı. Sosyal medya ikiye bölündü, herkes tepkini bekliyor.',
      choices: [
        EventChoice('Görmezden gel',
            'Üstüne gitmedin. Olay birkaç günde söndü; ciddiye almaman olgun bir duruş olarak görüldü.',
            EventEffect(reputation: 3, scandalHeat: -4, followers: -1500)),
        EventChoice('Diss ile karşılık ver',
            'Grup bir cevap parçası yayınladı! Gündemin zirvesine oturdunuz, fanlar coştu ama tartışma da büyüdü.',
            EventEffect(
                followers: 22000, popularity: 60000, scandalHeat: 15, reputation: -2)),
        EventChoice('Avukata havale et',
            'Hukuk ekibi devreye girdi. Avukat ücreti kasadan çıktı ama mesele resmileşti.',
            EventEffect(money: -8000, scandalHeat: 6, reputation: -1, followers: 3000)),
      ],
    ),
    EventTemplate(
      key: 'morale_quit_threat',
      category: 'intra_group',
      title: '💔 {name} Ayrılmak İstiyor',
      description:
          '{name} artık devam etmek istemediğini söyledi; morali tükenmiş. '
          'Onu tutmak istiyorsan ağır koşulları kabul etmen gerekecek.',
      targeted: true,
      choices: [
        EventChoice('Ağır koşulları kabul et, tut',
            '{name} büyük zam ve ayrıcalıklarla ikna oldu; kaldı ama bu pahalıya patladı.',
            EventEffect()), // özel: _resolveMoraleQuit (keep)
        EventChoice('Bırak gitsin',
            '{name} grubu terk etti; fanlar üzüldü.',
            EventEffect()), // özel: _resolveMoraleQuit (leave)
      ],
    ),
    EventTemplate(
      key: 'rodez_final',
      category: 'rival',
      title: '🎤 Rodez Son Bir Gönderme Yaptı',
      description:
          'Rodez bir kez daha grubuna laf attı ama bu sefer pek ses getirmedi. Artık kimse bu husumeti ciddiye almıyor — görmezden gelmek en olgun yol.',
      choices: [
        EventChoice('Görmezden gel, kapat',
            'Hiç oralı olmadın. Rodez husumeti böylece sönüp gitti; sen yükselişine odaklandın.',
            EventEffect(reputation: 3, scandalHeat: -5)),
      ],
    ),
    EventTemplate(
      key: 'megastar_duet',
      category: 'pr',
      title: '🌟 Megastar Düet Teklif Etti!',
      description:
          'Ülkenin en büyük yıldızı grubunuzla bir düet yapmak istiyor! Bu, kariyerinizi bambaşka bir yere taşıyabilir. Teklifi kabul ediyor musun?',
      choices: [
        EventChoice('Kabul et — düete çık',
            'Megastarla düet bomba gibi patladı! Diskografinize girdi, takipçi ve erişim uçtu.',
            EventEffect()), // özel: _resolveMegastarDuet
        EventChoice('Reddet, bağımsız kal',
            'Teklifi nazikçe geri çevirdin. Sürpriz bir saygı kazandınız ama büyük bir fırsat kaçtı.',
            EventEffect(reputation: 4, followers: -5000)),
      ],
    ),
    EventTemplate(
      key: 'rival_battle',
      category: 'rival',
      title: 'Düello Daveti: {rival} → {name}',
      description:
          'Rakip üye {rival}, {name}\'i canlı bir yetenek düellosuna çağırdı. Kazanırsanız büyük çıkış; kaybederseniz prestij kaybı.',
      targeted: true,
      choices: [
        EventChoice('Meydan okumayı kabul et', 'Düello sahnede gerçekleşti...',
            EventEffect()),
        EventChoice('Reddet',
            '{name} düelloya girmedi; bazı fanlar hayal kırıklığına uğradı.',
            EventEffect()),
      ],
    ),

    // ─── ÇATIŞMA KRİZİ (özel üretim/çözüm; _resolveConflict işler) ────────────
    EventTemplate(
      key: 'conflict_crisis',
      category: 'intra_group',
      title: '🔥 {name1} ve {name2} Çatışıyor',
      description:
          '{name1} ile {name2} arasındaki gerginlik dayanılmaz hale geldi. '
          'Diğer üyeler de huzursuz. Bir karar vermelisin.',
      choices: [
        EventChoice('Profesyonel arabuluculuk',
            'Uzman bir danışman tutarsın; maliyeti grubun büyüklüğüyle artar.',
            EventEffect()),
        EventChoice('Sıkı disiplin uygula',
            'İkisini hizaya çekersin; gerginlik azalır ama moraller düşer.',
            EventEffect(moodAll: -5, loyaltyAll: -3)),
        EventChoice('Zayıf üyeyi gruptan çıkar',
            'Sorunu kökten çözersin ama bir üyeyi kaybedersin.',
            EventEffect()),
        EventChoice('Görmezden gel',
            'Sorun çözülmez; gerginlik ve sadakat kaybı sürer.',
            EventEffect(loyaltyAll: -4)),
      ],
    ),

    // ─── YÜKSEK RİSKLİ SKANDALLAR (grubu tehlikeye atabilir) ──────────────────
    EventTemplate(
      key: 'scandal_major',
      category: 'social',
      title: '⚠️ Büyük Skandal: {name}',
      description:
          '{name} hakkında ciddi bir iddia ortaya atıldı ve ana akım medyaya düştü. Tepkiniz grubun geleceğini etkileyebilir.',
      targeted: true,
      choices: [
        EventChoice('Derhal ve içten özür',
            'Hızlı kriz yönetimi hasarı sınırladı ama iz bıraktı.',
            EventEffect(
                scandalHeat: -10,
                reputation: -6,
                popularity: -120000,
                followers: -25000,
                moodTarget: -10)),
        EventChoice('Sertçe yalanla / dava aç',
            'Risk aldınız; kanıt çıkmadı ama "kibirli" algısı oluştu.',
            EventEffect(
                money: -4000,
                scandalHeat: 20,
                reputation: -12,
                popularity: -220000,
                followers: -45000,
                moodTarget: -14,
                loyaltyTarget: -8)),
        EventChoice('Sus, fırtına geçsin',
            'Sessizlik öfkeyi büyüttü; ciddi kayıp yaşandı.',
            EventEffect(
                scandalHeat: 35,
                reputation: -18,
                popularity: -300000,
                followers: -70000,
                moodAll: -8,
                loyaltyTarget: -15)),
      ],
    ),
    EventTemplate(
      key: 'scandal_contract_leak',
      category: 'company',
      title: '⚠️ Sözleşme Sızıntısı',
      description:
          'Grup içi anlaşma detayları sızdı; kamuoyu "adaletsiz" diye tartışıyor. Sadakat tehlikede.',
      choices: [
        EventChoice('Şeffaf ol, koşulları iyileştir',
            'Üyelerin maaşlarını kalıcı olarak yükselttin; güven tazelendi ama aylık gider arttı.',
            EventEffect()), // özel: _resolveContractImprove (kalıcı maaş artışı)
        EventChoice('İnkâr et',
            'Konu kapanmadı; üyeler tedirgin.',
            EventEffect(scandalHeat: 25, reputation: -10, loyaltyAll: -12, moodAll: -6)),
      ],
    ),
    EventTemplate(
      key: 'scandal_member_meltdown',
      category: 'intra_group',
      title: '⚠️ {name} Çöküş Yaşıyor',
      description:
          '{name} baskı altında kötü bir gün geçirdi ve canlı yayında kontrolünü kaybetti. Durum hassas.',
      targeted: true,
      choices: [
        EventChoice('Terapi + mola desteği ver',
            '{name} kendini toparladı; ekip minnettar.',
            EventEffect(
                money: -2500,
                moodTarget: 18,
                loyaltyTarget: 12,
                loyaltyAll: 4,
                popularity: -40000)),
        EventChoice('Sahneye geri it',
            'Zorlamak işleri kötüleştirdi; {name} kırıldı.',
            EventEffect(
                scandalHeat: 25,
                moodTarget: -22,
                loyaltyTarget: -20,
                reputation: -6,
                popularity: -90000)),
      ],
    ),
  ];
}

// ─── Bağlam taşıyıcı ──────────────────────────────────────────────────────────
class _EventContext {
  final bool hasGroup;
  final double avgNeuroticism;
  final double avgAgreeableness;
  final double avgOpenness;
  final double avgExtraversion;
  final double avgMood;
  final double avgFatigue;
  final int chemAvg;
  final int scandalHeat;
  final int reputation;
  final int popularity;
  final int rivalPop;

  _EventContext({
    required this.hasGroup,
    required this.avgNeuroticism,
    required this.avgAgreeableness,
    required this.avgOpenness,
    required this.avgExtraversion,
    required this.avgMood,
    required this.avgFatigue,
    required this.chemAvg,
    required this.scandalHeat,
    required this.reputation,
    required this.popularity,
    required this.rivalPop,
  });
}
