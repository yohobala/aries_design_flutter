import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

abstract class AriMapState {}

/***************  初始化、权限有关状态  ***************/

class InitAriMapBlocState extends AriMapState {}

/// 地图初始化完成
class InitAriMapState extends AriMapState {}

/// 更新是否支持定位
class UpdateGeoLocationAvailableState extends AriMapState {}

/***************  位置有关状态  ***************/

/// 地图进行定位，把地图中心点移动到GPS位置
class MoveToLocationState extends AriMapState {
  MoveToLocationState({
    required this.center,
    required this.zoom,
    required this.offset,
    required this.isAnimated,
  });

  /// 中心点
  final LatLng center;

  /// 缩放等级
  final double? zoom;

  final Offset offset;

  /// 动画控制器
  ///
  /// 如果为true，则会通过动画形式进行移动
  bool isAnimated;
}

/// 当前位置是否在地图中心
class IsCenterOnLocation extends AriMapState {
  IsCenterOnLocation({
    required this.isCenter,
  });

  /// 是否在中心
  final bool isCenter;
}

/// 当前定位改变
class ChangeLocation extends AriMapState {
  ChangeLocation({
    required this.latLng,
  });

  final LatLng latLng;
}

class ChangeCompassState extends AriMapState {
  ChangeCompassState({
    required this.direction,
  });
  final double direction;
}

/***************  图层有关状态  ***************/

/// 更新图层
class UpdateTileLayerState extends AriMapState {
  UpdateTileLayerState({
    required this.layers,
  });
  final List<AriTileLayerModel> layers;
}

class CreateGestureState extends AriMapState {
  CreateGestureState({
    required this.layer,
  });
  final AriMapGesture layer;
}

class UpdateGestureState extends AriMapState {
  UpdateGestureState({
    required this.layer,
    required this.type,
  });
  final AriMapGesture layer;

  final UpdateGestureType type;
}

/***************  标记有关状态  ***************/

class UpdateMarkerState extends AriMapState {
  UpdateMarkerState({
    required this.marker,
    required this.layerKey,
  });

  final ValueKey<String> layerKey;
  final AriMapMarker marker;
}

class CreateMarkerState extends AriMapState {
  CreateMarkerState({
    required this.marker,
    required this.layerKey,
  });

  final AriMapMarker marker;
  final ValueKey<String> layerKey;
}

class SelectdMarkerState extends AriMapState {
  SelectdMarkerState({
    required this.marker,
    required this.isSelected,
  });

  final AriMapMarker marker;
  final bool isSelected;
}

/***************  线有关状态  ***************/

class UpdatePolylineState extends AriMapState {
  UpdatePolylineState({
    required this.polyline,
    required this.layerKey,
  });

  final ValueKey<String> layerKey;
  final AriMapPolyline polyline;
}

class CreatePolylineState extends AriMapState {
  CreatePolylineState({
    required this.polyline,
    required this.layerKey,
  });

  final AriMapPolyline polyline;
  final ValueKey<String> layerKey;
}
