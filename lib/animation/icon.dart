import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/widgets.dart';

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
        {double scale = 0.5, reverse = false, bool signle = false}) {
  if (!signle) {
    var begin = !reverse ? 1.0 : scale;
    var end = !reverse ? scale : 1.0;
    var animation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(animationController);
    // 返回一个 AnimatedBuilder 来根据动画值进行缩放
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Visibility(
            visible: animation.value > scale,
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

/// 用于切换图标的动画
List<AnimationController> ariIconSwitchAnimationController(
    TickerProvider vsync, int length,
    {Duration? duration}) {
  /// 页面切换动画
  AnimationController buildController() {
    final AnimationController controller = AnimationController(
      vsync: vsync,
      duration: duration ?? AriTheme.duration.fast3,
    );
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
