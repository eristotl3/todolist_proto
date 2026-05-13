import 'package:flutter/material.dart';

// ── Palette ──────────────────────────────────────────────────────────────────
const _bg    = Color(0xFFF5F1E7);
const _ink   = Color(0xFF1C1815);
const _mute  = Color(0xFF7A6F63);
const _terr  = Color(0xFFCF6A3A);
const _cream = Color(0xFFFEF8EC);
// _terr at 45% opacity  (0.45 × 255 ≈ 115 = 0x73)
const _terrBlush = Color(0x73CF6A3A);
// _ink at 70% / 40% for checklist lines
const _inkLine70 = Color(0xB31C1815);
const _inkLine40 = Color(0x661C1815);

// ── SplashScreen ─────────────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _blink;
  late final AnimationController _glance;

  late final Animation<double> _wordmarkOpacity;
  late final Animation<double> _wordmarkSlide;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _taglineSlide;
  late final Animation<double> _penguinY;
  late final Animation<double> _blinkScale;
  late final Animation<double> _glanceX;

  @override
  void initState() {
    super.initState();

    // ── Entrance (1800 ms) ─────────────────────────────────────────────────
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Wordmark: delay 0.2 s, dur 0.7 s → Interval(0.111, 0.500)
    final wordmarkCurve = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.111, 0.500, curve: Cubic(0.2, 0.8, 0.3, 1.0)),
    );
    _wordmarkOpacity = wordmarkCurve;
    _wordmarkSlide =
        Tween<double>(begin: -14.0, end: 0.0).animate(wordmarkCurve);

    // Tagline: delay 0.6 s, dur 0.5 s → Interval(0.333, 0.611)
    final taglineCurve = CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.333, 0.611, curve: Curves.easeOut),
    );
    _taglineOpacity = taglineCurve;
    _taglineSlide =
        Tween<double>(begin: -4.0, end: 0.0).animate(taglineCurve);

    // Penguin rise: delay 0.3 s, dur 1.4 s → Interval(0.167, 0.944)
    // 1.0→0.36 (easeOut, 70%), 0.36→0.44 (15%), 0.44→0.40 (easeOut, 15%)
    _penguinY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.36)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.36, end: 0.44),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.44, end: 0.40)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
    ]).animate(CurvedAnimation(
      parent: _entrance,
      curve: const Interval(0.167, 0.944),
    ));

    // ── Idle blink (4000 ms loop) ──────────────────────────────────────────
    // Two blinks per cycle: at ~37% and ~95% (mirrors CSS keyframes)
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _blinkScale = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.08), weight: 2),
      TweenSequenceItem(tween: ConstantTween(0.08), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.08, end: 1.0), weight: 2),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 52),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.08), weight: 3),
      TweenSequenceItem(tween: ConstantTween(0.08), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 0.08, end: 1.0), weight: 3),
    ]).animate(_blink);

    // ── Idle glance (5000 ms loop) ─────────────────────────────────────────
    _glance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    _glanceX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -2.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: -2.0, end: 2.0), weight: 35),
      TweenSequenceItem(tween: Tween<double>(begin: 2.0, end: 0.0), weight: 35),
    ]).animate(_glance);

    _entrance.forward().then((_) {
      if (mounted) {
        _blink.repeat();
        _glance.repeat();
      }
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _blink.dispose();
    _glance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    const penguinW = 280.0;
    const penguinH = penguinW * 80 / 68; // ≈ 329.4

    return Scaffold(
      backgroundColor: _bg,
      body: AnimatedBuilder(
        animation: Listenable.merge([_entrance, _blink, _glance]),
        builder: (context, _) {
          return Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // ── Text column ───────────────────────────────────────────────
              Positioned.fill(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.30),
                    Opacity(
                      opacity: _wordmarkOpacity.value.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, _wordmarkSlide.value),
                        child: const Text(
                          'pengulist',
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w600,
                            color: _ink,
                            letterSpacing: -1.4,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Opacity(
                      opacity: _taglineOpacity.value.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, _taglineSlide.value),
                        child: const Text(
                          'Tiny tasks, big wins.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _mute,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Penguin ───────────────────────────────────────────────────
              Positioned(
                bottom: 0,
                left: (size.width - penguinW) / 2,
                child: Transform.translate(
                  offset: Offset(
                    _glanceX.value,
                    _penguinY.value * penguinH,
                  ),
                  child: CustomPaint(
                    size: const Size(penguinW, penguinH),
                    painter: _PenguinPainter(blinkScale: _blinkScale.value),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Penguin painter ──────────────────────────────────────────────────────────
// SVG viewBox="14 14 68 80" — canvas mapped via scale + translate
class _PenguinPainter extends CustomPainter {
  _PenguinPainter({required this.blinkScale});
  final double blinkScale;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 68, size.height / 80);
    canvas.translate(-14, -14);

    final inkP   = Paint()..color = _ink;
    final creamP = Paint()..color = _cream;
    final terrP  = Paint()..color = _terr;

    // ── Feet (terracotta) ─────────────────────────────────────────────────────
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(38, 84), width: 14, height: 6),
        terrP);
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(58, 84), width: 14, height: 6),
        terrP);

    // ── Body ──────────────────────────────────────────────────────────────────
    canvas.drawPath(
      Path()
        ..moveTo(24, 44)
        ..quadraticBezierTo(24, 18, 48, 18)
        ..quadraticBezierTo(72, 18, 72, 44)
        ..lineTo(72, 70)
        ..quadraticBezierTo(72, 82, 48, 82)
        ..quadraticBezierTo(24, 82, 24, 70)
        ..close(),
      inkP,
    );

    // ── Belly ─────────────────────────────────────────────────────────────────
    canvas.drawPath(
      Path()
        ..moveTo(34, 40)
        ..quadraticBezierTo(34, 28, 48, 28)
        ..quadraticBezierTo(62, 28, 62, 40)
        ..lineTo(62, 70)
        ..quadraticBezierTo(62, 76, 48, 76)
        ..quadraticBezierTo(34, 76, 34, 70)
        ..close(),
      creamP,
    );

    // ── Hat clip ──────────────────────────────────────────────────────────────
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(42, 24, 12, 6),
        const Radius.circular(2),
      ),
      terrP,
    );

    // ── Blush (rx=2.4, ry=1.4) ───────────────────────────────────────────────
    final blushP = Paint()..color = _terrBlush;
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(39, 36), width: 4.8, height: 2.8),
        blushP);
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(57, 36), width: 4.8, height: 2.8),
        blushP);

    // ── Eyes (blink: scaleY around y=34) ─────────────────────────────────────
    canvas.save();
    canvas.translate(0, 34);
    canvas.scale(1, blinkScale);
    canvas.translate(0, -34);

    canvas.drawCircle(const Offset(42, 34), 2, creamP);
    canvas.drawCircle(const Offset(42, 34), 1, inkP);
    canvas.drawCircle(const Offset(54, 34), 2, creamP);
    canvas.drawCircle(const Offset(54, 34), 1, inkP);

    canvas.restore();

    // ── Beak ──────────────────────────────────────────────────────────────────
    canvas.drawPath(
      Path()
        ..moveTo(46, 36)
        ..lineTo(48, 39)
        ..lineTo(50, 36)
        ..close(),
      terrP,
    );

    // ── Checklist ─────────────────────────────────────────────────────────────
    _drawChecklist(canvas, terrP, creamP);
  }

  void _drawChecklist(Canvas canvas, Paint terrP, Paint creamP) {
    canvas.save();
    canvas.translate(38, 42);

    // Checked box fill
    final checkP = Paint()..color = _terr;
    // Unchecked box outline
    final outlineP = Paint()
      ..color = _terr
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    // Cream checkmark stroke
    final ckP = Paint()
      ..color = _cream
      ..strokeWidth = 1.1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    // Filled line rects
    final line70P = Paint()..color = _inkLine70;
    final line40P = Paint()..color = _inkLine40;

    // Row 1 — checked
    canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, 5, 5), const Radius.circular(1.2)),
        checkP);
    canvas.drawPath(
        Path()..moveTo(1, 2.5)..lineTo(2.2, 3.7)..lineTo(4, 1.8), ckP);
    canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(8, 1, 14, 3), const Radius.circular(1.5)),
        line70P);

    // Row 2 — checked
    canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(0, 9, 5, 5), const Radius.circular(1.2)),
        checkP);
    canvas.drawPath(
        Path()..moveTo(1, 11.5)..lineTo(2.2, 12.7)..lineTo(4, 10.8), ckP);
    canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(8, 10, 11, 3), const Radius.circular(1.5)),
        line70P);

    // Row 3 — unchecked
    canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(0, 18, 5, 5), const Radius.circular(1.2)),
        outlineP);
    canvas.drawRRect(
        RRect.fromRectAndRadius(const Rect.fromLTWH(8, 19, 16, 3), const Radius.circular(1.5)),
        line40P);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_PenguinPainter old) => old.blinkScale != blinkScale;
}
