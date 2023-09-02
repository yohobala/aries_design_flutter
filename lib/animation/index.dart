export 'widget_fader.dart';
export 'interval.dart';
export 'icon.dart';

import 'package:flutter/material.dart';

/// 动画回调
///
/// *参数*
/// - `child` 需要动画的控件
/// - `animationController` 动画控制器
typedef AriAnimationCallback = Widget Function(
    Widget child, AnimationController animationController);
