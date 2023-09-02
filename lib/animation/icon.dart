import 'package:flutter/widgets.dart';

import 'index.dart';

/// 用于切换图标的动画
///
/// 比如可以用在button点击后图标切换上,例如[AriIconButton]中就使用
///
/// *参数*
/// - `child` 需要动画的控件
/// - `animationController` 动画控制器
AriAnimationCallback ariIconSwitchAnimatedBuilder =
    (Widget widget, AnimationController animationController,
        [double scale = 0.8]) {
  var animation = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: scale),
      weight: 50.0,
    ),
    TweenSequenceItem(
      tween: Tween(begin: scale, end: 1.0),
      weight: 50.0,
    ),
  ]).animate(animationController);
  return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(scale: animation.value, child: widget);
      });
};
