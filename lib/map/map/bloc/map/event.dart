import 'package:flutter/animation.dart';
import 'package:latlong2/latlong.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

abstract class AriMapEvent {}

/***************  初始化、权限有关事件 ***************/

/// {@template InitAriMapEvent}
/// 初始化
///
/// 在这里面会检查权限，并开启定位监听，
/// 但是因为定位需要时间，不能马上就发出[InitAriMapState]，
/// 这样会造成GoToPositionEvent失败
/// {@endtemplate}
class InitAriMapEvent extends AriMapEvent {}

/// 初始化完成
///
/// 开启了定位监听后，通过触发这个事件，发出[InitAriMapState]
class InitAriMapCompleteEvent extends AriMapEvent {}

/// {@template CheckGeoLocationAvailableEvent}
/// 检查是否支持定位
/// {@endtemplate}
class CheckGeoLocationAvailableEvent extends AriMapEvent {
  /// {@macro CheckGeoLocationAvailableEvent}
  CheckGeoLocationAvailableEvent();
}

/***************  地图有关事件  ***************/

/// 监听map的mapEventStream，当地图移动时，可以通知
///
/// emit:
/// - [IsCenterOnLocation]
class MapMoveEvent extends AriMapEvent {
  MapMoveEvent({
    required this.latLng,
  });
  final LatLng latLng;
}

/***************  位置有关事件  ***************/

class IsCenterOnLocationEvent extends AriMapEvent {
  IsCenterOnLocationEvent({
    required this.isCenter,
  });
  final bool isCenter;
}

/// 地图移动到指定位置
///
/// 如果[latLng]为空,则跳转到GPS定位位置,如果[zoom]为空,则会缩放到13
///
/// emit:
///  - [MapLocationState]
///  - [IsCenterOnLocation]
class MoveToLocationEvent extends AriMapEvent {
  MoveToLocationEvent({
    this.isAnimated = true,
    this.latLng,
    this.zoom,
    this.offset = Offset.zero,
  });

  bool isAnimated;

  LatLng? latLng;

  double? zoom;

  /// 地图中心点偏移量
  final Offset offset;
}

/// GPS定位发生改变
class ChangeLocationEvent extends AriMapEvent {
  ChangeLocationEvent({
    required this.latLng,
  });
  final LatLng latLng;
}

/// 更新定位标记
class UpdateLocationMarkerEvent extends AriMapEvent {
  UpdateLocationMarkerEvent({
    required this.latLng,
    required this.direction,
  });
  final LatLng? latLng;
  final double? direction;
}

class ChangeCompassEvent extends AriMapEvent {
  ChangeCompassEvent({
    required this.direction,
  });
  final double direction;
}

/***************  图层,标记有关事件  ***************/

/// 更新图层
class UpdateLayerEvent extends AriMapEvent {
  UpdateLayerEvent({
    required this.layers,
  });
  final List<AriLayerModel> layers;
}

/// 移动标记状态
///
/// [offset]参数和[mapController.move]的offset参数一样
///
class MoveMarkerStatusEvent extends AriMapEvent {
  MoveMarkerStatusEvent({
    required this.marker,
    this.offset = Offset.zero,
    required this.isStart,
  });
  final AriMapMarkerModel marker;
  final bool isStart;

  /// 地图中心点偏移量
  final Offset offset;
}
