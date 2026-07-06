// Öğrenci No: 202313171033
// Oyunsu tekrar kullanılır bileşenler: gradient halkalı avatar, gradient
// başlıklı panel, basıldığında küçülen gradient butonlar, gradient AppBar ve
// sahne hissi veren zemin.
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'app_theme.dart';

/// Değer değişince eski→yeni arası sayan animasyonlu sayı.
class AnimatedCount extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final String Function(int)? formatter;
  final Duration duration;
  const AnimatedCount(this.value,
      {super.key,
      this.style,
      this.formatter,
      this.duration = const Duration(milliseconds: 650)});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => Text(
        (formatter ?? (n) => '$n')(v.round()),
        style: style,
      ),
    );
  }
}

/// Ekranın üstünden konfeti patlatır (büyük kutlama anları). Kendini temizler.
void playConfetti(BuildContext context, {bool big = false}) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _ConfettiBurst(big: big, onDone: () => entry.remove()),
  );
  overlay.insert(entry);
}

class _ConfettiBurst extends StatefulWidget {
  final bool big;
  final VoidCallback onDone;
  const _ConfettiBurst({required this.big, required this.onDone});
  @override
  State<_ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<_ConfettiBurst> {
  late final ConfettiController _c;
  bool _removed = false;

  @override
  void initState() {
    super.initState();
    _c = ConfettiController(
        duration: Duration(milliseconds: widget.big ? 2400 : 1500));
    // İlk frame'den sonra patlat (widget mount olduktan sonra)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _c.play();
    });
    Future.delayed(Duration(milliseconds: widget.big ? 3200 : 2400), () {
      if (!_removed) {
        _removed = true;
        widget.onDone();
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _c,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: widget.big ? 30 : 18,
            maxBlastForce: widget.big ? 26 : 18,
            minBlastForce: 7,
            gravity: 0.25,
            emissionFrequency: 0.05,
            colors: const [
              AppColors.primary,
              AppColors.secondary,
              AppColors.gold,
              AppColors.bordo,
              Color(0xFFFFFFFF),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dokununca hafifçe küçülen sarmalayıcı (oyunsu dokunma geri bildirimi).
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  const PressableScale(
      {super.key, required this.child, this.onTap, this.scale = 0.95});

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _down = false;
  void _set(bool v) {
    if (widget.onTap == null) return;
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// İçeriği aşağıdan yukarı kayarak + belirerek getiren giriş animasyonu.
class FadeInUp extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  const FadeInUp(
      {super.key,
      required this.child,
      this.duration = const Duration(milliseconds: 450),
      this.offset = 24});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.translate(
            offset: Offset(0, (1 - t) * offset), child: child),
      ),
      child: child,
    );
  }
}

/// Sahne hissi veren gradient zemin + köşelerde yumuşak ışık halkaları +
/// yavaşça yanıp sönen yıldız/nota parıltıları (oyun atmosferi).
class GameBackground extends StatelessWidget {
  final Widget child;
  final bool dark; // EKLENDİ: Temanın durumunu doğrudan alır

  const GameBackground({super.key, required this.dark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(decoration: BoxDecoration(gradient: AppColors.bgGradient)),
        Positioned(
            top: -70,
            left: -50,
            child: _glow(AppColors.primary.withAlpha(dark ? 110 : 40))),
        Positioned(
            bottom: -90,
            right: -60,
            child: _glow(AppColors.secondary.withAlpha(dark ? 80 : 36))),
        const Positioned.fill(
            child:
                IgnorePointer(child: RepaintBoundary(child: TwinkleLayer()))),
        Positioned.fill(child: child),
      ],
    );
  }

  Widget _glow(Color c) => Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [c, c.withAlpha(0)]),
        ),
      );
}

/// Zemin üstünde süzülen, yanıp sönen minik yıldız + nota parçacıkları.
/// Hafif tutulmuştur (18 parçacık, tek controller) — her ekranın altında döner.
class TwinkleLayer extends StatefulWidget {
  const TwinkleLayer({super.key});
  @override
  State<TwinkleLayer> createState() => _TwinkleLayerState();
}

class _TwinkleParticle {
  final double fx, fy; // konum (ekran oranı)
  final double size, phase, speed;
  final int kind; // 0=yıldız, 1=nota ♪, 2=nota ♫
  final Color color;
  _TwinkleParticle(this.fx, this.fy, this.size, this.phase, this.speed,
      this.kind, this.color);
}

class _TwinkleLayerState extends State<TwinkleLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final List<_TwinkleParticle> _parts;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 9))
      ..repeat();
    final rng = math.Random(7);
    const palette = [
      AppColors.gold,
      AppColors.secondary,
      AppColors.primary,
      AppColors.accentBlue,
    ];
    _parts = List.generate(18, (i) {
      return _TwinkleParticle(
        rng.nextDouble(),
        rng.nextDouble(),
        i % 5 == 0 ? 13.0 + rng.nextDouble() * 5 : 5.0 + rng.nextDouble() * 5,
        rng.nextDouble(),
        0.6 + rng.nextDouble() * 0.9,
        i % 6 == 4 ? 1 : (i % 6 == 5 ? 2 : 0),
        palette[i % palette.length],
      );
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) =>
          CustomPaint(painter: _TwinklePainter(_c.value, _parts)),
    );
  }
}

class _TwinklePainter extends CustomPainter {
  final double t;
  final List<_TwinkleParticle> parts;
  _TwinklePainter(this.t, this.parts);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in parts) {
      final tw = math.sin(2 * math.pi * (t * p.speed + p.phase));
      final opacity = (0.20 + 0.80 * (tw + 1) / 2).clamp(0.0, 1.0);
      final bob = 6 * math.sin(2 * math.pi * (t * 0.5 + p.phase));
      final dx = p.fx * size.width;
      final dy = p.fy * size.height + bob;
      // Koyu temada parıltılar daha belirgin
      final color =
          p.color.withAlpha(((AppColors.dark ? 120 : 52) * opacity).round());
      if (p.kind == 0) {
        _star(canvas, Offset(dx, dy), p.size, color);
      } else {
        final tp = TextPainter(
          text: TextSpan(
              text: p.kind == 1 ? '♪' : '♫',
              style: TextStyle(fontSize: p.size + 8, color: color)),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(dx, dy));
      }
    }
  }

  void _star(Canvas canvas, Offset c, double r, Color color) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final ang = math.pi / 4 * i - math.pi / 2;
      final rr = i.isEven ? r : r * 0.32;
      final pt = Offset(c.dx + rr * math.cos(ang), c.dy + rr * math.sin(ang));
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TwinklePainter old) => old.t != t;
}

/// Dönen plak (vinil) — ana menü logosu. Altın kenar, oluklar, gradient etiket.
class VinylDisc extends StatefulWidget {
  final double size;
  final IconData centerIcon;
  const VinylDisc({super.key, this.size = 140, this.centerIcon = Icons.mic});
  @override
  State<VinylDisc> createState() => _VinylDiscState();
}

class _VinylDiscState extends State<VinylDisc>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 14))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return SizedBox(
      width: s,
      height: s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: s,
            height: s,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: AppColors.primary.withAlpha(130),
                    blurRadius: 34,
                    offset: const Offset(0, 10)),
                BoxShadow(
                    color: AppColors.gold.withAlpha(60),
                    blurRadius: 50,
                    spreadRadius: 6),
              ],
            ),
            child: RotationTransition(
              turns: _c,
              child: CustomPaint(painter: _VinylPainter()),
            ),
          ),
          // Merkez ikon plakla birlikte DÖNMEZ
          IgnorePointer(
              child:
                  Icon(widget.centerIcon, color: Colors.white, size: s * 0.26)),
        ],
      ),
    );
  }
}

class _VinylPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    // altın dış jant
    canvas.drawCircle(c, r, Paint()..color = AppColors.gold);
    // plak gövdesi
    canvas.drawCircle(c, r - 3, Paint()..color = const Color(0xFF221626));
    // ışık süpürmesi (dönerken fark edilir)
    final sweep = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.white.withAlpha(0),
          Colors.white.withAlpha(26),
          Colors.white.withAlpha(0),
          Colors.white.withAlpha(0),
          Colors.white.withAlpha(20),
          Colors.white.withAlpha(0),
        ],
        stops: const [0.0, 0.08, 0.20, 0.5, 0.58, 0.72],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawCircle(c, r - 3, sweep);
    // oluklar
    final groove = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withAlpha(14);
    for (double gr = r * 0.42; gr < r - 6; gr += 5) {
      canvas.drawCircle(c, gr, groove);
    }
    // gradient etiket
    final labelR = r * 0.36;
    canvas.drawCircle(
        c,
        labelR,
        Paint()
          ..shader = AppColors.headerGradient
              .createShader(Rect.fromCircle(center: c, radius: labelR)));
    canvas.drawCircle(
        c,
        labelR,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.gold);
    // merkez delik
    canvas.drawCircle(c, 3.4, Paint()..color = const Color(0xFF221626));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

/// Animasyonlu oyun çubuğu: doluluk gradient'li, 0'dan hedefe yumuşakça dolar.
/// CustomPaint tabanlı — AlertDialog gibi intrinsic-genişlik hesaplayan
/// yerlerde de güvenli (FractionallySizedBox oralarda NaN üretip çökiyordu).
class GameBar extends StatelessWidget {
  final double value; // 0..1
  final Color color;
  final double height;
  const GameBar(
      {super.key, required this.value, required this.color, this.height = 9});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (_, t, __) => CustomPaint(
        size: Size(double.infinity, height),
        painter: _GameBarPainter(t, color),
      ),
    );
  }
}

class _GameBarPainter extends CustomPainter {
  final double t;
  final Color color;
  _GameBarPainter(this.t, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height / 2);
    // zemin
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, radius),
      Paint()..color = AppColors.surfaceHigh,
    );
    // doluluk
    final w = size.width * t;
    if (w > 0.5) {
      final rect = Rect.fromLTWH(0, 0, w, size.height);
      // hafif renk parlaması
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, radius),
        Paint()
          ..color = color.withAlpha(80)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, radius),
        Paint()
          ..shader = LinearGradient(colors: [color.withAlpha(150), color])
              .createShader(rect),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GameBarPainter old) =>
      old.t != t || old.color != color;
}

/// Metnin üzerinden periyodik parlak süpürme geçirir (logo parlaması).
class ShimmerSweep extends StatefulWidget {
  final Widget child;
  const ShimmerSweep({super.key, required this.child});
  @override
  State<ShimmerSweep> createState() => _ShimmerSweepState();
}

class _ShimmerSweepState extends State<ShimmerSweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2600))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, child) {
        final x = -1.2 + 2.8 * _c.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment(x - 0.5, -0.3),
            end: Alignment(x + 0.5, 0.3),
            colors: [
              Colors.white.withAlpha(0),
              Colors.white.withAlpha(120),
              Colors.white.withAlpha(0),
            ],
          ).createShader(rect),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Gradient zeminli AppBar (bordo → mor). Oyunsu başlık çubuğu.
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final Gradient? gradient;
  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
    this.gradient,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.headerGradient,
        boxShadow: [
          BoxShadow(
              color: AppColors.dark
                  ? Colors.black.withAlpha(150)
                  : AppColors.bordo.withAlpha(70),
              blurRadius: AppColors.dark ? 15 : 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: title,
        actions: actions,
        leading: leading,
        bottom: bottom,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}

/// Birincil oyun butonu — gradient dolgu + glow + basınca küçülür.
class GameButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Gradient gradient;
  final bool fullWidth;
  const GameButton({
    super.key,
    required this.label,
    this.icon,
    required this.onTap,
    this.gradient = AppColors.buttonGradient,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: PressableScale(
        onTap: onTap,
        child: Container(
          width: fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: disabled
                ? null
                : [
                    BoxShadow(
                        color: AppColors.primary.withAlpha(110),
                        blurRadius: 14,
                        offset: const Offset(0, 6)),
                  ],
          ),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 10),
              ],
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Daire karakter avatarı — gradient halka + yumuşak glow.
/// [imagePath] verilirse resim gösterilir; yoksa baş harf/ikon yedeği.
class CharacterAvatar extends StatelessWidget {
  final String? imagePath;
  final String? initial;
  final IconData fallbackIcon;
  final Color? tint;
  final double size;
  final double ringWidth;
  final Gradient? ringGradient;

  const CharacterAvatar({
    super.key,
    this.imagePath,
    this.initial,
    this.fallbackIcon = Icons.person,
    this.tint,
    this.size = 64,
    this.ringWidth = 3,
    this.ringGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: ringGradient ?? AppColors.headerGradient,
        boxShadow: [
          BoxShadow(
            color: (ringGradient == AppColors.goldGradient
                    ? AppColors.gold
                    : AppColors.primary)
                .withAlpha(AppColors.dark ? 80 : 40),
            blurRadius: AppColors.dark ? 12 : 8,
            spreadRadius: AppColors.dark ? 2 : 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(ringWidth),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: tint ?? AppColors.surfaceHigh,
          border: AppColors.dark
              ? Border.all(color: Colors.black54, width: 2)
              : null,
        ),
        child: ClipOval(child: _inner()),
      ),
    );
  }

  Widget _inner() {
    final path = imagePath;
    if (path != null && path.isNotEmpty) {
      final img = path.startsWith('assets/')
          ? Image.asset(path,
              fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback())
          : Image.file(File(path),
              fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback());
      return SizedBox.expand(child: img);
    }
    return _fallback();
  }

  Widget _fallback() {
    if (initial != null && initial!.isNotEmpty) {
      return Center(
        child: Text(
          initial!.substring(0, 1).toUpperCase(),
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w900,
            color: AppColors.dark ? Colors.white70 : AppColors.primary,
          ),
        ),
      );
    }
    return Center(
        child: Icon(fallbackIcon,
            size: size * 0.5,
            color: AppColors.dark ? Colors.white70 : AppColors.primary));
  }
}

class GamePanel extends StatelessWidget {
  final String title;
  final IconData? headerIcon;
  final Gradient? headerGradient;
  final Widget child;
  final EdgeInsets bodyPadding;

  const GamePanel({
    super.key,
    required this.title,
    required this.child,
    this.headerIcon,
    this.headerGradient,
    this.bodyPadding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dark
            ? AppColors.surface.withAlpha(240)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark
                ? Colors.black.withAlpha(150)
                : AppColors.primary.withAlpha(45),
            blurRadius: AppColors.dark ? 20 : 16,
            offset: Offset(0, AppColors.dark ? 10 : 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
                gradient: headerGradient ?? AppColors.headerGradient),
            child: Row(
              children: [
                if (headerIcon != null) ...[
                  Icon(headerIcon, color: Colors.white, size: 19),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.2)),
                ),
              ],
            ),
          ),
          Padding(padding: bodyPadding, child: child),
        ],
      ),
    );
  }
}

/// "Chunky" buton — gradient vurgu + basınca küçülür. (Geriye uyum için korunur.)
class ChunkyButton extends StatelessWidget {
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color accent;
  final IconData? icon;

  const ChunkyButton({
    super.key,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.accent = AppColors.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: PressableScale(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.dark
                ? AppColors.surfaceHigh.withAlpha(200)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: accent.withAlpha(AppColors.dark ? 180 : 120),
                width: AppColors.dark ? 2 : 1.5),
            boxShadow: [
              BoxShadow(
                  color: accent.withAlpha(AppColors.dark ? 40 : 55),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.buttonGradient,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.ink)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary)),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: accent, size: AppColors.dark ? 28 : 24),
            ],
          ),
        ),
      ),
    );
  }
}
