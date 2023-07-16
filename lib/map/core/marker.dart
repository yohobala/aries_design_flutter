import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

/// 地图标记图层
class AriMapMarkerLayer {
  //*--- 构造函数 ---*
  /// 地图标记图层
  ///
  /// - `key`: 标记层的key。如果为空，将默认为[defalutMakerLayerKey]。
  /// - `initMarkers`: 初始化的标记。默认为空。
  /// - `name`: 标记层的名称。默认为空。
  AriMapMarkerLayer({
    this.key = defalutMakerLayerKey,
    this.initMarkers = const [],
    required this.name,
  }) {
    _initMarkers(initMarkers);
  }

  //*--- 公有变量 ---*
  /// 标记层的key
  ///
  /// 用于标记层的唯一性
  final String key;

  /// 标记层的名称
  final String name;

  /// 该标记层的所有的标记
  final List<AriMapMarker> initMarkers;

  /// 标记层的所有标记
  Map<String, AriMapMarker> markers = {};

  /// 是否需要更新，用于外部监听数据变化
  final ValueNotifier<int> changeNotifier = ValueNotifier(0);

  //*--- 私有方法 ---*
  /// 初始化标记
  ///
  /// - `initMarkers`: 初始化的标记
  void _initMarkers(List<AriMapMarker> initMarkers) {
    for (var m in initMarkers) {
      final marker = <String, AriMapMarker>{m.key: m};
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
class AriMapMarker {
  //*--- 构造函数 ---*
  /// 地图中的标记
  ///
  /// - `key`: marker的key。如果为空，将默认为`UniqueKey().toString()`。
  /// - `layerkey`: marker所属的层的key。如果为空，将默认为[defalutMakerLayerKey]。
  /// - `latLng`: marker的坐标。如果为空，将默认为`LatLng(0, 0)`。
  /// - `width`: marker的宽度。默认为80。
  /// - `height`: marker的高度。默认为80。
  /// - `type`: marker的类型。默认为[MarkerType.normal]。
  AriMapMarker({
    String? key,
    String? layerkey,
    LatLng? latLng,
    double width = 80,
    double height = 80,
    MarkerType type = MarkerType.normal,
  })  : _key = key?.toString() ?? UniqueKey().toString(),
        _layerkey = layerkey ?? defalutMakerLayerKey,
        _latLng = latLng ?? LatLng(0, 0),
        _width = width,
        _height = height,
        _type = type;
  //*--- 公有变量 ---*
  String get key => _key;

  String get layerkey => _layerkey;

  LatLng get latLng => _latLng;

  double get width => _width;

  double get height => _height;

  MarkerType get type => _type;

  /// 是否需要更新，用于外部监听数据变化
  final ValueNotifier<int> changeNotifier = ValueNotifier(0);

  Marker get marker => _marker;

  //*--- 私有变量 ---*
  final String _key;

  final String _layerkey;

  late LatLng _latLng;

  late double _width;

  late double _height;

  late MarkerType _type;

  // ignore: prefer_final_fields
  late Marker _marker = Marker(
    point: _latLng,
    width: _width,
    height: _height,
    builder: (context) => AriMapMarkerWidget(type: type),
  );

  //*--- 公有方法 ---*
  /// 更新marker的坐标
  ///
  /// - `newLatLng`: 新的坐标
  ///
  /// 在操作完成后会对changeNotifier自增
  void updateLatLng(LatLng newLatLng) {
    _latLng = newLatLng;
    _marker = Marker(
      point: _latLng,
      width: _width,
      height: _height,
      builder: (context) => AriMapMarkerWidget(type: type),
    );
    changeNotifier.value++;
  }
}
