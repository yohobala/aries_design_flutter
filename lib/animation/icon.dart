import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/widgets.dart';

import 'index.dart';

/// 用于切换图标的动画
///
/// 比如可以用在button点击后图标切换上,例如[AriIconButton]中就使用
///
/// *参数*
/// - `child` 需要动画的控件
/// - `animationController` 动画控制器
///
/// *示例代码*
/// 多个图标切换
/// ```dart
/// bool isSelected = i == widget.selectIndex.value;
/// var animation = ariIconSwitchAnimatedBuilder(
///   widget.icons[i],
///   _animationControllers[i],
///   reverse: !isSelected,
/// );
/// ```
Widget Function(Widget child, AnimationController animationController,
        {double scale,
        bool reverse,
        bool signle}) ariIconSwitchAnimatedBuilder =
    (Widget widget, AnimationController animationController,
        {double scale = 0.7, reverse = false, bool signle = false}) {
  if (!signle) {
    var begin = !reverse ? 1.0 : scale;
    var end = !reverse ? scale : 1.0;
    print(reverse);
    print(begin);
    print(end);
    var animation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(animationController);
    // 返回一个 AnimatedBuilder 来根据动画值进行缩放
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Visibility(
            visible: animation.value > scale, // 根据实际需求来设置这个条件
            child: Transform.scale(scale: animation.value, child: widget),
          );
        });
  } else {
    // 创建一个 TweenSequence 来管理两段动画
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
  }
};

/// 页面淡入淡出切换动画控制器
///
/// 主要用于通过Offstage创建自定义的页面淡入淡出效果
///
/// 在调用该函数的页面中，需要继承TickerProviderStateMixin
///
///
List<AnimationController> ariIconSwitchAnimationController(
    TickerProvider vsync, int length) {
  /// 页面切换动画
  AnimationController buildController() {
    final AnimationController controller = AnimationController(
        vsync: vsync, duration: AriTheme.duration.buttonScaleDuration);
    return controller;
  }

  // 构建所有widget的动画控制器
  List<AnimationController> animationControllers =
      List<AnimationController>.generate(
    length,
    (int index) => buildController(),
  );

  return animationControllers;
}
