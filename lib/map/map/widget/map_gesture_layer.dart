import 'dart:math';

import 'package:aries_design_flutter/map/map/bloc/index.dart';
import 'package:aries_design_flutter/map/map/model/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';

import '../util.dart';
import 'map.dart';
import 'marker.dart';
import 'polyline.dart';

class AriMapGestureLayer extends StatelessWidget {
  AriMapGestureLayer({
    Key? key,
    this.buildMarker,
    this.onTap,
    required this.tapDistanceTolerance,
  }) : super(key: key);

  final BuildMarker? buildMarker;

  final MapTapCallback? onTap;

  final double tapDistanceTolerance;

  @override
  Widget build(BuildContext context) {
    final mapState = FlutterMapState.maybeOf(context);
    if (mapState == null) {
      assert(false, 'No FlutterMapState found');
    }

    AriMapBloc mapBloc = context.read<AriMapBloc>();

    Map<Key, AriMapGesture> layers = mapBloc.gestureLayers;
    List<AriMapMarker> markers = [];
    List<AriMapPolyline> polylines = [];
    var layerList = layers.values.toList();

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        _handleTap(details, onTap, markers, polylines, mapState!);
      },
      child: Stack(
        children: layerList
            .where((layer) => layer.open)
            .map((layer) =>
                _build(context, layer, mapState!, markers, polylines))
            .toList(),
      ),
    );
    // Use `mapState` as necessary, for example `mapState.zoom`
  }

  Widget _build(
    BuildContext context,
    AriMapGesture layer,
    FlutterMapState map,
    List<AriMapMarker> markers,
    List<AriMapPolyline> polylines,
  ) {
    for (var item in layer.markers.values) {
      markers.add(item);
    }
    for (var item in layer.polylines.values) {
      polylines.add(item);
    }

    return Stack(
      children: [
        _buildPolyline(context, layer.key, layer.polylines, map),
        _buildMarker(context, layer.key, layer.markers, buildMarker, map)
      ],
    );
  }

  Widget _buildPolyline(
    BuildContext context,
    ValueKey<String> layerKey,
    Map<ValueKey<String>, AriMapPolyline> polylines,
    FlutterMapState map,
  ) {
    return AriMapPolylineLayer(
      layerKey: layerKey,
      polylines: polylines,
    );
  }

  Widget _buildMarker(
      BuildContext context,
      ValueKey<String> layerKey,
      Map<ValueKey<String>, AriMapMarker> markers,
      BuildMarker? buildMarker,
      FlutterMapState map) {
    return AriMapMarkerLayer(
      layerKey: layerKey,
      markers: markers,
      buildMarker: buildMarker,
    );
  }

  void _handleTap(
      TapUpDetails details,
      MapTapCallback? onTap,
      List<AriMapMarker> markers,
      List<AriMapPolyline> polylines,
      FlutterMapState mapState) {
    Map<double, List<AriMapMarker>> tappedMarkers = {};
    Map<double, List<AriMapPolyline>> tappedPolylines = {};

    var tap = details.localPosition;

    // 处理点
    for (AriMapMarker marker in markers) {
      final pxPoint = mapState.project(marker.latLng);
      final anchor = Anchor.fromPos(
        AnchorPos.align(AnchorAlign.center),
        marker.width,
        marker.height,
      );
      final rightPortion = marker.width - anchor.left;
      final bottomPortion = marker.height - anchor.top;
      final pos = pxPoint - mapState.pixelOrigin;

      _pointProximityCheck(
        tap,
        pos,
        rightPortion,
        bottomPortion,
        marker.width,
        marker.height,
        marker,
        tappedMarkers,
      );
    }

    // 处理线
    //
    // 首先获取实际的strokeWidth,borderStrokeWidth的宽度,再检查
    for (AriMapPolyline polyline in polylines) {
      if (polyline.points.length < 2) {
        continue;
      }
      double strokeWidth = getMapStrokeWidget(
        mapState,
        polyline.strokeWidth,
        polyline.useStrokeWidthInMeter,
        latLng: polyline.points[0],
      );
      double borderStrokeWidth = getMapStrokeWidget(
        mapState,
        polyline.borderStrokeWidth,
        polyline.useStrokeWidthInMeter,
        latLng: polyline.points[0],
      );
      for (var p = 0; p < polyline.points.length - 1; p++) {
        var point1 = mapState.getOffsetFromOrigin(polyline.points[p]);
        var point2 = mapState.getOffsetFromOrigin(polyline.points[p + 1]);
        double width = strokeWidth + borderStrokeWidth;
        if (_polylineProximityCheck(
          tap,
          point1,
          point2,
          width,
          polyline,
          tappedPolylines,
        )) {
          print("Polyline tapped!");
          break;
        }
      }
    }

    List<AriMapMarker> markerList = [];
    List<AriMapPolyline> polylineList = [];

    tappedMarkers.forEach((key, value) {
      markerList.addAll(value);
    });

    tappedPolylines.forEach((key, value) {
      polylineList.addAll(value);
    });

    onTap?.call(markerList, polylineList);
  }

  bool _pointProximityCheck(
      Offset tap,
      CustomPoint<double> pos,
      double rightPortion,
      double bottomPortion,
      double width,
      double height,
      AriMapMarker marker,
      Map<double, List<AriMapMarker>> tappedMarkers) {
    double tapX = tap.dx;
    double tapY = tap.dy;

    double leftBoundary = pos.x - rightPortion;
    double rightBoundary = pos.x - rightPortion + width;
    double topBoundary = pos.y - bottomPortion;
    double bottomBoundary = pos.y - bottomPortion + height;

    bool inside = tapX >= leftBoundary &&
        tapX <= rightBoundary &&
        tapY >= topBoundary &&
        tapY <= bottomBoundary;

    if (inside) {
      var minimum = min(height, tapDistanceTolerance + width);
      tappedMarkers[minimum] ??= <AriMapMarker>[];
      tappedMarkers[minimum]!.add(marker);
    }

    return inside;
  }

  /// 检查点击是否在线的附近
  ///
  /// 首先计算点到直线的距离
  ///
  /// 然后判断是否超过线的边界
  ///
  /// 最后进行边界检查,确保垂线交点落在线段 AB 上，而不是延长线上
  bool _polylineProximityCheck(
      Offset tap,
      Offset pointA,
      Offset pointB,
      double width,
      AriMapPolyline polyline,
      Map<double, List<AriMapPolyline>> tappedPolylines) {
    var a = calDistance(pointA, pointB);
    var b = calDistance(pointA, tap);
    var c = calDistance(pointB, tap);

    // 通过Heron's公式计算三角形面积
    var semiPerimeter = (a + b + c) / 2.0;
    var triangleArea = sqrt(semiPerimeter *
        (semiPerimeter - a) *
        (semiPerimeter - b) *
        (semiPerimeter - c));

    // 计算出点击的位置到线的距离
    var height = (2 * triangleArea) / a;

    // 判断点击位置到polyline中A,B两个点的距离中哪个更远
    var hypotenus = max(b, c);
    // 通过得到的远边和高度,反推出垂线点到polyline更远的点的距离
    var newTriangleBase = sqrt((hypotenus * hypotenus) - (height * height));

    // 这个可以判断垂线点是否在线段中
    var lengthDToOriginalSegment = newTriangleBase - a;

    if (height < tapDistanceTolerance + width &&
        lengthDToOriginalSegment < tapDistanceTolerance + width) {
      var minimum = min(height, tapDistanceTolerance + width);

      tappedPolylines[minimum] ??= <AriMapPolyline>[];
      tappedPolylines[minimum]!.add(polyline);
      return true;
    } else {
      return false;
    }
  }
}
