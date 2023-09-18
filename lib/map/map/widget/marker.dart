import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:aries_design_flutter/map/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// 初始化AriMap的依赖
List<SingleChildWidget> ariMarkerProvider() {
  return [
    Provider<AriMarkerRepo>(create: (_) => AriMarkerRepo()),
    ProxyProvider2<AriMarkerRepo, AriGeoLocationRepo, AriMarkerBloc>(
      update: (_, ariMarkerRepo, ariGeoLocationRepo, __) =>
          AriMarkerBloc(ariMarkerRepo, ariGeoLocationRepo),
    ),
  ];
}

typedef BuildMarker = Widget Function(AriMarkerModel marker, bool isSelected);

/// 地图标记组件
class AriMarker extends StatelessWidget {
  AriMarker({
    Key? key,
    this.buildMarker,
  }) : super(key: key);

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  final BuildMarker? buildMarker;

  @override
  Widget build(BuildContext context) {
    final mapBloc = context.read<AriMarkerBloc>();
    final markerBloc = context.read<AriMarkerBloc>();

    /// 构建标记图层
    List<Widget> buildLayers() {
      Map<Key, AriMarkerLayerModel> layers = mapBloc.layers;
      List<Widget> layerWidgets = [];
      layers.forEach((key, value) {
        AriMarkerLayerModel layer = value;
        layerWidgets.add(AriMarkerLayer(
          layerKey: key,
          layer: layer,
          buildMarker: buildMarker,
        ));
      });

      return layerWidgets;
    }

    return Stack(
      children: [
        BlocListener<AriMarkerBloc, AriMarkerState>(
          bloc: markerBloc,
          listener: (context, state) {
            if (state is InitAriMarkerState) {
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
}

/// 地图标记图层
class AriMarkerLayer extends StatelessWidget {
  AriMarkerLayer({
    Key? key,
    required this.layer,
    required this.layerKey,
    this.buildMarker,
  }) : super(key: key);

  /// 地图标记层
  final AriMarkerLayerModel layer;

  /// 当前地图标记层索引
  final Key layerKey;

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  final BuildMarker? buildMarker;

  @override
  Widget build(BuildContext context) {
    var markerBloc = context.read<AriMarkerBloc>();

    /// 构建该图层的所有marker
    List<Marker> buildMarkers() {
      List<Marker> markers = [];

      // 获得图层的所有marker
      Map<Key, AriMarkerModel> items = layer.markers;
      items.forEach((key, item) {
        markers.add(Marker(
          point: item.latLng,
          width: item.width,
          height: item.height,
          builder: (context) => AriMarkerBuider(
            key: item.key,
            marker: item,
            buildMarker: buildMarker,
          ),
        ));
      });

      return markers;
    }

    return BlocListener<AriMarkerBloc, AriMarkerState>(
      bloc: markerBloc,
      listener: (context, state) {
        if (state is CreateMarkerState && state.layerKey == layerKey) {
          layer.updateMarker(state.marker);
          rebuild.value += 1; // 修改 ValueNotifier 的值
        }
        if (state is UpdateMarkerState && state.layerKey == layerKey) {
          layer.updateMarker(state.marker);
          rebuild.value += 1; // 修改 ValueNotifier 的值
        }
      },
      child: ValueListenableBuilder<int>(
        valueListenable: rebuild,
        builder: (context, rebuild, child) {
          return MarkerLayer(
            markers: buildMarkers(),
          );
        },
      ),
    );
  }
}

/// 标记样式
///
/// 用在[Marker]的builder中构建自定义的标记
///
/// 在AriMapMarker生成实例的时候，会自动调用该widget
///
class AriMarkerBuider extends StatelessWidget {
  AriMarkerBuider({
    required Key key,
    required this.marker,
    this.buildMarker,
  }) : super(key: key);

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  final AriMarkerModel marker;

  final BuildMarker? buildMarker;

  @override
  Widget build(BuildContext context) {
    final markerBloc = context.read<AriMarkerBloc>();

    AriMarkerModel marker = markerBloc.getMarker(key!);

    bool isSelected = false;

    return GestureDetector(
        onTap: () {
          if (marker.onTap != null) {
            marker.onTap!(marker);
          }
        },
        child: BlocListener<AriMarkerBloc, AriMarkerState>(
          bloc: markerBloc,
          listener: (context, state) {},
          child: ValueListenableBuilder<int>(
            valueListenable: rebuild,
            builder: (context, rebuild, child) {
              return _buildMarker(marker, isSelected);
            },
          ),
        ));
  }

  Widget _buildMarker(AriMarkerModel marker, bool isSelected) {
    Widget widget;
    if (buildMarker != null) {
      widget = buildMarker!(marker, isSelected);
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
