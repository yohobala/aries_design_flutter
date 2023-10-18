// ignore_for_file: prefer_final_fields

import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

/// 标记的类型
enum MarkerType {
  /// 普通标记
  normal,

  /// 位置标记
  location,

  image,

  label,

  icon,

  unknown,
}

typedef MarkerTapCallback = void Function(AriMapMarker marker);

typedef BuildMarker = Widget Function(AriMapMarker marker);

/// 标记的实现
///
/// 如果需要添加属性,先继承AriMapMarkerModel,之后使用[as]
///
class AriMapMarker {
  /// 地图中的标记
  ///
  /// - `key`: marker的key。如果为空，将默认为`UniqueKey().toString()`。
  /// - `layerkey`: marker所属的层的key。如果为空，将默认为[defalutGestureLayerKey]。
  /// - `latLng`: marker的坐标。如果为空，将默认为`LatLng(0, 0)`。
  /// - `direction`: marker的方向。默认为null。
  /// - `width`: marker的宽度。默认为80。这个限制的是marker的最大宽度,内部widget的宽度将不会超过这个尺寸
  /// - `height`: marker的高度。默认为80。这个限制的是marker的最大高度,内部widget的高度将不会超过这个尺寸
  /// - `type`: marker的类型。默认为[MarkerType.normal]。
  AriMapMarker({
    required this.key,
    this.layerkey = defalutGestureLayerKey,
    LatLng? latLng,
    this.direction,
    double width = 150,
    double height = 150,
    MarkerType type = MarkerType.normal,
    this.onTap,
    this.selected = false,
  })  : latLng = latLng ?? LatLng(0, 0),
        _width = width,
        _height = height,
        _type = type;

  /// marker的key
  final ValueKey<String> key;

  /// marker所属的层的key
  final ValueKey<String> layerkey;

  /// 用于构建marker的key
  ///
  /// 在需要识别是否点击marker的时候，需要使用这个key,否则无法识别
  ///
  /// 请注意!!!请把这个key放入正好需要Gesture的widget中,不要放在大尺寸的widget中
  ///
  /// *示例代码*
  /// SizedBox(
  ///    width: 150,
  ///    height: 150,
  ///    child: Center(
  ///      child: Padding(
  ///        padding: const EdgeInsets.only(bottom: 25.0),
  ///        child: GestureDetector(
  ///          key: marker.builderKey,
  ///          onTap: () {}, // 空操作，确保 GestureDetector 创建一个 RenderBox
  ///          child: Container(
  ///            width: 50,
  ///            height: 50,
  ///            decoration: BoxDecoration(
  ///              color: Colors.red,
  ///              shape: BoxShape.circle,
  ///            ),
  ///            child: Center(
  ///                child: Container(
  ///              child: child,
  ///            )),
  ///          ),
  ///        ),
  ///      ),
  ///    ),
  ///  );
  /// 上面的代码会制作150*150的容器,内部有一个居中的50*50的圆形容器,
  /// 但是点击事件只是会在50*50的圆形容器中生效
  final GlobalKey builderKey = GlobalKey();

  /// marker的坐标
  LatLng latLng;

  /// marker的所指向的方向
  double? direction;

  /// marker的宽度
  double get width => _width;

  /// marker的高度
  double get height => _height;

  /// marker的类型
  MarkerType get type => _type;

  /// marker的点击事件
  final MarkerTapCallback? onTap;

  /// marker是否被选中
  bool selected;

  late double _width;

  late double _height;

  late MarkerType _type;
}
