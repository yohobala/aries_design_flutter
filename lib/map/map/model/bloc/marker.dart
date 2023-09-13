// ignore_for_file: prefer_final_fields

import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

/// 标记的类型
enum MarkerType {
  /// 普通标记
  normal,

  /// 位置标记
  position,
}

class AriMarkerLayerModel {
  AriMarkerLayerModel({
    this.key = defalutMakerLayerKey,
    this.initMarkers = const [],
    required this.name,
  }) {
    _initMarkers(initMarkers);
  }

  //**************** 公有变量 ****************
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

  //**************** 私有方法 ****************
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
/// *功能*
/// 1. 更新标记的坐标[updateLatLng]
///   - 调用
///     - 外部调用
///   - 作用
///     - 更新标记的坐标
class AriMarkerModel {
  /// 地图中的标记
  ///
  /// - `key`: marker的key。如果为空，将默认为`UniqueKey().toString()`。
  /// - `layerkey`: marker所属的层的key。如果为空，将默认为[defalutMakerLayerKey]。
  /// - `latLng`: marker的坐标。如果为空，将默认为`LatLng(0, 0)`。
  /// - `width`: marker的宽度。默认为80。
  /// - `height`: marker的高度。默认为80。
  /// - `type`: marker的类型。默认为[MarkerType.normal]。
  AriMarkerModel({
    required this.key,
    Key? layerkey,
    LatLng? latLng,
    double width = 80,
    double height = 80,
    MarkerType type = MarkerType.normal,
  })  : _layerkey = layerkey ?? defalutMakerLayerKey,
        _latLng = latLng ?? LatLng(0, 0),
        _width = width,
        _height = height,
        _type = type;
  //**************** 公有变量 ****************
  /// marker的key。如果为空，将默认为`UniqueKey().toString()`
  final Key key;

  Key get layerkey => _layerkey;

  LatLng get latLng => _latLng;

  double get width => _width;

  double get height => _height;

  MarkerType get type => _type;

  /**************** 私有变量 ***************/

  final Key _layerkey;

  late LatLng _latLng;

  late double _width;

  late double _height;

  late MarkerType _type;

  /**************** 公有方法 ***************/

  /// 更新marker的坐标
  ///
  /// - `newLatLng`: 新的坐标
  ///
  /// 在操作完成后会对changeNotifier自增
  void updateLatLng(LatLng newLatLng) {
    _latLng = newLatLng;
  }
}
