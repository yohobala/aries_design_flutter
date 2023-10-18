import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

double calDistance(Offset point1, Offset point2) {
  var distancex = (point1.dx - point2.dx).abs();
  var distancey = (point1.dy - point2.dy).abs();

  var distance = sqrt((distancex * distancex) + (distancey * distancey));

  return distance;
}

bool diffLatlng(LatLng latLng1, LatLng latLng2) {
  return latLng1.latitude != latLng2.latitude ||
      latLng1.longitude != latLng2.longitude;
}

/// 得到地图上元素绘制后的strokeWidth
///
/// - `strokeWidth`: 原始的strokeWidth
/// - `useStrokeWidthInMeter`: 是否随地图缩放改变
double getMapStrokeWidget(
  FlutterMapState map,
  double strokeWidth,
  bool useStrokeWidthInMeter, {
  LatLng? latLng,
}) {
  Offset getOffset(LatLng point) {
    return map.getOffsetFromOrigin(point);
  }

  if (useStrokeWidthInMeter) {
    assert(latLng != null);

    final firstOffset = map.getOffsetFromOrigin(latLng!);
    final r = const Distance().offset(
      latLng,
      strokeWidth,
      180,
    );
    final delta = firstOffset - getOffset(r);

    strokeWidth = delta.distance;
  } else {
    strokeWidth = strokeWidth;
  }

  return strokeWidth;
}
