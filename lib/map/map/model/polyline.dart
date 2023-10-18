import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

typedef PolylineTapCallback = void Function(AriMapPolyline polyline);

class AriMapPolyline {
  AriMapPolyline({
    required this.key,
    this.layerkey = defalutGestureLayerKey,
    this.points = const [],
    this.color = const Color(0xFF90CAF9),
    this.borderColor = const Color.fromARGB(255, 33, 150, 243),
    this.strokeWidth = 5.0,
    this.borderStrokeWidth = 2.0,
    this.useStrokeWidthInMeter = false,
    this.onTap,
    this.selected = false,
    this.polylinePaintTime = 2000,
  });

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

  /// 是否使用米为单位的宽度,如果为true,会随着地图缩放而改变宽度
  bool useStrokeWidthInMeter;

  /// 点击事件
  final PolylineTapCallback? onTap;

  /// 是否选中
  bool selected;

  /// 绘制线的动画的时间(milliseconds)
  ///
  /// 当更新polyline的points会对更新的部分执行动画
  ///
  /// 如果只是在points最后添加一个点,那动画只是绘制当前最后一个点和新添加的点之前的线段
  ///
  /// 如果改变了当前已有的点,那么会重新绘制整个线
  final int polylinePaintTime;

  int get renderPoints => Object.hash(
        key,
        points,
      );
}
