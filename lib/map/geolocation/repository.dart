import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// 地理定位Repository
///
/// *功能*
/// 1. 定位权限检测 [checkPermission]。
///   - 调用
///     - 权限为[LocationPermission.denied]时
///     - 外部调用
///   - 作用
///     - 当检查权限后，会更新状态[_updateState]
/// 2. 得到当前GPS位置 [getLocation]
///   - 调用
///     - 外部调用
///   - 作用
///     - 如果初始化完成以及开启权限，则会调用[_posToLatLng]返回当前位置
///     - 否则会返回null
/// 3. 监听定位变化，用于更新位置、更新位置标记
///   - 获得位置流[locationStream]
///     - 调用
///       - 外部调用。先调用[checkPermission]检查完定位权限后，如果权限开启,则会开启监听.
///     - 作用
///       - 更新状态[_updateState]
///       - 获得定位流
///   - 停止监听[unregisterLocationListener]
///     - 调用
///       - 外部调用
///      - 权限为[LocationPermission.denied]时，注册定位监听会出现错误，会停止监听
///     - 作用
///       - 停止监听
class AriGeoLocationRepo {
  AriGeoLocationRepo({required this.deivce});

  final AriGeoLocationDevice deivce;

  /// 权限是否开启
  bool _isInit = false;

  /// 权限是否开启
  bool _isPermission = false;

  /***************  公有方法  ***************/

  /// 检查是否有定位权限
  ///
  /// 检测权限后，会返回一个[LocationPermission]类的实例，有以下几种情况：
  /// - `LocationPermission.denied`:
  /// 会递归调用,因为出现这种情况一般是弹出授权界面，所以要递归调用,但是选择后
  /// 就不会再出现[LocationPermission.denied]
  /// - `LocationPermission.deniedForever`:
  /// 会赋值[_isPermission]为false和[_isInit]为true
  /// - `LocationPermission.whileInUse`或`LocationPermission.always`:
  /// 会赋值[_isPermission]为true和[_isInit]为true
  Future<bool> checkPermission() async {
    try {
      if (!_isPermission) {
        LocationPermission permission = await deivce.checkPermission();
        // 用户还没有选择是否开启位置访问权限
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          return await checkPermission();
        }
        // 用户永久拒绝了位置访问权限
        else if (permission == LocationPermission.deniedForever) {
          _updateState(false);
          return false;
        }
        // 用户同意了本次使用位置访问权限或者永久允许了位置访问权限
        else if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          _updateState(true);
          return true;
        }

        return false;
      } else {
        return true;
      }
    } catch (e) {
      if (e.toString().contains(
          "Permission definitions not found in the app's Info.plist")) {
        logger.w("请在info.plist中添加权限");
      }
      _updateState(false);
      return false;
    }
  }

  /// 得到当前定位位置
  Future<LatLng> getLocation() async {
    LatLng latLng = await deivce.getCurrentLocation();

    return latLng;
  }

  /// 获得位置流
  ///
  /// 调用该方法前，先调用[checkPermission]检查完定位权限后，如果权限开启,则会开启监听.
  ///
  /// 当出现错误时，会停止监听，更新状态[_updateState]
  Stream<LatLng> get locationStream {
    deivce.registerLocationListener();

    return deivce.locationStream.handleError((error) {
      // 在这里处理错误，例如转换为自定义的异常并抛出
      unregisterLocationListener();
      _updateState(false);
    });
  }

  /// 停止监听位置流
  void unregisterLocationListener() {
    deivce.unregisterLocationListener();
  }

  /***************  私有方法  ***************/

  /// 更新状态
  ///
  /// - `isPermission`: 权限是否开启
  /// - `isInit`: 是否初始化,默认为true
  void _updateState(bool isPermission, {bool isInit = true}) {
    if (_isPermission != isPermission || _isInit != isInit) {
      _isPermission = isPermission;
      _isInit = isInit;
    }
  }
}
