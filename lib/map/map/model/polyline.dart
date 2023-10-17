import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

// class AriMapPolylineLayerModel {
//   AriMapPolylineLayerModel({
//     this.key = defalutPolylineLayerKey,
//     required this.name,
//     this.initPolylines = const [],
//   }) {
//     _initPolylines(initPolylines);
//   }
//   final Key key;

//   final String name;

//   final List<AriMapPolylineModel> initPolylines;

//   Map<Key, AriMapPolylineModel> polylines = {};

//   void updatePolyline(AriMapPolylineModel polyline) {
//     polylines[polyline.key] = polyline;
//   }

//   void _initPolylines(List<AriMapPolylineModel> initPolylines) {
//     for (final polyline in initPolylines) {
//       polylines[polyline.key] = polyline;
//     }
//   }
// }

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
  final MarkerTapCallback? onTap;

  /// 是否选中
  bool selected;
}
