import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AriMapPolylineLayerModel {
  AriMapPolylineLayerModel({
    this.key = defalutPolylineLayerKey,
    required this.name,
    this.initPolylines = const [],
  }) {
    _initPolylines(initPolylines);
  }
  final Key key;

  final String name;

  final List<AriMapPolylineModel> initPolylines;

  Map<Key, AriMapPolylineModel> polylines = {};

  void updatePolyline(AriMapPolylineModel polyline) {
    polylines[polyline.key] = polyline;
  }

  void _initPolylines(List<AriMapPolylineModel> initPolylines) {
    for (final polyline in initPolylines) {
      polylines[polyline.key] = polyline;
    }
  }
}

class AriMapPolylineModel {
  AriMapPolylineModel({
    required this.key,
    Key? layerkey,
    this.points = const [],
    this.color = const Color(0xFF90CAF9),
    this.borderColor = const Color.fromARGB(255, 33, 150, 243),
    this.strokeWidth = 5.0,
    this.borderStrokeWidth = 5.0,
    this.onTap,
    this.selected = false,
  }) : _layerkey = layerkey ?? defalutPolylineLayerKey;

  /// polyline的key
  final Key key;

  /// polyline所属的layer的key
  Key get layerkey => _layerkey;

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

  /// 点击事件
  final MarkerTapCallback? onTap;

  /// 是否选中
  bool selected;

  final Key _layerkey;
}
