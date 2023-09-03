import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

Widget Function(
  Widget child,
  AnimationController animationController, {
  double scale,
  bool reverse,
  Axis? axis,
}) ariButtonScaleAnimatedBuilder = (
  Widget widget,
  AnimationController animationController, {
  double scale = 0.7,
  reverse = false,
  axis = Axis.horizontal,
}) {
  var begin = !reverse ? 1.0 : scale;
  var end = !reverse ? scale : 1.0;
  var animation = Tween<double>(
    begin: begin,
    end: end,
  ).animate(animationController);

  Widget build() {
    if (axis == Axis.horizontal) {
      return Transform(
        transform: Matrix4.diagonal3(Vector3(animation.value, 1.0, 1.0)),
        alignment: Alignment.center,
        child: widget,
      );
    } else if (axis == Axis.vertical) {
      return Transform(
        transform: Matrix4.diagonal3(Vector3(1.0, animation.value, 1.0)),
        alignment: Alignment.center,
        child: widget,
      );
    }

    return Transform.scale(
      scale: animation.value,
      alignment: Alignment.center,
      child: widget,
    );
  }

  // 返回一个 AnimatedBuilder 来根据动画值进行缩放
  return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Visibility(
            visible: animation.value > scale, // 根据实际需求来设置这个条件
            child: build(),
          ),
        );
      });
};
