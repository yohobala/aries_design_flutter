import 'package:flutter/material.dart';

class GradientProgressIndicator extends StatelessWidget {
  GradientProgressIndicator({
    Key? key,
    required this.value,
    this.height = 5,
    this.backgroundColor = Colors.grey,
  }) : super(key: key);

  /// 进度值，从0.0到1.0
  final double value;

  final double height;

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height, // 可以调整高度
      child: CustomPaint(
        painter: _GradientProgressPainter(value, backgroundColor),
      ),
    );
  }
}

class _GradientProgressPainter extends CustomPainter {
  final double value;
  final Color backgroundColor;

  _GradientProgressPainter(this.value, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromPoints(
        Offset(0, 0),
        Offset(size.width, size.height),
      ),
      backgroundPaint,
    );

    // 绘制渐变进度
    Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue, Colors.red],
      ).createShader(
          Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)))
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromPoints(
        Offset(0, 0),
        Offset(size.width * value, size.height),
      ),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
