import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _pulseController;
  late final AnimationController _shimmerController;

  late final Animation<double> _emblemScale;
  late final Animation<double> _emblemOpacity;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _footerOpacity;
  late final Animation<double> _ringRotation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.nightDeep,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _emblemScale = Tween<double>(begin: 0.72, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    _emblemOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.32, 0.62, curve: Curves.easeOut),
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.32, 0.62, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.48, 0.78, curve: Curves.easeOut),
      ),
    );

    _footerOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.62, 0.95, curve: Curves.easeOut),
      ),
    );

    _ringRotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _introController.forward();
    Future<void>.delayed(const Duration(milliseconds: 3200), _goHome);
  }

  Future<void> _goHome() async {
    if (!mounted) return;
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    _introController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _introController,
          _pulseController,
          _shimmerController,
        ]),
        builder: (context, _) {
          final pulse = 0.85 + (_pulseController.value * 0.15);

          return Stack(
            fit: StackFit.expand,
            children: [
              const _SplashBackground(),
              Positioned.fill(
                child: CustomPaint(
                  painter: _StarFieldPainter(
                    progress: _introController.value,
                    twinkle: _pulseController.value,
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.12,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _emblemOpacity.value * 0.55,
                  child: Center(
                    child: Transform.scale(
                      scale: pulse,
                      child: Container(
                        width: size.width * 0.72,
                        height: size.width * 0.72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.gold.withValues(alpha: 0.28),
                              AppColors.gold.withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.45, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const Spacer(flex: 3),
                      Opacity(
                        opacity: _emblemOpacity.value,
                        child: Transform.scale(
                          scale: _emblemScale.value,
                          child: Transform.rotate(
                            angle: _ringRotation.value * 0.08,
                            child: SizedBox(
                              width: 168,
                              height: 168,
                              child: CustomPaint(
                                painter: _EmblemPainter(
                                  pulse: pulse,
                                  rotation: _ringRotation.value * math.pi * 0.35,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      FadeTransition(
                        opacity: _titleOpacity,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: Column(
                            children: [
                              Text(
                                'رَبَّنَا',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.amiri(
                                  color: AppColors.goldSoft,
                                  fontSize: 42,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '40 Rabbana',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cormorantGaramond(
                                  color: AppColors.ivory,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                  height: 1.05,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      FadeTransition(
                        opacity: _subtitleOpacity,
                        child: Text(
                          'Forty beautiful duas from the Qur’an',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            color: AppColors.mist,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.3,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const Spacer(flex: 4),
                      FadeTransition(
                        opacity: _footerOpacity,
                        child: Column(
                          children: [
                            _ShimmerLoader(progress: _shimmerController.value),
                            const SizedBox(height: 28),
                            Text(
                              'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.amiri(
                                color: AppColors.gold.withValues(alpha: 0.75),
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ],
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

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0E3B30),
            AppColors.night,
            AppColors.nightDeep,
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: _VignettePainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _VignettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.5, size.height * 0.38),
        size.width * 0.85,
        [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.35),
        ],
        [0.55, 1.0],
      );
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StarFieldPainter extends CustomPainter {
  _StarFieldPainter({required this.progress, required this.twinkle});

  final double progress;
  final double twinkle;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(40);
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < 48; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.72;
      final radius = 0.6 + random.nextDouble() * 1.4;
      final phase = random.nextDouble();
      final sparkle =
          (math.sin((twinkle + phase) * math.pi * 2) + 1) / 2;
      final alpha =
          (0.15 + sparkle * 0.55) * Curves.easeOut.transform(progress);

      paint.color = AppColors.goldSoft.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.twinkle != twinkle;
  }
}

class _EmblemPainter extends CustomPainter {
  _EmblemPainter({required this.pulse, required this.rotation});

  final double pulse;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final glowPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          AppColors.gold.withValues(alpha: 0.22 * pulse),
          Colors.transparent,
        ],
      );
    canvas.drawCircle(center, radius, glowPaint);

    final outerRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = AppColors.gold.withValues(alpha: 0.85);

    final innerRing = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = AppColors.goldSoft.withValues(alpha: 0.55);

    canvas.drawCircle(center, radius * 0.92, outerRing);
    canvas.drawCircle(center, radius * 0.78, innerRing);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final petalPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.gold.withValues(alpha: 0.7);

    for (var i = 0; i < 8; i++) {
      final angle = (math.pi / 4) * i;
      final p1 = Offset(
        math.cos(angle) * radius * 0.42,
        math.sin(angle) * radius * 0.42,
      );
      final p2 = Offset(
        math.cos(angle) * radius * 0.72,
        math.sin(angle) * radius * 0.72,
      );
      canvas.drawLine(p1, p2, petalPaint);
    }

    for (var i = 0; i < 8; i++) {
      final angle = (math.pi / 4) * i + math.pi / 8;
      canvas.drawCircle(
        Offset(
          math.cos(angle) * radius * 0.62,
          math.sin(angle) * radius * 0.62,
        ),
        2.2,
        Paint()..color = AppColors.goldSoft.withValues(alpha: 0.9),
      );
    }
    canvas.restore();

    final discPaint = Paint()
      ..shader = ui.Gradient.radial(
        center.translate(-8, -10),
        radius * 0.55,
        [
          AppColors.emeraldSoft,
          AppColors.emerald,
          const Color(0xFF0A2F26),
        ],
        const [0.0, 0.55, 1.0],
      );
    canvas.drawCircle(center, radius * 0.48, discPaint);

    final crescentPaint = Paint()
      ..color = AppColors.goldSoft
      ..style = PaintingStyle.fill;

    final crescentPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: center.translate(2, 0),
          radius: radius * 0.22,
        ),
      );
    final cutout = Path()
      ..addOval(
        Rect.fromCircle(
          center: center.translate(10, -4),
          radius: radius * 0.18,
        ),
      );
    final crescent = Path.combine(
      PathOperation.difference,
      crescentPath,
      cutout,
    );
    canvas.drawPath(crescent, crescentPaint);

    canvas.drawCircle(
      center.translate(18, -16),
      2.8,
      Paint()..color = AppColors.goldSoft,
    );
  }

  @override
  bool shouldRepaint(covariant _EmblemPainter oldDelegate) {
    return oldDelegate.pulse != pulse || oldDelegate.rotation != rotation;
  }
}

class _ShimmerLoader extends StatelessWidget {
  const _ShimmerLoader({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: AppColors.gold.withValues(alpha: 0.18),
            ),
            FractionallySizedBox(
              alignment: Alignment(-1 + (progress * 2), 0),
              widthFactor: 0.42,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.goldSoft.withValues(alpha: 0.95),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
