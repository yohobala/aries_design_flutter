import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:aries_design_flutter/map/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

typedef BuildMarker = Widget Function(AriMapMarkerModel marker);

/// 初始化AriMap的依赖
List<SingleChildWidget> ariMarkerProvider() {
  return [
    Provider<AriMapMarkerRepo>(create: (_) => AriMapMarkerRepo()),
    ProxyProvider2<AriMapMarkerRepo, AriGeoLocationRepo, AriMapMarkerBloc>(
      update: (_, ariMarkerRepo, ariGeoLocationRepo, __) =>
          AriMapMarkerBloc(ariMarkerRepo, ariGeoLocationRepo),
    ),
  ];
}

/// 地图标记组件
class AriMapMarker extends StatelessWidget {
  AriMapMarker({
    Key? key,
    this.buildMarker,
  }) : super(key: key);

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  final BuildMarker? buildMarker;

  late final AriMapMarkerBloc markerBloc;

  @override
  Widget build(BuildContext context) {
    markerBloc = context.read<AriMapMarkerBloc>();
    return Stack(
      children: [
        BlocListener<AriMapMarkerBloc, AriMapMarkerState>(
          bloc: markerBloc,
          listener: (context, state) {
            if (state is InitAriMapMarkerState) {
              rebuild.value += 1; // 修改 ValueNotifier 的值
            }
            if (state is CreateMarkerLayerState) {
              rebuild.value += 1;
            }
          },
          child: ValueListenableBuilder<int>(
            valueListenable: rebuild,
            builder: (context, rebuild, child) {
              return Stack(children: buildLayers());
            },
          ),
        )
      ],
    );
  }

  /// 构建标记图层
  List<Widget> buildLayers() {
    Map<Key, AriMapMarkerLayerModel> layers = markerBloc.layers;
    List<Widget> layerWidgets = [];
    layers.forEach((key, value) {
      AriMapMarkerLayerModel layer = value;
      layerWidgets.add(AriMapMarkerLayer(
        layerKey: key,
        layer: layer,
        buildMarker: buildMarker,
      ));
    });

    return layerWidgets;
  }
}

/// 地图标记图层
class AriMapMarkerLayer extends StatelessWidget {
  AriMapMarkerLayer({
    Key? key,
    required this.layerKey,
    required this.layer,
    this.buildMarker,
  }) : super(key: key);

  /// 当前地图标记层索引
  final Key layerKey;

  /// 地图标记层
  final AriMapMarkerLayerModel layer;

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  final BuildMarker? buildMarker;

  @override
  Widget build(BuildContext context) {
    var markerBloc = context.read<AriMapMarkerBloc>();

    return BlocListener<AriMapMarkerBloc, AriMapMarkerState>(
      bloc: markerBloc,
      listener: (context, state) {
        if (state is CreateMarkerState && state.layerKey == layerKey) {
          layer.updateMarker(state.marker);
          rebuild.value += 1; // 修改 ValueNotifier 的值
        } else if (state is UpdateMarkerState && state.layerKey == layerKey) {
          layer.updateMarker(state.marker);
          rebuild.value += 1; // 修改 ValueNotifier 的值
        }
      },
      child: ValueListenableBuilder<int>(
        valueListenable: rebuild,
        builder: (context, rebuild, child) {
          return MarkerLayer(
            key: layerKey,
            markers: buildMarkers(),
          );
        },
      ),
    );
  }

  /// 构建该图层的所有marker
  List<Marker> buildMarkers() {
    List<Marker> markers = [];

    // 获得图层的所有marker
    Map<Key, AriMapMarkerModel> items = layer.markers;
    items.forEach((key, item) {
      markers.add(Marker(
        point: item.latLng,
        width: item.width,
        height: item.height,
        builder: (context) => AriMapMarkerBuider(
          key: item.key,
          marker: item,
          buildMarker: buildMarker,
        ),
      ));
    });

    return markers;
  }
}

/// 标记样式
///
/// 用在[Marker]的builder中构建自定义的标记
///
/// 在AriMapMarker生成实例的时候，会自动调用该widget
///
class AriMapMarkerBuider extends StatelessWidget {
  AriMapMarkerBuider({
    required Key key,
    required this.marker,
    this.buildMarker,
  }) : super(key: key);

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  final AriMapMarkerModel marker;

  final BuildMarker? buildMarker;

  @override
  Widget build(BuildContext context) {
    final markerBloc = context.read<AriMapMarkerBloc>();

    AriMapMarkerModel marker = markerBloc.getMarker(key!);

    return GestureDetector(
        onTap: () {
          if (marker.onTap != null) {
            marker.onTap!(marker);
          }
        },
        child: BlocListener<AriMapMarkerBloc, AriMapMarkerState>(
          bloc: markerBloc,
          listener: (context, state) {},
          child: ValueListenableBuilder<int>(
            valueListenable: rebuild,
            builder: (context, rebuild, child) {
              return _buildMarker(marker);
            },
          ),
        ));
  }

  Widget _buildMarker(AriMapMarkerModel marker) {
    Widget widget;
    if (buildMarker != null) {
      widget = buildMarker!(marker);
      return widget;
    }
    switch (marker.type) {
      case MarkerType.normal:
        widget = _NormalWidget();
        break;
      case MarkerType.location:
        widget = _LocationWidget();
        break;
      default:
        widget = _NormalWidget();
    }

    return widget;
  }
}

/// 普通标记
class _NormalWidget extends StatelessWidget {
  const _NormalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.circle,
      size: 15,
    );
  }
}

/// 位置标记
class _LocationWidget extends StatelessWidget {
  const _LocationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.location_on_outlined,
      size: 24,
    );
  }
}
