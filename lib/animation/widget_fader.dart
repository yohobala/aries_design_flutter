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
