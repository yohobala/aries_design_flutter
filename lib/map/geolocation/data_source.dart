import 'dart:async';
import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

const geoLocationSettings =
    LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);

class AriGeoLocationDevice {
  Stream<LatLng> get locationStream => _locationStreamController.stream;

  /***************  私有变量  ***************/

  /// 使用 _locationStreamController 来创建自己的流
  final StreamController<LatLng> _locationStreamController =
      StreamController<LatLng>.broadcast();

  StreamSubscription<Position>? positionStream;

  bool _isOpenStream = false;

  LatLng _currentLocation = LatLng(0, 0);

  /***************  公有方法  ***************/

  /// 获取当前位置
  ///
  /// 如果开启了流，则会返回流中的位置
  Future<LatLng> getCurrentLocation() async {
    if (!_isOpenStream) {
      Position position = await Geolocator.getCurrentPosition();
      LatLng latLng = LatLng(position.latitude, position.longitude);
      _currentLocation = latLng;
      logger.t('getCurrentLocation: $_currentLocation');
      return latLng;
    } else {
      return _currentLocation;
    }
  }

  /// 检查是否有定位权限
  Future<LocationPermission> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission;
  }

  /// 开始监听位置变化
  void registerLocationListener() {
    if (!_isOpenStream) {
      Geolocator.getPositionStream(
        locationSettings: geoLocationSettings,
      ).listen(
        (Position position) {
          _isOpenStream = true;
          LatLng location = _posToLatLng(position);
          if (location != _currentLocation) {
            _currentLocation = location;
            _locationStreamController.add(location); // 向流中添加新的位置数据
          }

          // 其他逻辑...
        },
        onError: (error) {
          // 处理错误...
          _locationStreamController.addError(error);
        },
      );
    }

    // 当流不再使用时，取消订阅
    _locationStreamController.onCancel = () {
      positionStream?.cancel();
    };
  }

  /// 停止监听位置变化
  void unregisterLocationListener() {
    _locationStreamController.close();
  }

  /***************  私有方法  ***************/

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
}
