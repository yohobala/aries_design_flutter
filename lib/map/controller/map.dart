import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

const double initZoom = 13.0;

/// 地图控制器的实现
///
/// *功能*
/// 1. 地图中心跳转到指定位置[goToPosition]
///   - 调用
///     - 外部调用
///   - 作用
///     - 如果有传入位置，则跳转到指定位置
///     - 否则跳转到当前GPS位置
/// 2. 改变地图中心状态[changeMapCenterStatus]
///   - 调用
///     - 外部调用
///     - [AriMapState]中监听地图事件["MapEventMoveEnd"]会触发
///     - [goToPosition]会触发
///
/// *示例代码*
/// ```dart
/// final AriMapController ariMapController =
///     AriMapController(
///       center: LatLng(39.904989, 116.405285),
///       initMarkerLayers: [
///         AriMapMarkerLayer(
///           key: "test1",
///           name: "测试图层1",
///           initMarkers: [
///             AriMapMarker(latLng: LatLng(26.19, 118.6)),
///           ]),
///         AriMapMarkerLayer(
///           key: "test2",
///           name: "测试图层2")
///       ],
///     );
/// ```
class AriMapController {
  //*--- 构造函数 ---*
  /// 地图控制器，用于地图组件的控制
  ///
  /// - `zoom`: 当前缩放级别，默认13.0
  /// - `maxZoom`: 最大缩放级别，默认18
  /// - `minZoom`: 最小缩放级别，默认1
  /// - `center`: 中心点，默认`LatLng(0, 0)`
  /// - `initMarkerLayers`: 初始化的标记层，默认为空
  AriMapController(
      {double zoom = 13.0,
      double maxZoom = 18,
      double minZoom = 1,
      LatLng? center,
      this.initMarkerLayers = const []})
      : _zoom = ValueNotifier<double>(zoom),
        _maxZoom = ValueNotifier<double>(maxZoom),
        _minZoom = ValueNotifier<double>(minZoom),
        _center = ValueNotifier<LatLng>(center ?? LatLng(0, 0));

  //*--- 公有变量 ---*
  /// 当前缩放级别
  double get zoom => _zoom.value;

  /// 最大缩放级别
  double get maxZoom => _maxZoom.value;

  /// 最小缩放级别
  double get minZoom => _minZoom.value;

  /// 当前地图的中心点坐标
  LatLng get center => _center.value;

  /// 地图中心是否是GPS位置
  ValueNotifier<bool> get isCenterOnPostion => _isCenterOnPostion;

  /// 定位是否可用
  ValueNotifier<bool> get isGeoLocationAvailable => _isGeoLocationAvailable;

  ///地图控制器
  MapController? get mapController => _mapController;

  /// 定位控制器
  AriGeoLocationController? get geoLocationController => _geoLocationController;

  /// 标记控制器
  AriMapMarkerController? get markerController => _markerController;

  /// 初始化的标记层
  final List<AriMapMarkerLayer> initMarkerLayers;

  //*--- 私有变量 ---*
  /// 当前缩放级别
  final ValueNotifier<double> _zoom;

  /// 最大缩放级别
  final ValueNotifier<double> _maxZoom;

  /// 最小缩放级别
  final ValueNotifier<double> _minZoom;

  /// 中心点
  final ValueNotifier<LatLng> _center;

  final ValueNotifier<bool> _isCenterOnPostion = ValueNotifier<bool>(false);

  final ValueNotifier<bool> _isGeoLocationAvailable =
      ValueNotifier<bool>(false);

  /// 地图控制器
  ///
  /// 为了初始化一次
  MapController? get _mapController => _mapControllerBacking;
  MapController? _mapControllerBacking;
  set _mapController(MapController? value) {
    _mapControllerBacking ??= value;
  }

  AriGeoLocationController? _geoLocationControllerBacking;
  AriGeoLocationController? get _geoLocationController =>
      _geoLocationControllerBacking;
  set _geoLocationController(AriGeoLocationController? value) {
    _geoLocationControllerBacking ??= value;
  }

  AriMapMarkerController? _markerControllerBacking;
  AriMapMarkerController? get _markerController => _markerControllerBacking;
  set _markerController(AriMapMarkerController? value) {
    _markerControllerBacking ??= value;
  }

  //*--- 公有方法 ---*
  /// 初始化控制器
  void initController(
      {MapController? mapController,
      AriGeoLocationController? geoLocationController,
      AriMapMarkerController? markerController}) {
    if (mapController != null) {
      if (_mapController == null) {
        _mapController = mapController;
        // 添加地图监听
        //
        // mapEventStream长按获得坐标是地图中心，不是长按的坐标，
        // 所以在[build]中创建onLongPress来监听
        mapController.mapEventStream.listen((evt) {
          if (evt.source == MapEventSource.dragEnd) {
            changeMapCenterStatus(false);
            _center.value = evt.center;
          }
        });
      } else {
        throw Exception("mapController已经初始化");
      }
    }
    if (geoLocationController != null) {
      if (_geoLocationController == null) {
        _geoLocationController = geoLocationController;
        _geoLocationController!.isAvailable.addListener(() {
          _updateGeoLocationAvailable();
        });
      } else {
        throw Exception("geoLocationController已经初始化");
      }
    }
    if (markerController != null) {
      if (_markerController == null) {
        _markerController = markerController;
      } else {
        throw Exception("markerController已经初始化");
      }
    }
  }

  /// 地图中心跳转到指定位置
  ///
  /// - `animationController`: 动画控制器
  /// - `latLng`: 经纬度
  ///
  /// 首先会判断是否有[geoLocationController]和[mapController] :
  /// - `没有`: 直接结束
  ///
  /// 判断是否传入[LatLng] :
  /// - `有传入`: 使用传入的latLng
  /// - `没有传入`: 使用当前定位的位置
  /// - `定位失败`: 使用[center]
  ///
  /// 判断是否传入[animationController] :
  /// - `有animationController`: 通过动画控制器实现平滑跳转，会有一个缓慢的移动和缩放效果
  /// - `没有animationController`: 直接跳转，不平滑
  void goToPosition(
      {AnimationController? animationController, LatLng? latLng}) async {
    if (geoLocationController != null && mapController != null) {
      // 移动位置
      latLng = latLng ?? await geoLocationController!.getPosition() ?? center;
      _center.value = latLng;
      if (animationController != null) {
        /// 纬度跳转区间
        final latTween = Tween<double>(
            begin: mapController!.center.latitude, end: latLng.latitude);

        /// 经度跳转区间
        final lngTween = Tween<double>(
            begin: mapController!.center.longitude, end: latLng.longitude);

        /// 缩放跳转区间
        final zoomTween =
            Tween<double>(begin: mapController!.zoom, end: initZoom);

        /// 动画设置
        final Animation<double> animation = CurvedAnimation(
            parent: animationController, curve: Curves.fastOutSlowIn);

        animationController.addListener(() {
          _mapFlyToPostion(animation, latTween, lngTween, zoomTween);
        });
        animation.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animationController.dispose();
          } else if (status == AnimationStatus.dismissed) {
            animationController.dispose();
          }
        });
        animationController.forward();
      } else {
        mapController!.move(latLng, initZoom);
      }
      // 改变地图中心
      changeMapCenterStatus(true);
    }
  }

  /// 地图中心是否是GPS位置
  ///
  /// - `isCenterOnPostion`: 是否是GPS位置
  ///
  /// 如果定位不能用，则不改变状态
  ///
  /// 当地图滑动等事件触发的时候，可以调用这个方法，改变[isCenterOnPostion]状态
  void changeMapCenterStatus(bool isCenterOnPostion) {
    if (isGeoLocationAvailable.value) {
      _isCenterOnPostion.value = isCenterOnPostion;
    }
  }

  //*--- 私有方法 ---*
  /// 地图通过平滑地平移和缩放到指定的位置
  ///
  /// - `animation`: 动画控制器
  /// - `latTween`: 纬度跳转区间
  /// - `lngTween`: 经度跳转区间
  /// - `zoomTween`: 缩放跳转区间
  ///
  /// 通过 Tween 类的 evaluate 方法实现动画效果。
  ///
  /// Tween 类的 evaluate 方法用于根据动画对象的当前状态计算出中间值。
  /// 这个方法通常接收一个 Animation<double> 对象作为参数。
  /// ```dart
  /// final Tween<double> tween = Tween<double>(begin: 0, end: 200);
  /// final AnimationController controller = AnimationController(
  ///  duration: const Duration(seconds: 2),
  ///  vsync: this, // 'this' would typically refer to a State object that is a TickerProvider
  /// );
  /// controller.forward();
  /// print(tween.evaluate(controller)); // 输出依赖于controller当前的值
  /// ```
  void _mapFlyToPostion(Animation<double> animation, Tween<double> latTween,
      Tween<double> lngTween, Tween<double> zoomTween) {
    try {
      mapController!.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    } catch (e) {
      print(e);
    }
  }

  /// 更新定位状态
  ///
  /// 通过监听[geoLocationController]的[isAvailable]来更新定位状态
  void _updateGeoLocationAvailable() {
    _isGeoLocationAvailable.value = geoLocationController!.isAvailable.value;
  }
}
