import 'dart:async';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AriMarkerBloc extends Bloc<AriMarkerEvent, AriMarkerState> {
  AriMarkerBloc(this.markerRepo, this.geoLocationRepo)
      : super(InitAriMarkerBlocState()) {
    on<InitAriMarkerEvent>(initAriMarkerEvent);

    on<UpdateMarkerLayerEvent>(updateLayerEvent);
    on<CreateMarkerLayerEvent>(createLayerEvent);

    on<UpdateMarkeEvent>(updateMarkeEvent);

    add(InitAriMarkerEvent());
  }

  /// 标记仓库
  final AriMarkerRepo markerRepo;

  /// 定位仓库
  final AriGeoLocationRepo geoLocationRepo;

  /// 图层
  ///
  /// key: 图层的key
  /// value: 图层
  Map<Key, AriMarkerLayerModel> get layers => _layers;

  /// 标记
  ///
  /// key: 标记的key
  /// value: 标记
  Map<Key, AriMarkerModel> get markers => _markers;

  /// 当前地图的全部图层
  final Map<Key, AriMarkerLayerModel> _layers = {};

  /// 当前地图的全部标记
  final Map<Key, AriMarkerModel> _markers = {};

  /***************  初始化、权限有关事件 ***************/

  /// 初始化事件
  FutureOr<void> initAriMarkerEvent(
      InitAriMarkerEvent event, Emitter<AriMarkerState> emit) {
    // 添加默认图层
    if (!_layers.containsKey(defalutMakerLayerKey)) {
      _createLayer(defalutMakerLayerKey, defalutMakerLayerName);
    }

    emit(InitAriMarkerState());
  }

  /***************  图层有关事件  ***************/

  /// 更新图层
  FutureOr<void> updateLayerEvent(
      UpdateMarkerLayerEvent event, Emitter<AriMarkerState> emit) {}

  FutureOr<void> createLayerEvent(
      CreateMarkerLayerEvent event, Emitter<AriMarkerState> emit) {
    emit(CreateMarkerLayerState());
  }

  /***************  标记有关事件  ***************/

  /// 更新标记事件
  ///
  /// 会判断是否存在标记，进行不同操作：
  /// - `存在`: 更新标记，会发起[UpdateMarkerState]
  /// - `不存在`: 创建标记，先判断是否存在图层，如果不存在则创建图层，再发起[CreateMarkerState]
  void updateMarkeEvent(UpdateMarkeEvent event, Emitter<AriMarkerState> emit) {
    final AriMarkerModel marker = event.marker;
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

  /***************  方法  ***************/

  /// 获得标记
  AriMarkerModel getMarker(Key key) {
    return _markers[key]!;
  }

  /// 更新标记对应的图层
  void updateMarkerLayer(AriMarkerModel marker, Key? oldLayerKey) {
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
  AriMarkerLayerModel _createLayer(Key key, [String? name]) {
    name ??= key.toString();
    AriMarkerLayerModel layer = AriMarkerLayerModel(key: key, name: name);
    _addLayer(key, layer);
    return layer;
  }

  /// 添加标记图层到[_layers]
  ///
  /// - `key`: 图层的key
  /// - `layer`: 图层
  void _addLayer(Key key, AriMarkerLayerModel layer) {
    _layers[key] = layer;
  }

  /// 添加标记
  ///
  /// - `marker`: 标记
  ///
  /// layer.markers[key] = marker并没有创建新的AriMapMarker对象，只是将layer.markers[key]
  /// 的引用指向了marker的新引用，这个性能开销非常小
  ///
  /// layer.markers[key].height = 80 也只是修改了AriMapMarker对象属性值，性能开销也很小
  ///
  /// 所以如果只是更新AriMapMarker对象中的某些属性值，上面两种操作的性能开销相差无几，
  /// 在考虑到代码的可读性和可维护性上，选择layer.markers[key] = marker更好点
  // void _updateMarker(AriMarkerModel marker) {
  //   final String key = marker.key;
  //   final String layerKey = marker.layerkey;
  //   AriMarkerLayerModel layer = _layers[layerKey]!;

  //   layer.markers[key] = marker;
  //   layer.changeNotifier.value++;
  // }
}
