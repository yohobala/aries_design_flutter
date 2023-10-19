import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'model/sort.dart';

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

void sortList(List<AriMapSort> items) {
  items.sort((a, b) {
    // 记录原始顺序
    for (var i = 0; i < items.length; i++) {
      items[i].originalIndex = i;
    }
    // 如果两者都被选中或都未被选中
    if (a.selected == b.selected) {
      // 按 order 排序
      if (a.order == b.order) {
        // 如果 order 相同，使用原始列表的顺序
        return a.originalIndex.compareTo(b.originalIndex);
      }
      return a.order.compareTo(b.order);
    }

    // 如果一个被选中，另一个未被选中，把被选中的放在后面
    if (a.selected && !b.selected) {
      return 1;
    } else if (!a.selected && b.selected) {
      return -1;
    } else {
      return 0;
    }
  });
}
