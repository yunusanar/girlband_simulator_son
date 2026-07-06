// Öğrenci No: 202313171033
import 'dart:math';
import 'package:drift/drift.dart';
import '../../data/database/app_database.dart';
import 'group_manager.dart';

/// Sosyal medya gönderileri: her hafta 4 yorum üretip BİRİKTİRİR (silmez).
class SocialManager {
  final AppDatabase db;
  SocialManager(this.db);

  Future<int> _absWeek(int careerId) async {
    final c = await (db.select(db.playerCareers)
          ..where((t) => t.id.equals(careerId)))
        .getSingleOrNull();
    if (c == null) return 0;
    return (c.currentYear - 1) * 48 + (c.currentMonth - 1) * 4 + c.currentWeek;
  }

  Future<({String name, String? img})> _randomMember(int groupId) async {
    final rows = await (db.select(db.groupMembers).join([
      innerJoin(db.playerIdols,
          db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.groupMembers.groupId.equals(groupId) &
              db.groupMembers.leaveMonth.isNull()))
        .get();
    if (rows.isEmpty) return (name: 'Üye', img: null);
    final r = rows[Random().nextInt(rows.length)];
    final ch = r.readTable(db.generatedCharacters);
    return (name: ch.name, img: ch.imagePath);
  }

  Future<void> _insert(int careerId, int absWeek, String type, String name,
      String text, String emoji) async {
    await db.into(db.socialPosts).insert(SocialPostsCompanion.insert(
          careerId: careerId,
          absWeek: absWeek,
          postType: type,
          displayName: name,
          handle: handleFor(name),
          content: text,
          avatarEmoji: emoji,
        ));
  }

  /// Şarkı çıkınca: bir üye + bir hayran twiti atar. Bildirim için 1 başlık döner.
  Future<String?> addSongBuzz(
      int careerId, int groupId, String title, bool isHit, bool flop) async {
    final g = await GroupManager(db).getActiveGroup(careerId);
    if (g == null) return null;
    final absWeek = await _absWeek(careerId);
    final fan = g.fandomName ?? '${g.groupName} Fanları';
    final m = await _randomMember(groupId);

    final memberText = flop
        ? '"$title" için emek verdik, herkesin beğenmesi şart değil 🤍 yine de buradayız'
        : (isHit
            ? '"$title" ÇIKTI ve aklım uçtu! 🎶🔥 sizi çok seviyorum, bu şarkı sizin için'
            : 'Yeni şarkımız "$title" yayında 🎵 dinleyip ne düşündüğünüzü yazın!');
    final fanText = flop
        ? '"$title" bana hitap etmedi açıkçası ama grubuma güveniyorum 🤞'
        : (isHit
            ? '"$title" şarkısını 50 kere dinledim, BU NE BÖYLE 😭💜 #$fan'
            : '"$title" çıkmış! Hadi herkes akışlara koşsun 🏃‍♀️🎶');

    await _insert(careerId, absWeek, 'member', m.name, memberText, '🎤');
    await _insert(careerId, absWeek, 'fan', fan, fanText, '💜');
    return '${handleFor(m.name)}: $memberText';
  }

  /// Debüt duyurusu: grup adına resmi bir gönderi + hayran coşkusu.
  Future<String?> addDebutBuzz(int careerId, int groupId) async {
    final g = await GroupManager(db).getActiveGroup(careerId);
    if (g == null) return null;
    final absWeek = await _absWeek(careerId);
    final fan = g.fandomName ?? '${g.groupName} Fanları';
    await _insert(careerId, absWeek, 'member', g.groupName,
        'BUGÜN RESMEN DEBÜT! 🎉 Bu yolculuk $fan ile başlıyor, hazır mısınız? 💫',
        '🎤');
    await _insert(careerId, absWeek, 'fan', fan,
        '${g.groupName} DEBÜT YAPTI!! 😭🎉 yıllardır bu anı bekliyordum #${g.groupName}',
        '💜');
    return '🎉 ${g.groupName} resmen debüt yaptı! Sosyal medya çalkalanıyor.';
  }

  static String handleFor(String name) =>
      '@${name.toLowerCase().replaceAll(' ', '_').replaceAll('ı', 'i').replaceAll('ş', 's').replaceAll('ç', 'c').replaceAll('ö', 'o').replaceAll('ü', 'u').replaceAll('ğ', 'g')}';

  /// Haftalık gönderileri üretir ve kaydeder (yalnızca debüt sonrası).
  Future<void> generateWeeklyPosts(
      int careerId, int absMonth, int absWeek) async {
    final group = await GroupManager(db).getActiveGroup(careerId);
    if (group == null) return;

    final memberRows = await (db.select(db.groupMembers).join([
      innerJoin(db.playerIdols,
          db.playerIdols.id.equalsExp(db.groupMembers.idolId)),
      innerJoin(db.generatedCharacters,
          db.generatedCharacters.id.equalsExp(db.playerIdols.characterId)),
    ])
          ..where(db.groupMembers.groupId.equals(group.id) &
              db.groupMembers.leaveMonth.isNull()))
        .get();
    final names = memberRows
        .map((r) => r.readTable(db.generatedCharacters).name)
        .toList();
    final rival = await GroupManager(db).rivalStatusAt(absMonth);

    final posts =
        _build(group, names, rival.name, absWeek, careerId, absWeek);
    for (final p in posts) {
      await db.into(db.socialPosts).insert(p);
    }
  }

  List<SocialPostsCompanion> _build(Group g, List<String> memberNames,
      String rivalName, int seed, int careerId, int absWeek) {
    final rng = Random(seed);
    final grup = g.groupName;
    final fan = g.fandomName ?? '$grup Fanları';
    final uye = memberNames.isEmpty
        ? grup
        : memberNames[rng.nextInt(memberNames.length)];
    final hot = g.scandalHeat >= 50;
    final loved = g.reputation >= 60;

    String pick(List<String> xs) => xs[rng.nextInt(xs.length)];

    final fanText = loved
        ? pick([
            '$grup bu hafta da efsane! Gurur duyuyorum 😭💜',
            '$uye sahnede resmen patladı, kraliçe! 👑',
            'Yeni şarkıyı 100 kere dinledim, bağımlılık yaptı 🔥',
            '$grup için her şeyi yaparım, #1 olacaklar!',
          ])
        : pick([
            '$grup\'a inanmaya devam ediyorum, çıkış yakın 💪',
            '$uye daha çok sahne alsın istiyorum 🙏',
            'Bu grup hak ettiği değeri görecek, sabır 💜',
            'Albümü bekliyoruz, hadi artık! 🎵',
          ]);

    final rivalText = pick([
      '$rivalName yanında $grup biraz solda kalıyor bence 💅',
      'Gerçek sahne hakimiyeti $rivalName demektir, tartışılmaz.',
      '$grup fena değil ama $rivalName başka lig 🏆',
      'Herkes $rivalName konserine geliyor, suç bizde mi? 😎',
    ]);

    final haterText = hot
        ? pick([
            '$grup yine gündemde, şaşırmadık... her hafta bir olay 🙄',
            '$uye\'nin o açıklaması rezaletti açıkçası.',
            'Bu kadar skandal bir gruba nasıl para veriliyor anlamıyorum.',
            'Yetenek yok, sadece magazin var. #overrated',
          ])
        : pick([
            '$grup overrated, kimse itiraf etmiyor 🤷',
            'Bu şarkı da diğerlerinin aynısı, sıkıldım.',
            '$uye autotune olmadan söyleyebiliyor mu acaba? 👀',
            'Niye bu kadar konuşuluyorlar gerçekten anlamadım.',
          ]);

    final memberText = hot
        ? pick([
            'Söylenenlerin hepsi doğru değil, lütfen kaynak olmadan yazmayın 🙏',
            'Bugün biraz yorgunum ama sizin için buradayım 💜 #$grup',
            'Negatiflik enerjimi düşürmesin diye uğraşıyorum, teşekkürler $fan ✨',
          ])
        : pick([
            'Stüdyodan selamlar! Yeni şeyler geliyor 👀🎤 #$grup',
            'Bugünkü prova çok eğlenceliydi, ekibi çok seviyorum 💜',
            '$fan sizi çok seviyorum, en iyi hayran kitlesi sizsiniz 🥹',
            'Sahne öncesi heyecan bambaşka, iyi ki bu yoldayım ✨',
          ]);

    SocialPostsCompanion p(String type, String name, String handle,
            String text, String emoji) =>
        SocialPostsCompanion.insert(
          careerId: careerId,
          absWeek: absWeek,
          postType: type,
          displayName: name,
          handle: handle,
          content: text,
          avatarEmoji: emoji,
        );

    return [
      p('fan', fan, handleFor(fan), fanText, '💜'),
      p('member', uye, handleFor(uye), memberText, '🎤'),
      p('rival', '$rivalName Fan', handleFor(rivalName), rivalText, '🔥'),
      p('hater', 'anonim', '@h8r_${rng.nextInt(9000) + 1000}', haterText, '😡'),
    ];
  }
}
