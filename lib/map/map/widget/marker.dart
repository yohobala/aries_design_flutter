import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:aries_design_flutter/map/index.dart';
import 'package:flutter_map/plugin_api.dart';

class AriMapMarkerLayer extends StatelessWidget {
  AriMapMarkerLayer({
    ValueKey<String>? key,
    required this.layerKey,
    required this.markers,
    this.buildMarker,
  }) : super(key: key);

  final ValueKey<String> layerKey;

  final Map<ValueKey<String>, AriMapMarker> markers;

  final BuildMarker? buildMarker;

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    AriMapBloc mapBloc = context.read<AriMapBloc>();
    return Stack(
      children: [
        BlocListener<AriMapBloc, AriMapState>(
          bloc: mapBloc,
          listener: (context, state) {
            if (state is CreateMarkerState && state.layerKey == layerKey) {
              markers[state.marker.key] = state.marker;
              rebuild.value += 1; // 修改 ValueNotifier 的值
            } else if (state is UpdateMarkerState &&
                state.layerKey == layerKey) {
              markers[state.marker.key] = state.marker;
              rebuild.value += 1; // 修改 ValueNotifier 的值
            } else if (state is SelectdMarkerState &&
                state.marker.layerkey == layerKey) {
              rebuild.value += 1; // 修改 ValueNotifier 的值
            }
          },
          child: ValueListenableBuilder<int>(
            valueListenable: rebuild,
            builder: (context, rebuild, child) {
              return MarkerLayer(
                key: layerKey,
                markers: buildMakrerList(),
              );
            },
          ),
        )
      ],
    );
  }

  /// 构建该图层的所有marker
  List<Marker> buildMakrerList() {
    List<AriMapMarker> markerList = [];
    markers.forEach((key, item) {
      markerList.add(item);
    });
    sortList(markerList);
    List<Marker> m = [];
    for (var item in markerList) {
      m.add(converToMarker(item));
    }
    return m;
  }

  Marker converToMarker(AriMapMarker marker) {
    return Marker(
      // 添加key保证了marker不会一直重绘
      key: marker.key,
      point: marker.latLng,
      width: marker.width,
      height: marker.height,
      builder: (context) => _MarkerBuilder(
        key: marker.key,
        marker: marker,
        buildMarker: buildMarker,
      ),
    );
  }
}

class _MarkerBuilder extends StatelessWidget {
  _MarkerBuilder({
    required Key key,
    required this.marker,
    this.buildMarker,
  }) : super(key: key);

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  final AriMapMarker marker;

  final BuildMarker? buildMarker;

  @override
  Widget build(BuildContext context) {
    final markerBloc = context.read<AriMapBloc>();

    return BlocListener<AriMapBloc, AriMapState>(
      bloc: markerBloc,
      listener: (context, state) {},
      child: ValueListenableBuilder<int>(
        valueListenable: rebuild,
        builder: (context, rebuild, child) {
          return _buildMarker(marker);
        },
      ),
    );
  }

  Widget _buildMarker(AriMapMarker marker) {
    Widget widget;
    if (buildMarker != null) {
      widget = buildMarker!(marker);
      return widget;
    }
    switch (marker.type) {
      case MarkerType.normal:
        widget = _NormalWidget(
          marker: marker,
        );
        break;
      case MarkerType.location:
        widget = _LocationWidget(
          marker: marker,
        );
        break;
      default:
        widget = _NormalWidget(
          marker: marker,
        );
    }

    return widget;
  }
}

/// 普通标记
class _NormalWidget extends StatelessWidget {
  const _NormalWidget({
    Key? key,
    required this.marker,
  }) : super(key: key);

  final AriMapMarker marker;
  @override
  Widget build(BuildContext context) {
    return Icon(
      key: marker.builderKey,
      Icons.circle,
      size: 15,
    );
  }
}

/// 位置标记
class _LocationWidget extends StatelessWidget {
  const _LocationWidget({
    Key? key,
    required this.marker,
  }) : super(key: key);

  final AriMapMarker marker;
  @override
  Widget build(BuildContext context) {
    return Icon(
      key: marker.builderKey,
      Icons.location_on_outlined,
      size: 24,
    );
  }
}
