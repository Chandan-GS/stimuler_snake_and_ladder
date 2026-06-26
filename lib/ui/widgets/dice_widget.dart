import 'package:flutter/material.dart';

class DiceWidget extends StatelessWidget {
  final int value;
  final bool rolling;

  const DiceWidget({super.key, required this.value, required this.rolling});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: rolling ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.elasticOut,
      child: AnimatedRotation(
        turns: rolling ? value * 0.15 : 0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFE0E0E0)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: rolling ? 0.6 : 0.2),
                blurRadius: rolling ? 20 : 8,
                spreadRadius: rolling ? 4 : 0,
                offset: const Offset(0, 4),
              ),
              const BoxShadow(
                color: Colors.white,
                blurRadius: 4,
                spreadRadius: -2,
                offset: Offset(-2, -2),
              ),
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                spreadRadius: -2,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: CustomPaint(painter: DiceFacePainter(value: value)),
        ),
      ),
    );
  }
}

class DiceFacePainter extends CustomPainter {
  final int value;
  const DiceFacePainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1B0000)
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final r = size.width * 0.1;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final off = size.width * 0.26;

    final dots = <Offset>[];
    switch (value) {
      case 1:
        dots.add(Offset(cx, cy));
        break;
      case 2:
        dots.addAll([Offset(cx - off, cy - off), Offset(cx + off, cy + off)]);
        break;
      case 3:
        dots.addAll([
          Offset(cx - off, cy - off),
          Offset(cx, cy),
          Offset(cx + off, cy + off),
        ]);
        break;
      case 4:
        dots.addAll([
          Offset(cx - off, cy - off),
          Offset(cx + off, cy - off),
          Offset(cx - off, cy + off),
          Offset(cx + off, cy + off),
        ]);
        break;
      case 5:
        dots.addAll([
          Offset(cx - off, cy - off),
          Offset(cx + off, cy - off),
          Offset(cx, cy),
          Offset(cx - off, cy + off),
          Offset(cx + off, cy + off),
        ]);
        break;
      case 6:
        dots.addAll([
          Offset(cx - off, cy - off),
          Offset(cx + off, cy - off),
          Offset(cx - off, cy),
          Offset(cx + off, cy),
          Offset(cx - off, cy + off),
          Offset(cx + off, cy + off),
        ]);
        break;
    }

    for (final d in dots) {
      canvas.drawCircle(d, r, paint);
      canvas.drawCircle(d - Offset(r * 0.3, r * 0.3), r * 0.3, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(DiceFacePainter old) => old.value != value;
}
