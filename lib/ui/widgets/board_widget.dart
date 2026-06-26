import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../cubit/game_state.dart';

class BoardWidget extends StatelessWidget {
  final GameState state;
  const BoardWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B4D2E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Wrap background in RepaintBoundary to eliminate resize jank
          RepaintBoundary(
            child: CustomPaint(
              painter: BoardBackgroundPainter(
                snakes: state.snakes,
                ladders: state.ladders,
              ),
            ),
          ),
          CustomPaint(
            painter: BoardForegroundPainter(
              player1Pos: state.player1Pos,
              player2Pos: state.player2Pos,
            ),
          ),
        ],
      ),
    );
  }
}

class BoardBackgroundPainter extends CustomPainter {
  final Map<int, int> snakes;
  final Map<int, int> ladders;

  BoardBackgroundPainter({required this.snakes, required this.ladders});

  static const int kCols = 10;
  static const int kRows = 10;

  Offset cellCenter(int cell, double cellW, double cellH) {
    final idx = cell - 1;
    final row = idx ~/ kCols;
    final rawCol = idx % kCols;
    final col = (row % 2 == 0) ? rawCol : (kCols - 1 - rawCol);
    final x = col * cellW + cellW / 2;
    final y = (kRows - 1 - row) * cellH + cellH / 2;
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / kCols;
    final cellH = size.height / kRows;

    _drawCells(canvas, size, cellW, cellH);
    _drawLadders(canvas, cellW, cellH);
    _drawSnakes(canvas, cellW, cellH);
    _drawCellNumbers(canvas, cellW, cellH);
    _drawStartEndMarkers(canvas, cellW, cellH);
  }

  void _drawCells(Canvas canvas, Size size, double cellW, double cellH) {
    final colors = [
      const Color(0xFF81C784),
      const Color(0xFF66BB6A),
      const Color(0xFF4CAF50),
      const Color(0xFF43A047),
    ];

    for (int cell = 1; cell <= kTotalCells; cell++) {
      final center = cellCenter(cell, cellW, cellH);
      final rect = Rect.fromCenter(center: center, width: cellW, height: cellH);

      Color bg;
      if (cell == kTotalCells) {
        bg = const Color(0xFFFFD700);
      } else if (cell == 1) {
        bg = const Color(0xFF81D4FA);
      } else if (snakes.containsKey(cell)) {
        bg = const Color(0xFFEF9A9A);
      } else if (ladders.containsKey(cell)) {
        bg = const Color(0xFFA5D6A7);
      } else {
        final idx = ((cell - 1) ~/ kCols) + ((cell - 1) % kCols);
        bg = colors[idx % colors.length];
      }

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [bg.withValues(alpha: 0.9), bg.withValues(alpha: 0.7)],
          center: Alignment.topLeft,
          radius: 1.5,
        ).createShader(rect);

      canvas.drawRect(rect, paint);

      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      final highlightPath = Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
      canvas.drawPath(highlightPath, highlightPaint);

      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      final shadowPath = Path()
        ..moveTo(rect.right, rect.top)
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.left, rect.bottom);
      canvas.drawPath(shadowPath, shadowPaint);
    }
  }

  void _drawLadders(Canvas canvas, double cellW, double cellH) {
    for (final entry in ladders.entries) {
      final bottom = cellCenter(entry.key, cellW, cellH);
      final top = cellCenter(entry.value, cellW, cellH);

      final dx = top.dx - bottom.dx;
      final dy = top.dy - bottom.dy;
      final len = sqrt(dx * dx + dy * dy);
      final nx = -dy / len;
      final ny = dx / len;
      final railOff = cellW * 0.15;

      final shadowOffset = Offset(2, 4);
      final dropShadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.4)
        ..strokeWidth = cellW * 0.08
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      for (final sign in [-1.0, 1.0]) {
        final p1 = Offset(
          bottom.dx + nx * railOff * sign,
          bottom.dy + ny * railOff * sign,
        );
        final p2 = Offset(
          top.dx + nx * railOff * sign,
          top.dy + ny * railOff * sign,
        );
        canvas.drawLine(p1 + shadowOffset, p2 + shadowOffset, dropShadowPaint);
      }

      for (final sign in [-1.0, 1.0]) {
        final p1 = Offset(
          bottom.dx + nx * railOff * sign,
          bottom.dy + ny * railOff * sign,
        );
        final p2 = Offset(
          top.dx + nx * railOff * sign,
          top.dy + ny * railOff * sign,
        );
        final railPaint = Paint()
          ..color = const Color(0xFF6D4C41)
          ..strokeWidth = cellW * 0.08
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
        canvas.drawLine(p1, p2, railPaint);

        final railHighlight = Paint()
          ..color = const Color(0xFF8D6E63)
          ..strokeWidth = cellW * 0.02
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
        canvas.drawLine(p1 - Offset(1, 1), p2 - Offset(1, 1), railHighlight);
      }

      final rungCount = max(2, (len / (cellH * 0.7)).round());
      final rungPaint = Paint()
        ..color = const Color(0xFF8D6E63)
        ..strokeWidth = cellW * 0.06
        ..strokeCap = StrokeCap.round;
      for (int i = 1; i < rungCount; i++) {
        final t = i / rungCount;
        final mid = Offset(bottom.dx + dx * t, bottom.dy + dy * t);
        final p1 = Offset(
          mid.dx + nx * railOff * 1.2,
          mid.dy + ny * railOff * 1.2,
        );
        final p2 = Offset(
          mid.dx - nx * railOff * 1.2,
          mid.dy - ny * railOff * 1.2,
        );
        canvas.drawLine(p1 + shadowOffset, p2 + shadowOffset, dropShadowPaint);
        canvas.drawLine(p1, p2, rungPaint);
      }
    }
  }

  void _drawSnakes(Canvas canvas, double cellW, double cellH) {
    for (final entry in snakes.entries) {
      final head = cellCenter(entry.key, cellW, cellH);
      final tail = cellCenter(entry.value, cellW, cellH);

      final path = Path();
      path.moveTo(tail.dx, tail.dy);

      final mid = Offset((head.dx + tail.dx) / 2, (head.dy + tail.dy) / 2);
      final dx = head.dx - tail.dx;
      final dy = head.dy - tail.dy;
      final len = sqrt(dx * dx + dy * dy);
      final perp = Offset(-dy / len * cellW * 1.5, dx / len * cellW * 1.5);

      path.cubicTo(
        tail.dx + dx * 0.25 + perp.dx,
        tail.dy + dy * 0.25 + perp.dy,
        tail.dx + dx * 0.5 - perp.dx * 0.5,
        tail.dy + dy * 0.5 - perp.dy * 0.5,
        mid.dx,
        mid.dy,
      );
      path.cubicTo(
        mid.dx + dx * 0.1 + perp.dx * 0.5,
        mid.dy + dy * 0.1 + perp.dy * 0.5,
        head.dx - dx * 0.25 - perp.dx,
        head.dy - dy * 0.25 - perp.dy,
        head.dx,
        head.dy,
      );

      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.5)
        ..strokeWidth = cellW * 0.20
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.save();
      canvas.translate(2, 4);
      canvas.drawPath(path, shadowPaint);
      canvas.drawCircle(
        head,
        cellW * 0.15,
        Paint()
          ..color = shadowPaint.color
          ..maskFilter = shadowPaint.maskFilter,
      );
      canvas.restore();

      final bodyPaint = Paint()
        ..color = const Color(0xFFC62828)
        ..strokeWidth = cellW * 0.16
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final outlinePaint = Paint()
        ..color = const Color(0xFF8E0000)
        ..strokeWidth = cellW * 0.22
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, outlinePaint);
      canvas.drawPath(path, bodyPaint);

      final scalePaint = Paint()
        ..color = const Color(0xFFFF5252)
        ..style = PaintingStyle.fill;
      final pm = path.computeMetrics().first;
      final scaleCount = (pm.length / (cellW * 0.25)).round();
      for (int i = 1; i < scaleCount; i++) {
        final t = pm.getTangentForOffset(pm.length * i / scaleCount);
        if (t != null) {
          canvas.drawCircle(t.position, cellW * 0.035, scalePaint);
        }
      }

      canvas.drawCircle(
        head,
        cellW * 0.16,
        Paint()..color = const Color(0xFF8E0000),
      );
      canvas.drawCircle(
        head,
        cellW * 0.13,
        Paint()..color = const Color(0xFFC62828),
      );

      final eyeDir = Offset(-dy / len, dx / len) * (cellW * 0.06);
      for (final sign in [-1.0, 1.0]) {
        canvas.drawCircle(
          head + eyeDir * sign,
          cellW * 0.035,
          Paint()..color = Colors.yellowAccent,
        );
        canvas.drawCircle(
          head + eyeDir * sign,
          cellW * 0.02,
          Paint()..color = Colors.black,
        );
      }
    }
  }

  void _drawCellNumbers(Canvas canvas, double cellW, double cellH) {
    for (int cell = 1; cell <= kTotalCells; cell++) {
      final center = cellCenter(cell, cellW, cellH);

      final tp = TextPainter(
        text: TextSpan(
          text: '$cell',
          style: TextStyle(
            color: cell == kTotalCells || cell == 1
                ? Colors.black87
                : Colors.black.withValues(alpha: 0.4),
            fontSize: cellW * 0.24,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(center.dx - tp.width / 2, center.dy - cellH / 2 + cellH * 0.05),
      );
    }
  }

  void _drawStartEndMarkers(Canvas canvas, double cellW, double cellH) {
    final startCenter = cellCenter(1, cellW, cellH);
    _drawEmoji(canvas, '🏁', startCenter, cellW);

    final endCenter = cellCenter(100, cellW, cellH);
    _drawEmoji(canvas, '🏆', endCenter, cellW);
  }

  void _drawEmoji(Canvas canvas, String emoji, Offset center, double size) {
    final tp = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(fontSize: size * 0.4),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2 + size * 0.15),
    );
  }

  @override
  bool shouldRepaint(BoardBackgroundPainter old) {
    // We only repaint the background if the actual board layout (snakes/ladders) changes.
    // It's incredibly cheap if this returns false.
    return old.snakes != snakes || old.ladders != ladders;
  }
}

class BoardForegroundPainter extends CustomPainter {
  final int player1Pos;
  final int player2Pos;

  BoardForegroundPainter({required this.player1Pos, required this.player2Pos});

  static const int kCols = 10;
  static const int kRows = 10;

  Offset cellCenter(int cell, double cellW, double cellH) {
    final idx = cell - 1;
    final row = idx ~/ kCols;
    final rawCol = idx % kCols;
    final col = (row % 2 == 0) ? rawCol : (kCols - 1 - rawCol);
    final x = col * cellW + cellW / 2;
    final y = (kRows - 1 - row) * cellH + cellH / 2;
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / kCols;
    final cellH = size.height / kRows;

    void drawPawn(int pos, Color color) {
      if (pos == 0) return;
      final center = cellCenter(pos, cellW, cellH);
      final x = center.dx;
      // Visually center the pawn's mass in the cell
      final y = center.dy - cellH * 0.08;
      final r = cellW * 0.18;

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y + r * 1.8),
          width: r * 1.5,
          height: r * 0.8,
        ),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );

      final Gradient pawnGradient = RadialGradient(
        colors: [color.withValues(alpha: 0.7), color],
        center: const Alignment(-0.3, -0.3),
        radius: 0.8,
      );

      final bodyPath = Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset(x, y),
            width: r * 1.6,
            height: r * 1.6,
          ),
        );
      canvas.drawPath(
        bodyPath,
        Paint()..shader = pawnGradient.createShader(bodyPath.getBounds()),
      );

      final stemPath = Path()
        ..moveTo(x - r * 0.3, y + r * 0.7)
        ..lineTo(x + r * 0.3, y + r * 0.7)
        ..lineTo(x + r * 0.5, y + r * 1.6)
        ..lineTo(x - r * 0.5, y + r * 1.6)
        ..close();
      canvas.drawPath(
        stemPath,
        Paint()..shader = pawnGradient.createShader(stemPath.getBounds()),
      );

      final baseRect = Rect.fromCenter(
        center: Offset(x, y + r * 1.7),
        width: r * 1.4,
        height: r * 0.4,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(baseRect, const Radius.circular(3)),
        Paint()..shader = pawnGradient.createShader(baseRect),
      );

      canvas.drawCircle(
        Offset(x - r * 0.25, y - r * 0.25),
        r * 0.2,
        Paint()..color = Colors.white.withValues(alpha: 0.6),
      );
    }

    drawPawn(player1Pos, AppColors.playerOneColor);
    drawPawn(player2Pos, AppColors.playerTwoColor);
  }

  @override
  bool shouldRepaint(BoardForegroundPainter old) {
    return old.player1Pos != player1Pos || old.player2Pos != player2Pos;
  }
}
