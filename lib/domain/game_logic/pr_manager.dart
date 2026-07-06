// Öğrenci No: 202313171033
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import '../../data/database/app_database.dart';
import 'event_engine.dart';
import 'group_manager.dart';
import 'ledger.dart';

/// Sponsor teklifi şablonu (havuzdan rastgele 3'ü oyuncuya sunulur).
class SponsorOffer {
  final String name;
  final String emoji;
  final int incomeBase; // takipçiyle ölçeklenir
  final int repDelta; // imzalanınca itibar değişimi
  final int loyaltyDelta; // imzalanınca fandom sadakat değişimi
  final String blurb;
  const SponsorOffer({
    required this.name,
    required this.emoji,
    required this.incomeBase,
    required this.repDelta,
    required this.loyaltyDelta,
    required this.blurb,
  });
}

/// Oyuncunun parayla başlatabildiği PR / sosyal medya kampanyaları.
class PRCampaign {
  final String key;
  final String name;
  final String description;
  final int cost;
  final IconData icon;
  final Color color;
  final EventEffect effect;        // başarı durumunda
  final double backfireChance;     // ters tepme ihtimali
  final EventEffect backfireEffect;
  final bool needsScandal;         // sadece skandal varken anlamlı

  const PRCampaign({
    required this.key,
    required this.name,
    required this.description,
    required this.cost,
    required this.icon,
    required this.color,
    required this.effect,
    this.backfireChance = 0.0,
    this.backfireEffect = const EventEffect(),
    this.needsScandal = false,
  });
}

class PRResult {
  final bool success;       // false = yetersiz bütçe
  final bool backfired;
  final String message;
  final EventEffect? applied;
  const PRResult({
    required this.success,
    this.backfired = false,
    required this.message,
    this.applied,
  });
}

class PRManager {
  final AppDatabase db;
  final Random _rng = Random();
  PRManager(this.db);

  static const List<PRCampaign> campaigns = [
    PRCampaign(
      key: 'ad_deal',
      name: 'Reklam Anlaşması',
      description: 'Bir markayla reklam çek. Hızlı gelir ama her seferinde imaj aşınır.',
      cost: 0,
      icon: Icons.handshake,
      color: Colors.green,
      // Gelir düşürüldü + itibar maliyeti arttı: sık yapınca itibar düşer,
      // takipçi/gelir erir (haftalık 2 PR limitiyle birlikte sınırsız para biter).
      effect: EventEffect(money: 5000, followers: 2000, reputation: -5),
      backfireChance: 0.12,
      backfireEffect: EventEffect(money: 2000, reputation: -10, scandalHeat: 10),
    ),
    PRCampaign(
      key: 'fan_meeting',
      name: 'Fan Buluşması',
      description: 'Hayranlarla yüz yüze etkinlik. Sadakat ve itibar yükselir.',
      cost: 1500,
      icon: Icons.groups_2,
      color: Colors.pink,
      effect: EventEffect(followers: 6000, reputation: 5, loyaltyAll: 8, moodAll: 5),
    ),
    PRCampaign(
      key: 'variety_show',
      name: 'Varyete Programı',
      description: 'Popüler bir TV programına çık. Geniş kitleye ulaş.',
      cost: 1000,
      icon: Icons.tv,
      color: Colors.deepPurple,
      effect: EventEffect(followers: 16000, reputation: 6, popularity: 45000),
      backfireChance: 0.15,
      backfireEffect: EventEffect(followers: 5000, reputation: -8, scandalHeat: 12),
    ),
    PRCampaign(
      key: 'social_campaign',
      name: 'Sosyal Medya Kampanyası',
      description: 'Hashtag ve içerik dalgası. Takipçi patlaması hedefler.',
      cost: 2000,
      icon: Icons.tag,
      color: Colors.blue,
      effect: EventEffect(followers: 28000, popularity: 25000),
      backfireChance: 0.08,
      backfireEffect: EventEffect(followers: 6000, scandalHeat: 10),
    ),
    PRCampaign(
      key: 'charity',
      name: 'Hayır İşi / Bağış',
      description: 'Bir sosyal sorumluluk projesi. İtibarı güçlü şekilde artırır.',
      cost: 3000,
      icon: Icons.volunteer_activism,
      color: Colors.teal,
      effect: EventEffect(reputation: 15, followers: 8000, moodAll: 3),
    ),
    PRCampaign(
      key: 'comeback_teaser',
      name: 'İmaj Tazeleme (Teaser)',
      description: 'Yeni konsept fragmanı yayınla. Heyecan ve erişim yarat.',
      cost: 1500,
      icon: Icons.auto_awesome,
      color: Colors.orange,
      effect: EventEffect(popularity: 55000, followers: 10000, moodAll: 2),
    ),
    PRCampaign(
      key: 'crisis_pr',
      name: 'Kriz Yönetimi',
      description: 'Profesyonel PR ekibiyle skandalı söndür. Sadece kriz anında işe yarar.',
      cost: 2500,
      icon: Icons.local_fire_department,
      color: Colors.red,
      effect: EventEffect(scandalHeat: -45, reputation: 8),
      needsScandal: true,
    ),
  ];

  static const int sponsorDurationMonths = 6;
  static const int sponsorFollowerGate = 200000; // ilk sponsor için min takipçi

  /// Havuz: 7 marka şablonu. incomeBase aylık gelir tabanı (takipçiyle ölçeklenir),
  /// repDelta/loyaltyDelta imzalanınca bir kez uygulanır.
  static const List<SponsorOffer> sponsorPool = [
    SponsorOffer(
        name: 'VoltEnerji',
        emoji: '⚡',
        incomeBase: 14000,
        repDelta: -12,
        loyaltyDelta: -6,
        blurb: 'Tartışmalı enerji içeceği. Çok para, ama imaj zedeler.'),
    SponsorOffer(
        name: 'NovaCola',
        emoji: '🥤',
        incomeBase: 10000,
        repDelta: -6,
        loyaltyDelta: -2,
        blurb: 'Dev gazlı içecek markası. Bol para, hafif imaj riski.'),
    SponsorOffer(
        name: 'PixelPhone',
        emoji: '📱',
        incomeBase: 7000,
        repDelta: 0,
        loyaltyDelta: 0,
        blurb: 'Teknoloji devi. Dengeli ve güvenli bir anlaşma.'),
    SponsorOffer(
        name: 'GlowUp Kozmetik',
        emoji: '💄',
        incomeBase: 5500,
        repDelta: 3,
        loyaltyDelta: 4,
        blurb: 'Genç kozmetik markası. Orta gelir, fandom sever.'),
    SponsorOffer(
        name: 'StarSnack',
        emoji: '🍫',
        incomeBase: 4500,
        repDelta: 2,
        loyaltyDelta: 9,
        blurb: 'Fan favorisi atıştırmalık. Az para ama fandom bayılır.'),
    SponsorOffer(
        name: 'Lumina Moda',
        emoji: '👗',
        incomeBase: 3500,
        repDelta: 8,
        loyaltyDelta: 4,
        blurb: 'Prestijli moda evi. Düşük gelir, yüksek itibar.'),
    SponsorOffer(
        name: 'AuraParfüm',
        emoji: '🌸',
        incomeBase: 2500,
        repDelta: 12,
        loyaltyDelta: 5,
        blurb: 'Lüks parfüm markası. Az para, çok itibar prestiji.'),
  ];

  /// Sponsor teklifi alınabilir mi? (200K takipçi + aktif anlaşma yok)
  Future<({bool ok, String reason})> canGetSponsor(int careerId) async {
    final group = await (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
    if (group == null) return (ok: false, reason: 'Önce bir grup kur.');
    if (group.sponsorMonthsLeft > 0) {
      return (
        ok: false,
        reason:
            'Aktif sponsorun var (${group.sponsorName}, ${group.sponsorMonthsLeft} ay kaldı).'
      );
    }
    if (group.socialFollowers < sponsorFollowerGate) {
      return (
        ok: false,
        reason:
            'Sponsor ilgisi için en az ${sponsorFollowerGate ~/ 1000}K takipçi gerekiyor (mevcut: ${group.socialFollowers ~/ 1000}K).'
      );
    }
    return (ok: true, reason: '');
  }

  /// Havuzdan rastgele 3 teklif üretir; gelir takipçiye göre ölçeklenir.
  Future<List<({SponsorOffer offer, int income})>> generateSponsorOffers(
      int careerId) async {
    final group = await (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
    final followers = group?.socialFollowers ?? 0;
    final scale = (followers / sponsorFollowerGate).clamp(1.0, 6.0);
    final pool = [...sponsorPool]..shuffle(_rng);
    return pool.take(3).map((o) {
      final income = (o.incomeBase * scale).round();
      return (offer: o, income: income);
    }).toList();
  }

  /// Seçilen sponsor teklifini imzalar.
  Future<PRResult> signSponsorOffer(
      int careerId, int month, SponsorOffer offer, int income) async {
    final group = await (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
    if (group == null) {
      return const PRResult(success: false, message: 'Önce bir grup kur.');
    }
    if (group.sponsorMonthsLeft > 0) {
      return PRResult(
          success: false,
          message: 'Zaten aktif sponsorun var (${group.sponsorName}).');
    }
    await (db.update(db.groups)..where((t) => t.id.equals(group.id))).write(
      GroupsCompanion(
        sponsorName: Value(offer.name),
        sponsorIncome: Value(income),
        sponsorMonthsLeft: const Value(sponsorDurationMonths),
        reputation: Value((group.reputation + offer.repDelta).clamp(0, 100)),
        fandomLoyalty:
            Value((group.fandomLoyalty + offer.loyaltyDelta).clamp(0, 100)),
      ),
    );
    final repStr = offer.repDelta == 0
        ? ''
        : ' • İtibar ${offer.repDelta > 0 ? "+" : ""}${offer.repDelta}';
    await db.into(db.events).insert(EventsCompanion.insert(
          careerId: careerId,
          groupId: Value(group.id),
          eventType: 'sponsor_signed',
          category: const Value('pr'),
          title: 'Sponsor Anlaşması: ${offer.name} ${offer.emoji}',
          description: Value(
              '${offer.name} ile $sponsorDurationMonths aylık anlaşma! Aylık +$income₺$repStr.'),
          monthOccurred: month,
          resolved: const Value(true),
        ));

    // Fanların sevmediği marka (itibar/sadakat eksisi) → tepki + ekstra sadakat kaybı
    if (offer.repDelta < 0 || offer.loyaltyDelta < 0) {
      await _insertSponsorBacklash(careerId, group, offer);
    }
    return PRResult(
        success: true,
        message:
            '${offer.name} ile anlaştın! $sponsorDurationMonths ay aylık +$income₺$repStr.');
  }

  /// Tartışmalı sponsor → hayranlar 2 tepki twiti atar + ekstra sadakat kaybı.
  Future<void> _insertSponsorBacklash(
      int careerId, Group group, SponsorOffer offer) async {
    final career = await (db.select(db.playerCareers)
          ..where((t) => t.id.equals(careerId)))
        .getSingleOrNull();
    if (career == null) return;
    final fan = group.fandomName ?? 'Hayranlar';
    final absWeek = (career.currentYear - 1) * 48 +
        (career.currentMonth - 1) * 4 +
        career.currentWeek;
    final texts = [
      '${offer.name} ile mi anlaştık?? Bu markayı hiç sevmiyorum, hayal kırıklığı 😞',
      '${offer.name} sponsorluğu cidden gerekli miydi? Fandom olarak rahatsızız.',
      'Para her şey değil... ${offer.name} bize göre bir marka değil 🙄 #boykot',
    ]..shuffle(_rng);
    for (final t in texts.take(2)) {
      await db.into(db.socialPosts).insert(SocialPostsCompanion.insert(
            careerId: careerId,
            absWeek: absWeek,
            postType: 'fan',
            displayName: fan,
            handle: '@${fan.toLowerCase().replaceAll(' ', '_')}',
            content: t,
            avatarEmoji: '💔',
          ));
    }
    // Tartışmalı markayla anlaşmak ekstra sadakat aşındırır
    await (db.update(db.groups)..where((t) => t.id.equals(group.id))).write(
        GroupsCompanion(
            fandomLoyalty: Value((group.fandomLoyalty - 5).clamp(0, 100))));
  }

  /// Kampanyayı çalıştırır. Bütçe yetmezse success=false döner.
  Future<PRResult> runCampaign(int careerId, int month, PRCampaign c) async {
    final group = await (db.select(db.groups)
          ..where((t) =>
              t.careerId.equals(careerId) & t.status.equals('active'))
          ..limit(1))
        .getSingleOrNull();
    if (group == null) {
      return const PRResult(success: false, message: 'Önce bir grup kurmalısın.');
    }

    final wallet = await (db.select(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .getSingleOrNull();
    // Prestij vergisi: büyük grup = pahalı PR
    final costMult = GroupManager.costMultiplierFor(
        group.socialFollowers, group.totalPopularity);
    final cost = (c.cost * costMult).round();
    if (wallet == null || wallet.fanPoints < cost) {
      return PRResult(
          success: false,
          message: 'Yetersiz bütçe. Gerekli: $cost₺, mevcut: ${wallet?.fanPoints ?? 0}₺');
    }

    // Maliyeti düş
    await (db.update(db.currencyWallets)
          ..where((t) => t.careerId.equals(careerId)))
        .write(CurrencyWalletsCompanion(
            fanPoints: Value(wallet.fanPoints - cost)));
    if (cost > 0) {
      await Ledger.record(db, careerId, 'pr', 'PR: ${c.name}', -cost);
    }

    // Başarı mı, ters mi?
    final backfired = _rng.nextDouble() < c.backfireChance;
    final eff = backfired ? c.backfireEffect : c.effect;

    await _applyEffect(careerId, group.id, eff);

    final msg = backfired
        ? '${c.name} ters tepti! ${_describe(eff)}'
        : '${c.name} başarılı! ${_describe(eff)}';

    // Akışa kaydet
    await db.into(db.events).insert(EventsCompanion.insert(
          careerId: careerId,
          groupId: Value(group.id),
          eventType: 'pr_${c.key}',
          category: const Value('pr'),
          title: backfired ? '${c.name} (Ters Tepti)' : c.name,
          description: Value(msg),
          monthOccurred: month,
          impactValue: Value(eff.popularity),
          resolved: const Value(true),
          resolutionOutcome: Value(_describe(eff)),
        ));

    return PRResult(
        success: true, backfired: backfired, message: msg, applied: eff);
  }

  // EventEngine ile aynı mantık (tekrar etmemek için sade kopya).
  Future<void> _applyEffect(int careerId, int groupId, EventEffect e) async {
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
      await Ledger.record(db, careerId, 'pr',
          e.money > 0 ? 'Reklam/PR geliri' : 'PR maliyeti', e.money);
    }

    final g = await (db.select(db.groups)..where((t) => t.id.equals(groupId)))
        .getSingleOrNull();
    if (g == null) return;

    await (db.update(db.groups)..where((t) => t.id.equals(groupId))).write(
      GroupsCompanion(
        totalPopularity: Value((g.totalPopularity + e.popularity).clamp(0, 1 << 31)),
        reputation: Value((g.reputation + e.reputation).clamp(0, 100)),
        socialFollowers: Value((g.socialFollowers + e.followers).clamp(0, 1 << 31)),
        scandalHeat: Value((g.scandalHeat + e.scandalHeat).clamp(0, 100)),
      ),
    );

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
  }

  String _describe(EventEffect e) =>
      e.badges.map((b) => b.text).join('  •  ');
}
