import 'dart:async';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AriMapMarkerBloc extends Bloc<AriMapMarkerEvent, AriMapMarkerState> {
  AriMapMarkerBloc(this.markerRepo, this.geoLocationRepo)
      : super(InitAriMapMarkerBlocState()) {
    on<InitAriMapMarkerEvent>(initAriMapMarkerEvent);

    on<UpdateMarkerLayerEvent>(updateLayerEvent);
    on<CreateMarkerLayerEvent>(createLayerEvent);

    on<UpdateMarkeEvent>(updateMarkeEvent);
    on<SelectedMarkerEvent>(selectedMarkerEvent);

    add(InitAriMapMarkerEvent());
  }

  /// 标记仓库
  final AriMapMarkerRepo markerRepo;

  /// 定位仓库
  final AriGeoLocationRepo geoLocationRepo;

  /// 图层
  ///
  /// key: 图层的key
  /// value: 图层
  Map<Key, AriMapMarkerLayerModel> get layers => _layers;

  /// 标记
  ///
  /// key: 标记的key
  /// value: 标记
  Map<Key, AriMapMarkerModel> get markers => _markers;

  /// 当前地图的全部图层
  final Map<Key, AriMapMarkerLayerModel> _layers = {};

  /// 当前地图的全部标记
  final Map<Key, AriMapMarkerModel> _markers = {};

  /***************  初始化、权限有关事件 ***************/

  /// 初始化事件
  FutureOr<void> initAriMapMarkerEvent(
      InitAriMapMarkerEvent event, Emitter<AriMapMarkerState> emit) {
    // 添加默认图层
    if (!_layers.containsKey(defalutMakerLayerKey)) {
      _createLayer(defalutMakerLayerKey, defalutMakerLayerName);
    }

    emit(InitAriMapMarkerState());
  }

  /***************  图层有关事件  ***************/

  /// 更新图层
  FutureOr<void> updateLayerEvent(
      UpdateMarkerLayerEvent event, Emitter<AriMapMarkerState> emit) {}

  FutureOr<void> createLayerEvent(
      CreateMarkerLayerEvent event, Emitter<AriMapMarkerState> emit) {
    emit(CreateMarkerLayerState());
  }

  /***************  标记有关事件  ***************/

  /// 更新标记事件
  ///
  /// 会判断是否存在标记，进行不同操作：
  /// - `存在`: 更新标记，会发起[UpdateMarkerState]
  /// - `不存在`: 创建标记，先判断是否存在图层，如果不存在则创建图层，再发起[CreateMarkerState]
  void updateMarkeEvent(
      UpdateMarkeEvent event, Emitter<AriMapMarkerState> emit) {
    final AriMapMarkerModel marker = event.marker;
    if (!_markers.containsKey(marker.key)) {
      _markers[marker.key] = marker;
      var layerKey = marker.layerkey;
      if (!_layers.containsKey(layerKey)) {
        _createLayer(layerKey);
        add(CreateMarkerLayerEvent());
      }
      updateMarkerLayer(marker, null);
      emit(
        CreateMarkerState(marker: marker, layerKey: marker.layerkey),
      );
    } else {
      updateMarkerLayer(marker, marker.layerkey);
      _markers[marker.key] = marker;
      emit(UpdateMarkerState(marker: marker, layerKey: marker.layerkey));
    }
  }

  FutureOr<void> selectedMarkerEvent(
      SelectedMarkerEvent event, Emitter<AriMapMarkerState> emit) {
    event.marker.selected = event.isSelected;
    emit(
        SelectdMarkerState(marker: event.marker, isSelected: event.isSelected));
  }

  /***************  方法  ***************/

  /// 获得标记
  AriMapMarkerModel getMarker(Key key) {
    return _markers[key]!;
  }

  /// 更新标记对应的图层
  void updateMarkerLayer(AriMapMarkerModel marker, Key? oldLayerKey) {
    if (oldLayerKey == null) {
      var layerKey = marker.layerkey;
      if (!_layers.containsKey(layerKey)) {
        _createLayer(layerKey);
      }
      var layer = _layers[layerKey]!;
      layer.markers[marker.key] = marker;
    } else if (oldLayerKey == marker.layerkey) {
      return;
    } else {
      var oldLayer = _layers[oldLayerKey]!;
      oldLayer.markers.remove(marker.key);
      var layerKey = marker.layerkey;
      if (!_layers.containsKey(layerKey)) {
        _createLayer(layerKey);
      }
      var layer = _layers[layerKey]!;
      layer.markers[marker.key] = marker;
    }
  }

  /// 创建标记图层图层
  ///
  /// - `key`: 图层的key
  /// - `name`: 图层的名称
  ///
  /// 如果没有传入图层名称，则默认使用图层的key作为图层名称
  AriMapMarkerLayerModel _createLayer(Key key, [String? name]) {
    name ??= key.toString();
    AriMapMarkerLayerModel layer = AriMapMarkerLayerModel(key: key, name: name);
    _addLayer(key, layer);
    return layer;
  }

  /// 添加标记图层到[_layers]
  ///
  /// - `key`: 图层的key
  /// - `layer`: 图层
  void _addLayer(Key key, AriMapMarkerLayerModel layer) {
    _layers[key] = layer;
  }
}
