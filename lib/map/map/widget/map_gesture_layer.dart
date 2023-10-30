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

class AriMapGestureLayer extends StatefulWidget {
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
  State<AriMapGestureLayer> createState() => _AriMapGestureLayer();
}

class _AriMapGestureLayer extends State<AriMapGestureLayer> {
  final ValueNotifier<int> rebuild = ValueNotifier(0);

  final GlobalKey gestureLayerKey = GlobalKey();

  late AriMapBloc mapBloc;

  @override
  void initState() {
    super.initState();
    mapBloc = context.read<AriMapBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Map<Key, AriMapGesture> layers = mapBloc.gestureLayers;
    List<AriMapMarker> markers = [];
    List<AriMapPolyline> polylines = [];
    List<AriMapGesture> layerList = layers.values.toList();

    return GestureDetector(
      key: gestureLayerKey,
      onTapUp: (TapUpDetails details) {
        _handleTap(context, details, widget.onTap, markers, polylines);
      },
      child: BlocListener<AriMapBloc, AriMapState>(
        bloc: mapBloc,
        listener: (context, state) {
          if (state is CreateGestureState || state is UpdateGestureState) {
            layers = mapBloc.gestureLayers;
            layerList = layers.values.toList();
            rebuild.value += 1; // 修改 ValueNotifier 的值
          }
        },
        child: ValueListenableBuilder<int>(
          valueListenable: rebuild,
          builder: (context, rebuild, child) {
            return Stack(
              children: layerList
                  .where((layer) => layer.open)
                  .map((layer) => _build(context, layer, markers, polylines))
                  .toList(),
            );
          },
        ),
      ),
    );
    // Use `mapState` as necessary, for example `mapState.zoom`
  }

  Widget _build(
    BuildContext context,
    AriMapGesture layer,
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
        _buildPolyline(context, layer.key, layer.polylines),
        _buildMarker(context, layer.key, layer.markers, widget.buildMarker),
      ],
    );
  }

  Widget _buildPolyline(BuildContext context, ValueKey<String> layerKey,
      Map<ValueKey<String>, AriMapPolyline> polylines) {
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
  ) {
    return AriMapMarkerLayer(
      layerKey: layerKey,
      markers: markers,
      buildMarker: buildMarker,
    );
  }

  void _handleTap(
      BuildContext context,
      TapUpDetails details,
      MapTapCallback? onTap,
      List<AriMapMarker> markers,
      List<AriMapPolyline> polylines) {
    Map<double, List<AriMapMarker>> tappedMarkers = {};
    Map<double, List<AriMapPolyline>> tappedPolylines = {};

    final mapState = FlutterMapState.maybeOf(context);
    if (mapState == null) {
      assert(false, 'No FlutterMapState found');
    }

    var tap = details.localPosition;

    // 处理点
    for (AriMapMarker marker in markers) {
      if (marker.builderKey.currentContext == null) {
        continue;
      }
      final RenderBox box =
          marker.builderKey.currentContext!.findRenderObject() as RenderBox;
      final Offset localOffset = box.globalToLocal(details.globalPosition);

      // 检查点击位置是否在 Positioned 内部
      if (localOffset.dx >= 0 &&
          localOffset.dx <= box.size.width &&
          localOffset.dy >= 0 &&
          localOffset.dy <= box.size.height) {
        var distance = calDistance(tap, localOffset);
        tappedMarkers[distance] ??= <AriMapMarker>[];
        tappedMarkers[distance]!.add(marker);
      }
    }

    // 处理线
    //
    // 首先获取实际的strokeWidth,borderStrokeWidth的宽度,再检查
    for (AriMapPolyline polyline in polylines) {
      if (polyline.points.length < 2) {
        continue;
      }
      double strokeWidth = getMapStrokeWidget(
        mapState!,
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

  /// 检查点击是否在点的附近
  ///
  /// 但是这个有缺陷!!!
  ///
  /// 当[AriMapMarker]的[width]和[height]远远大于buildMarker的元素尺寸时,
  /// 会造成即使没有点击到buildMarker的元素,也会触发点击事件
  bool pointProximityCheck(
    FlutterMapState mapState,
    Offset tap,
    AriMapMarker marker,
    Map<double, List<AriMapMarker>> tappedMarkers,
  ) {
    final pxPoint = mapState.project(marker.latLng);
    final anchor = Anchor.fromPos(
      AnchorPos.align(AnchorAlign.center),
      marker.width,
      marker.height,
    );
    final rightPortion = marker.width - anchor.left;
    final bottomPortion = marker.height - anchor.top;
    final pos = pxPoint - mapState.pixelOrigin;
    final double width = marker.width;
    final double height = marker.height;

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
      var minimum = min(height, widget.tapDistanceTolerance + width);
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

    if (height < widget.tapDistanceTolerance + width &&
        lengthDToOriginalSegment < widget.tapDistanceTolerance + width) {
      var minimum = min(height, widget.tapDistanceTolerance + width);

      tappedPolylines[minimum] ??= <AriMapPolyline>[];
      tappedPolylines[minimum]!.add(polyline);
      return true;
    } else {
      return false;
    }
  }
}
