import 'package:flutter/material.dart';

class DirectionalColorContainer extends StatelessWidget {
  const DirectionalColorContainer({
    Key? key,
    this.topColor,
    this.bottomColor,
    this.leftColor,
    this.rightColor,
    required this.child,
  }) : super(key: key);

  final Color? topColor;
  final Color? bottomColor;
  final Color? leftColor;
  final Color? rightColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(
        topColor: topColor,
        bottomColor: bottomColor,
        leftColor: leftColor,
        rightColor: rightColor,
      ),
      child: child,
    );
  }
}

class _Painter extends CustomPainter {
  _Painter({
    required this.topColor,
    required this.bottomColor,
    required this.leftColor,
    required this.rightColor,
  });

  final Color? topColor;
  final Color? bottomColor;
  final Color? leftColor;
  final Color? rightColor;

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制上部分
    if (topColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height / 2),
        Paint()..color = topColor!,
      );
    }
    // 绘制下部分
    if (bottomColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2),
        Paint()..color = bottomColor!,
      );
    }
    // 绘制左侧部分
    if (leftColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width / 2, size.height),
        Paint()..color = leftColor!,
      );
    }
    // 绘制右侧部分
    if (rightColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height),
        Paint()..color = rightColor!,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
