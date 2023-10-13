import 'package:flutter/material.dart';

class AriGradientBorder extends StatelessWidget {
  AriGradientBorder({
    required this.child,
    this.strokeWidth = 2.0,
    this.colors = const [Colors.blue, Colors.red],
    this.borderRadius = 10.0,
  });
  final Widget child;
  final double strokeWidth;
  final List<Color> colors;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(strokeWidth),
      child: child,
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  _GradientBorderPainter(
    this.strokeWidth,
    this.colors,
    this.borderRadius,
  );
  final double strokeWidth;
  final List<Color> colors;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
      ).createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
