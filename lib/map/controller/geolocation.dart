/// 这是关于位置的组件
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

const geoLocationSettings =
    LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

/// 定位控制器的实现
///
/// *功能*
/// 1. 定位权限检测 [checkPermission]。
///   - 调用
///     - 构造函数
///     - 权限为[LocationPermission.denied]时
///     - 外部调用
///   - 作用
///     - 当检查权限后，会更新状态[_updateState]
///     - 如果开启了定位权限，则会开启监听位置变化[__registerLocationListener]
///     - 如果没有开启定位权限，则会停止监听位置变化[unregisterLocationListener]
/// 2. 得到当前GPS位置 [getPosition]
///   - 调用
///     - 外部调用
///   - 作用
///     - 如果初始化完成以及开启权限，则会调用[_posToLatLng]返回当前位置
///     - 否则会返回null
/// 3. 监听定位变化，用于更新位置、更新位置标记
///   - 开始监听[__registerLocationListener]
///     - 调用
///       - 检查完定位权限后，如果权限开启。则会开启监听
///     - 作用
///       - 更新位置[currentLocation]
///       - 更新位置标记[_drawMarker]
///       - 更新状态[_updateState]
///   - 停止监听[unregisterLocationListener]
///     - 调用
///       - 外部调用
///      - 权限为[LocationPermission.denied]时
///     - 作用
///       - 停止监听
class AriGeoLocationController {
  //-------- 构造函数 ---*
  /// 定位控制器的实现
  ///
  /// - `ariMapMarkerController`: 地图标记控制器
  AriGeoLocationController({
    this.ariMapMarkerController,
  }) : _ariMapMarkerController =
            ariMapMarkerController ?? AriMapMarkerController() {
    checkPermission();
  }

  //*************** 公有变量 ***************
  /// 定位是否可用
  ValueNotifier<bool> get isAvailable => _isAvailableNotifier;

  /// 标记控制器
  final AriMapMarkerController? ariMapMarkerController;

  //*************** 私有变量 ***************
  /// 地图标记控制器
  final AriMapMarkerController _ariMapMarkerController;

  /// 权限是否开启
  bool _isPermission = false;

  /// 是否初始化
  ///
  /// 因为定位是异步的，所以需要判断是否初始化完成，再判断权限是否开启
  final ValueNotifier<bool> _isInit = ValueNotifier<bool>(false);

  /// 当前位置
  ///
  /// 如果要在AriGeolocationController获得这个属性，要用向下转型（downcasting）
  /// ```dart
  /// AriGeolocationController test = AriGeolocationController();
  /// var i = (test as AriGeolocationControllerImpl).currentLocation;
  /// ```
  ValueNotifier<LatLng> currentLocation = ValueNotifier<LatLng>(LatLng(0, 0));

  /// 当前位置标记
  final AriMapMarker _postionMarker = AriMapMarker(
      key: defalutPositionMarkerKey,
      layerkey: defalutPositionMakerLayerKey,
      type: MarkerType.position);

  /// 位置流
  ///
  /// 用于监听位置的变化
  StreamSubscription<Position>? _positionStream;

  /// 定位服务是否可用
  final ValueNotifier<bool> _isAvailableNotifier = ValueNotifier(false);

  //*--- 公有方法 ---*
  /// 检查是否有定位权限
  ///
  /// 检测权限后，会返回一个[LocationPermission]类的实例，有以下几种情况：
  /// - `LocationPermission.denied`:
  /// 会递归调用,因为出现这种情况一般是弹出授权界面，所以要递归调用,但是选择后
  /// 就不会再出现[LocationPermission.denied]
  /// - `LocationPermission.deniedForever`:
  /// 会赋值[_isPermission]为false和[_isInit]为true
  /// - `LocationPermission.whileInUse`或`LocationPermission.always`:
  /// 会开启监听[__registerLocationListener]
  void checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    try {
      if (!_isPermission) {
        // 用户还没有选择是否开启位置访问权限
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          checkPermission();
        }
        // 用户永久拒绝了位置访问权限
        else if (permission == LocationPermission.deniedForever) {
          _updateState(false);
          unregisterLocationListener();
        }
        // 用户同意了本次使用位置访问权限或者永久允许了位置访问权限
        else if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          __registerLocationListener();
        }
      }
    } catch (e) {
      if (e.toString().contains(
          "Permission definitions not found in the app's Info.plist")) {
        logger.w("请在info.plist中添加权限");
      }
      _updateState(false);
    }
  }

  /// 获取当前GPS位置
  ///
  /// *return*
  /// - `当前位置`: 有权限
  /// - `null`: 没有权限
  ///
  /// 会根据初始化状态,进行以下不同操作:
  /// - `初始化完成`: 返回当前位置[_getPosition]
  /// - `初始化未完成`: 添加监听，等待初始化完成后，返回当前位置[_getPosition]
  Future<LatLng?> getPosition() async {
    if (_isInit.value) {
      return _getPosition();
    } else {
      Completer<LatLng?> completer = Completer<LatLng?>();
      initListener() {
        if (_isInit.value) {
          completer.complete(_getPosition());
          _isInit.removeListener(initListener);
        }
      }

      _isInit.addListener(initListener);
      return completer.future;
    }
  }

  /// 停止监听位置变化
  void unregisterLocationListener() {
    if (_positionStream != null) {
      _positionStream?.cancel();
      _positionStream = null;
    }
  }

  //*--- 私有方法 ---*
  /// 更新状态
  ///
  /// - `isPermission`: 权限是否开启
  /// - `isInit`: 是否初始化,默认为true
  void _updateState(bool isPermission, {bool isInit = true}) {
    if (_isPermission != isPermission || _isInit.value != isInit) {
      _isPermission = isPermission;
      _isInit.value = isInit;
      _isAvailableNotifier.value = isPermission && isInit;
    }
  }

  /// 开始监听位置变化
  ///
  /// 当位置变化后：
  /// - 更新当前位置[currentLocation]
  /// - 更新当前位置的标记 [_drawMarker]
  ///
  /// 会创建一个监听的流，但是这个创建会存在延迟，所以在监听未初始化成功时，当前位置为(0,0),
  /// 所以不能把[_updateState]放在监听器外面，因为获得位置有可能在初始化未成功的时候，
  /// 如果放在监听器外部，未初始化的时候获取位置，当[_updateState]改变了初始化状态，会直接获取当前位置，
  /// 然后监听器此时还未启动成功，所以位置是(0,0)
  void __registerLocationListener() async {
    _positionStream =
        Geolocator.getPositionStream(locationSettings: geoLocationSettings)
            .listen(
      (Position position) {
        // 更新当前位置
        currentLocation.value = _posToLatLng(position);

        // 更新当前位置的标记
        _drawMarker(currentLocation.value);

        _updateState(true);
      },
      onError: (error) {
        unregisterLocationListener();
        _updateState(false);
      },
    );
  }

  /// 得到当前位置
  ///
  /// *return*
  /// - `当前位置`: 如果有权限
  /// - `null`: 如果没有权限
  Future<LatLng?> _getPosition() async {
    if (_isPermission) {
      return currentLocation.value;
    } else {
      return null;
    }
  }

  /// [Position]转换为[LatLng]
  ///
  /// - `position`: 位置
  ///
  /// *return*
  /// - `位置`: [LatLng]类型的位置
  LatLng _posToLatLng(Position position) {
    LatLng latLng = LatLng(position.latitude, position.longitude);
    return latLng;
  }

  /// 绘制[_postionMarker]的位置
  ///
  /// - `latLng`: 经纬度
  ///
  /// 先对控制器进行判断，如果没有控制器，不会绘制
  void _drawMarker(LatLng latLng) {
    if (_ariMapMarkerController != null) {
      _postionMarker.updateLatLng(latLng);
      _ariMapMarkerController!.updateMaker(_postionMarker);
    }
  }
}
