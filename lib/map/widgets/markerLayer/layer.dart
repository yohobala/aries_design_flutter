import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

/// 地图标记图层
class AriMapMarkerLayerWidget extends StatefulWidget {
  /// 单个地图标记层
  ///
  /// - `layer`: 标记层
  /// - `layerKey`: 标记层的key
  const AriMapMarkerLayerWidget({
    Key? key,
    required this.layer,
    required this.layerKey,
  }) : super(key: key);

  /// 地图标记层
  final AriMapMarkerLayer layer;

  /// 当前地图标记层索引
  final String layerKey;

  @override
  AriMapMarkerLayerState createState() => AriMapMarkerLayerState();
}

class AriMapMarkerLayerState extends State<AriMapMarkerLayerWidget> {
  @override
  void initState() {
    super.initState();
    widget.layer.changeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: _buildMarkers(),
    );
  }

  /// 构建该图层的所有marker
  List<Marker> _buildMarkers() {
    List<Marker> markers = [];

    // 获得图层的所有marker
    Map<String, AriMapMarker> ariMapmarkers = widget.layer.markers;
    ariMapmarkers.forEach((key, value) {
      AriMapMarker ariMapMarker = value;
      markers.add(ariMapMarker.marker);
    });

    return markers;
  }
}

/// 地图标记图层集合
///
/// 通过读取ariMapMarkerController.layers，
///
/// 对每个layer调用[AriMapMarkerLayerWidget]构建图层
///
/// 最后返回一个图层列表
///
/// 一般用在[AriMap]的build中
class AriMapMarkerLayersWidget extends StatefulWidget {
  /// 地图标记层集合
  const AriMapMarkerLayersWidget({
    Key? key,
    required this.ariMapMarkerController,
  }) : super(key: key);

  /// 地图标记控制器
  final AriMapMarkerController ariMapMarkerController;

  @override
  AriMapMarkerLayersState createState() => AriMapMarkerLayersState();
}

class AriMapMarkerLayersState extends State<AriMapMarkerLayersWidget> {
  @override
  void initState() {
    super.initState();

    // 监听地图标记控制器的变化
    widget.ariMapMarkerController.changeNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _buildMarkerLayers());
  }

  /// 构建标记图层
  List<Widget> _buildMarkerLayers() {
    Map<String, AriMapMarkerLayer> layers =
        widget.ariMapMarkerController.layers;
    List<Widget> layerWidgets = [];

    layers.forEach((key, value) {
      AriMapMarkerLayer layer = value;
      layerWidgets.add(AriMapMarkerLayerWidget(layerKey: key, layer: layer));
    });

    return layerWidgets;
  }
}
