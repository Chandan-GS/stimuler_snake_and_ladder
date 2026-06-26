import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../core/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _leafController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _leafController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) context.go('/game');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _leafController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundDark,
              AppColors.jungleGreen,
              AppColors.canopyGreen,
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedBuilder(
              animation: _leafController,
              builder: (context, _) {
                return CustomPaint(
                  painter: JungleSplashPainter(animationValue: _leafController.value),
                );
              },
            ),
            Center(
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('🐍', style: TextStyle(fontSize: 48)),
                        SizedBox(width: 16),
                        Text('🪜', style: TextStyle(fontSize: 48)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'JUNGLE',
                      style: AppTextStyles.headline1.copyWith(fontSize: 36),
                    ),
                    Text(
                      'Snakes & Ladders',
                      style: AppTextStyles.headline2.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.mossGreen,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Loading adventure…',
                      style: AppTextStyles.bodyMuted,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JungleSplashPainter extends CustomPainter {
  final double animationValue;

  JungleSplashPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    paint.color = AppColors.safeZoneGold.withOpacity(0.1 + (animationValue * 0.05));
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), size.width * 0.4, paint);
    paint.color = AppColors.safeZoneGold.withOpacity(0.05 + (animationValue * 0.02));
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), size.width * 0.6, paint);

    _drawVine(canvas, size, Offset(size.width * 0.1, -50), Offset(size.width * 0.2, size.height * 0.6), animationValue);
    _drawVine(canvas, size, Offset(size.width * 0.9, -20), Offset(size.width * 0.7, size.height * 0.8), -animationValue);

    paint.color = AppColors.mossGreen.withOpacity(0.2);
    _drawLeaf(canvas, Offset(size.width * 0.1, size.height * 0.2), 60, math.pi / 4 + (animationValue * 0.1), paint);
    _drawLeaf(canvas, Offset(size.width * 0.85, size.height * 0.15), 80, -math.pi / 6 - (animationValue * 0.05), paint);
    _drawLeaf(canvas, Offset(size.width * 0.9, size.height * 0.7), 100, -math.pi / 3 + (animationValue * 0.15), paint);
    _drawLeaf(canvas, Offset(size.width * 0.15, size.height * 0.8), 70, math.pi / 2 - (animationValue * 0.1), paint);

    // Fireflies
    final fireflyPaint = Paint()
      ..color = Colors.yellowAccent.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      
    final random = math.Random(42); // fixed seed for positions
    for (int i = 0; i < 15; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final speed = random.nextDouble() * 2 + 1;
      final offset = random.nextDouble() * math.pi * 2;
      
      final dx = math.sin(animationValue * math.pi * speed + offset) * 20;
      final dy = math.cos(animationValue * math.pi * speed + offset) * 20;
      
      canvas.drawCircle(Offset(baseX + dx, baseY + dy), random.nextDouble() * 2 + 1, fireflyPaint);
    }
  }

  void _drawVine(Canvas canvas, Size size, Offset start, Offset end, double animValue) {
    final paint = Paint()
      ..color = AppColors.mossGreen.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(start.dx, start.dy);
    
    final controlPoint1 = Offset(start.dx + 50 + (animValue * 30), start.dy + (end.dy - start.dy) * 0.3);
    final controlPoint2 = Offset(end.dx - 50 - (animValue * 20), start.dy + (end.dy - start.dy) * 0.7);
    
    path.cubicTo(
      controlPoint1.dx, controlPoint1.dy,
      controlPoint2.dx, controlPoint2.dy,
      end.dx, end.dy,
    );

    canvas.drawPath(path, paint);
  }

  void _drawLeaf(Canvas canvas, Offset center, double size, double angle, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    
    final path = Path();
    path.moveTo(0, -size / 2);
    path.quadraticBezierTo(size / 2, 0, 0, size / 2);
    path.quadraticBezierTo(-size / 2, 0, 0, -size / 2);
    
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant JungleSplashPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
