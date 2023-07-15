import 'package:flutter/material.dart';
import 'package:aries_design_flutter/aries_design_flutter.dart';

/// 地图标记控制器的实现
///
/// *功能*
/// 1. 更新标记[updateMaker]
///   - 调用
///     - 外部调用
///   - 作用
///     - `存在`: 更新
///     - `不存在`: 添加
class AriMapMarkerController extends ChangeNotifier {
  //*--- 构造函数 ---*
  /// 地图标记控制器
  ///
  /// - `initLayers`: 用于初始化的标记层
  AriMapMarkerController({
    Key? key,
    this.initLayers = const [],
  }) : super() {
    _initLayers(initLayers);
  }
  //*--- 公有变量 ---*
  /// 是否需要更新，用于外部监听数据变化
  ValueNotifier<int> get changeNotifier => ValueNotifier(0);

  /// 标记图层集合
  Map<String, AriMapMarkerLayer> get layers => _layers;

  /// 初始化标记图层
  final List<AriMapMarkerLayer> initLayers;

  //*--- 私有变量 ---*
  /// 图层列表
  late Map<String, AriMapMarkerLayer> _layers;

  //*--- 公有方法 ---*
  /// 更新标记
  ///
  /// - `marker`: 修改的标记
  ///
  /// 会判断标记是否存在，进行不同操作:
  /// - `存在`: 更新标记，会调用[_updateMarker]方法修改标记
  /// - `不存在`: 创建标记，先创建一个图层[_createLayer]，再调用[_updateMarker]方法修改标记
  void updateMaker(AriMapMarker marker) {
    final String layerKey = marker.layerkey;
    if (_layers.containsKey(layerKey)) {
      _updateMarker(marker);
    } else {
      _createLayer(layerKey);
      _updateMarker(marker);
    }
  }

  //*--- 私有方法 ---*

  //*---- 图层上的方法 ----*
  /// 初始化标记层
  ///
  /// - `initLayers`: 用于初始化的标记层
  ///
  /// 首先会添加传入的所有标记层，
  /// 如果传入的标记层中没有默认图层，则会创建一个默认图层
  void _initLayers(List<AriMapMarkerLayer> initLayers) {
    _layers = {};
    for (var layer in initLayers) {
      _addLayer(layer.key, layer);
    }

    // 添加默认图层
    if (!_layers.containsKey(defalutMakerLayerKey)) {
      _createLayer(defalutMakerLayerKey, defalutMakerLayerName);
    }
  }

  /// 添加标记图层到[_layers]
  ///
  /// - `key`: 图层的key
  /// - `layer`: 图层
  void _addLayer(String key, AriMapMarkerLayer layer) {
    _layers[key] = layer;
  }

  /// 创建标记图层图层
  ///
  /// - `key`: 图层的key
  /// - `name`: 图层的名称
  ///
  /// 如果没有传入图层名称，则默认使用图层的key作为图层名称
  AriMapMarkerLayer _createLayer(String key, [String? name]) {
    name ??= key;
    AriMapMarkerLayer layer = AriMapMarkerLayer(key: key, name: name);
    _addLayer(key, layer);
    changeNotifier.value++;
    return layer;
  }

  //*---- 标记的方法 ----*
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
  void _updateMarker(AriMapMarker marker) {
    final String key = marker.key;
    final String layerKey = marker.layerkey;
    AriMapMarkerLayer layer = _layers[layerKey]!;

    layer.markers[key] = marker;
    layer.changeNotifier.value++;
  }
}
