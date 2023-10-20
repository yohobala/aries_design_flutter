import 'package:flutter/material.dart';

class GradientProgressIndicator extends StatelessWidget {
  GradientProgressIndicator({
    Key? key,
    required this.value,
    this.valueColor = const [Colors.blue, Colors.red],
    this.height = 5,
    this.backgroundColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
  }) : super(key: key);

  /// 进度值，从0.0到1.0
  final double value;

  final List<Color> valueColor;

  final double height;

  final Color backgroundColor;

  final BorderRadius borderRadius; // 圆角半径

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height, // 可以调整高度
      child: CustomPaint(
        painter: _GradientProgressPainter(
            value, valueColor, backgroundColor, borderRadius),
      ),
    );
  }
}

class _GradientProgressPainter extends CustomPainter {
  _GradientProgressPainter(
    this.value,
    this.valueColor,
    this.backgroundColor,
    this.borderRadius,
  );
  final double value;
  final List<Color> valueColor;
  final Color backgroundColor;
  final BorderRadius borderRadius;

  int get hashCode => Object.hash(
        value,
        valueColor,
        backgroundColor,
        borderRadius,
      );

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制背景
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(
          Offset(0, 0),
          Offset(size.width, size.height),
        ),
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      ),
      backgroundPaint,
    );

    // 绘制渐变进度
    Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: valueColor,
      ).createShader(
          Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)))
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(
          Offset(0, 0),
          Offset(size.width * value, size.height),
        ),
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      ),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate.hashCode != hashCode;
  }
}
