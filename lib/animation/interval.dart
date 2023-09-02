import 'package:flutter/material.dart';

/// 生成Interval
///
/// 用于已经设定好了内部动画的Interval，同时允许外部修改时间间隔
/// 当外部传入的是Interval(0.0,1.0),那意味着和内部设定的动画时间一致
///
/// *参数*
/// - `start`：内部动画开始值
/// - `end`：内部动画结束值
/// - `externalStart`：外部动画开始值
/// - `externalEnd`：外部动画结束值
/// - `curve`：动画曲线
Interval generateInterval(
  double start,
  double end,
  double externalStart,
  double externalEnd, {
  Curve curve = Curves.linear,
}) {
  return Interval(
    start + (end - start) * externalStart,
    start + (end - start) * externalEnd,
    curve: curve,
  );
}
