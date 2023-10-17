import 'package:aries_design_flutter/key/map.dart';
import 'package:aries_design_flutter/map/map/model/index.dart';
import 'package:flutter/material.dart';

enum UpdateGestureType {
  name,
  marker,
  polyline,
  open,
  elevation,
}

class AriMapGesture {
  AriMapGesture({
    this.key = defalutGestureLayerKey,
    required this.name,
    required this.polylines,
    required this.markers,
    this.open = true,
    this.elevation = 1,
  });

  /// 图层的key
  ///
  /// 用于标记层的唯一性
  ///
  /// 如果为空，将默认为[defalutGestureLayerKey]。
  final ValueKey<String> key;

  /// 图层的名称
  String name;

  Map<ValueKey<String>, AriMapPolyline> polylines;

  Map<ValueKey<String>, AriMapMarker> markers;

  bool open;

  int elevation;
}

class GetGestureResult {
  GetGestureResult({
    required this.gesture,
    required this.isNew,
  });

  AriMapGesture gesture;

  bool isNew;
}
