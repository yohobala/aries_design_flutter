import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

/// 页面淡入淡出切换动画控制器
///
/// 主要用于通过Offstage创建自定义的页面淡入淡出效果
///
/// 在调用该函数的页面中，需要继承TickerProviderStateMixin
///
///
List<AnimationController> pageFade(TickerProvider vsync, int length) {
  /// 页面切换动画
  AnimationController buildFaderController() {
    final AnimationController controller = AnimationController(
        vsync: vsync, duration: AriTheme.duration.pageDration, value: 0);
    return controller;
  }

  // 构建所有widget的动画控制器
  List<AnimationController> widgetFaders = List<AnimationController>.generate(
    length,
    (int index) => buildFaderController(),
  );

  return widgetFaders;
}

/// 用于AnimatedSwitcher的淡入淡出
///
/// 从屏幕右侧到左侧,同时有淡入效果
///
/// *示例代码*
/// ```dart
/// AnimatedSwitcher(
///   duration: Duration(seconds: 1),
///   child: someWidget,  // 你想要进行切换的widget
///   transitionBuilder: pageFadeAnimatedSwitcherBuilder,
/// )
/// ```
Widget Function(Widget child, Animation<double> animation)
    pageFadeAnimatedSwitcherBuilder =
    (Widget child, Animation<double> animation) {
  return SlideTransition(
    position: animation.drive(
      Tween<Offset>(
        begin: const Offset(1, 0.0),
        end: const Offset(0, 0),
      ),
    ),
    child: FadeTransition(
      opacity: animation.drive(
        CurveTween(
          curve: Curves.easeIn,
        ),
      ),
      child: child,
    ),
  );
};

/// widget缩放动画
///
/// - `scale`: 缩放的比例
/// - `reverse`: 是否反向,默认为false,false:从1 -> scale;true:从scale -> 1
Widget widgetScaleAnimatedBuilder(
  Widget widget,
  AnimationController animationController, {
  double scale = 0.5,
  reverse = false,
}) {
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
      return Transform.scale(scale: animation.value, child: widget);
    },
  );
}

Widget widgetVisibilityAnimatedBuilder(
  Widget widget,
  AnimationController animationController, {
  bool reverse = false,
}) {
  var animation = Tween<double>(
    begin: !reverse ? 0 : 1,
    end: !reverse ? 1 : 0,
  ).animate(animationController);
  // 返回一个 AnimatedBuilder 来根据动画值进行缩放
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      return Visibility(
        visible: animation.value > 0,
        child: Opacity(
          opacity: animation.value,
          child: widget,
        ),
      );
    },
  );
}
