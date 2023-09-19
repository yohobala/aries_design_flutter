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

typedef MarkerTapCallback = void Function(AriMarkerModel marker);

class AriMarkerLayerModel {
  AriMarkerLayerModel({
    this.key = defalutMakerLayerKey,
    this.initMarkers = const [],
    required this.name,
  }) {
    _initMarkers(initMarkers);
  }

  /// 标记层的key
  ///
  /// 用于标记层的唯一性
  ///
  /// 如果为空，将默认为[defalutMakerLayerKey]。
  final Key key;

  /// 标记层的名称
  final String name;

  /// 该标记层的初始标记，默认为[]
  final List<AriMarkerModel> initMarkers;

  /// 标记层的所有标记
  Map<Key, AriMarkerModel> markers = {};

  /// 更新标记
  ///
  /// 如果标记不存在，将会创建新的标记
  void updateMarker(AriMarkerModel marker) {
    markers[marker.key] = marker;
  }

  /// 初始化标记
  ///
  /// - `initMarkers`: 初始化的标记
  void _initMarkers(List<AriMarkerModel> initMarkers) {
    for (var m in initMarkers) {
      final marker = <Key, AriMarkerModel>{m.key: m};
      markers.addEntries(marker.entries);
    }
  }
}

/// 标记的实现
///
/// 如果需要添加属性,先继承AriMarkerModel,之后使用[as]
///
class AriMarkerModel {
  /// 地图中的标记
  ///
  /// - `key`: marker的key。如果为空，将默认为`UniqueKey().toString()`。
  /// - `layerkey`: marker所属的层的key。如果为空，将默认为[defalutMakerLayerKey]。
  /// - `latLng`: marker的坐标。如果为空，将默认为`LatLng(0, 0)`。
  /// - `direction`: marker的方向。默认为null。
  /// - `width`: marker的宽度。默认为80。这个限制的是marker的最大宽度,内部widget的宽度将不会超过这个尺寸
  /// - `height`: marker的高度。默认为80。这个限制的是marker的最大高度,内部widget的高度将不会超过这个尺寸
  /// - `type`: marker的类型。默认为[MarkerType.normal]。
  AriMarkerModel({
    required this.key,
    Key? layerkey,
    LatLng? latLng,
    this.direction,
    double width = 150,
    double height = 150,
    MarkerType type = MarkerType.normal,
    this.onTap,
    this.selected = false,
  })  : _layerkey = layerkey ?? defalutMakerLayerKey,
        latLng = latLng ?? LatLng(0, 0),
        _width = width,
        _height = height,
        _type = type;

  /// marker的key。如果为空，将默认为`UniqueKey().toString()`
  final Key key;

  Key get layerkey => _layerkey;

  LatLng latLng;

  double? direction;

  double get width => _width;

  double get height => _height;

  MarkerType get type => _type;

  final MarkerTapCallback? onTap;

  bool selected;

  final Key _layerkey;

  late double _width;

  late double _height;

  late MarkerType _type;
}
