import 'dart:async';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class AriMapPolylineBloc
    extends Bloc<AriMapPolylineEvent, AriMapPolylineState> {
  AriMapPolylineBloc() : super(InitAriMapPolylineBlocEvent()) {
    /// 初始化事件
    on<InitAriMapPolylineEvent>(initAriMapPolylineEvent);

    on<UpdatePolylineLayerEvent>(updateLayerEvent);
    on<CreatePolylineLayerEvent>(createLayerEvent);

    on<UpdatePolylineEvent>(updatePolylineEvent);

    add(InitAriMapPolylineEvent());
  }

  /// 图层
  ///
  /// key: 图层的key
  /// value: 图层
  Map<Key, AriMapPolylineLayerModel> get layers => _layers;

  Map<Key, AriMapPolylineModel> get polylines => _polylines;

  /// 当前地图的全部图层
  final Map<Key, AriMapPolylineLayerModel> _layers = {};

  /// 线
  final Map<Key, AriMapPolylineModel> _polylines = {};

  /***************  初始化、权限有关事件 ***************/

  FutureOr<void> initAriMapPolylineEvent(
      InitAriMapPolylineEvent event, Emitter<AriMapPolylineState> emit) {
    // 添加默认图层
    if (!_layers.containsKey(defalutMakerLayerKey)) {
      _createLayer(defalutMakerLayerKey, defalutMakerLayerName);
    }

    emit(InitAriMapPolylineState());
  }

  /***************  图层有关事件  ***************/

  /// 更新图层
  FutureOr<void> updateLayerEvent(
      UpdatePolylineLayerEvent event, Emitter<AriMapPolylineState> emit) {}

  FutureOr<void> createLayerEvent(
      CreatePolylineLayerEvent event, Emitter<AriMapPolylineState> emit) {
    emit(CreatePolylineLayerState());
  }

  /***************  线有关事件  ***************/

  FutureOr<void> updatePolylineEvent(
      UpdatePolylineEvent event, Emitter<AriMapPolylineState> emit) {
    final AriMapPolylineModel polyline = event.polyline;
    if (!_polylines.containsKey(polyline.key)) {
      _polylines[polyline.key] = polyline;
      var layerKey = polyline.layerkey;
      if (!_layers.containsKey(layerKey)) {
        _createLayer(layerKey);
        add(CreatePolylineLayerEvent());
      }
      updatePolylineLayer(polyline, null);
      emit(
        CreatePolylineState(polyline: polyline, layerKey: polyline.layerkey),
      );
    } else {
      updatePolylineLayer(polyline, polyline.layerkey);
      _polylines[polyline.key] = polyline;
      emit(
          UpdatePolylineState(polyline: polyline, layerKey: polyline.layerkey));
    }
  }

  /***************  方法  ***************/

  /// 更新标记对应的图层
  void updatePolylineLayer(AriMapPolylineModel polyline, Key? oldLayerKey) {
    if (oldLayerKey == null) {
      var layerKey = polyline.layerkey;
      if (!_layers.containsKey(layerKey)) {
        _createLayer(layerKey);
      }
      var layer = _layers[layerKey]!;
      layer.polylines[polyline.key] = polyline;
    } else if (oldLayerKey == polyline.layerkey) {
      return;
    } else {
      var oldLayer = _layers[oldLayerKey]!;
      oldLayer.polylines.remove(polyline.key);
      var layerKey = polyline.layerkey;
      if (!_layers.containsKey(layerKey)) {
        _createLayer(layerKey);
      }
      var layer = _layers[layerKey]!;
      layer.polylines[polyline.key] = polyline;
    }
  }

  /// 创建标记图层图层
  ///
  /// - `key`: 图层的key
  /// - `name`: 图层的名称
  ///
  /// 如果没有传入图层名称，则默认使用图层的key作为图层名称
  AriMapPolylineLayerModel _createLayer(Key key, [String? name]) {
    name ??= key.toString();
    AriMapPolylineLayerModel layer =
        AriMapPolylineLayerModel(key: key, name: name);
    _addLayer(key, layer);
    return layer;
  }

  /// 添加标记图层到[_layers]
  ///
  /// - `key`: 图层的key
  /// - `layer`: 图层
  void _addLayer(Key key, AriMapPolylineLayerModel layer) {
    _layers[key] = layer;
  }
}
