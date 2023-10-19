import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'sort.dart';

typedef PolylineTapCallback = void Function(AriMapPolyline polyline);

class AriMapPolyline extends AriMapSort {
  AriMapPolyline({
    required this.key,
    this.layerkey = defalutGestureLayerKey,
    this.points = const [],
    this.color = const Color.fromRGBO(144, 202, 249, 1),
    this.borderColor = const Color.fromRGBO(33, 150, 243, 1),
    this.strokeWidth = 5.0,
    this.borderStrokeWidth = 2.0,
    this.selectedColor = const Color.fromARGB(255, 41, 137, 216),
    this.selectedBorderColor = const Color.fromARGB(255, 4, 113, 201),
    this.selectedStrokeWidth = 6.0,
    this.selectedBorderStrokeWidth = 3.0,
    this.useStrokeWidthInMeter = false,
    this.onTap,
    this.polylinePaintTime = 500,
    int order = 1,
    bool selected = false,
  }) : super(order: order, selected: selected);

  /// polyline的key
  final ValueKey<String> key;

  /// polyline所属的layer的key
  final ValueKey<String> layerkey;

  /// polyline的点
  List<LatLng> points;

  /// polyline的颜色
  Color color;

  /// polyline的边框颜色
  Color borderColor;

  /// polyline的宽度
  double strokeWidth;

  /// polyline的边框宽度
  double borderStrokeWidth;

  /// polyline的选中颜色
  Color selectedColor;

  /// polyline的选中边框颜色
  Color selectedBorderColor;

  /// polyline的选中宽度
  double selectedStrokeWidth;

  /// polyline的选中边框宽度
  double selectedBorderStrokeWidth;

  /// 是否使用米为单位的宽度,如果为true,会随着地图缩放而改变宽度
  bool useStrokeWidthInMeter;

  /// 点击事件
  final PolylineTapCallback? onTap;

  /// 绘制线的动画的时间(milliseconds)
  ///
  /// 当更新polyline的points会对更新的部分执行动画
  ///
  /// 如果只是在points最后添加一个点,那动画只是绘制当前最后一个点和新添加的点之前的线段
  ///
  /// 如果改变了当前已有的点,那么会重新绘制整个线
  final int polylinePaintTime;

  int get renderPointsHashCode => Object.hash(
        key,
        points,
      );

  int get renderHashCode => Object.hash(
        key,
        layerkey,
        color,
        borderColor,
        strokeWidth,
        borderStrokeWidth,
        useStrokeWidthInMeter,
        order,
        selected,
        originalIndex,
      );
}
