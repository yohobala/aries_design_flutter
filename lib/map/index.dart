/// Use of this source code is governed by MIT license that
/// can be found in the LICENSE file.
export 'controller/index.dart';
export 'widgets/index.dart';
export 'core/index.dart';
export 'widgets/map.dart';

import 'package:latlong2/latlong.dart';

/// 地图缩放的回调
///
/// - `zoom`: 当前地图缩放等级
typedef ZoomChangedCallback = Function(double zoom);

/// 定位按钮点击回调
///
/// - `status`: 是否定位成功
typedef LocationButtonCallBack = Function(bool status);

typedef MapVoidCallback = void Function(LatLng latLng);

/// 定位按钮的状态
enum LocationButtonEnum {
  /// 当地图中心偏离当前GPS位置时
  offset,

  /// 当地图中心是GPS位置时
  aligned,

  /// 当前GPS位置不可用时
  unauthorized
}

/// 标记的类型
enum MarkerType {
  /// 普通标记
  normal,

  /// 位置标记
  position,
}
