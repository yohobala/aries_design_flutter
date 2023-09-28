import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// 初始化AriMap的依赖
List<SingleChildWidget> ariMapPolylineProvider() {
  return [
    Provider<AriMapPolylineBloc>(create: (_) => AriMapPolylineBloc()),
  ];
}

class AriMapPolyline extends StatelessWidget {
  AriMapPolyline({Key? key}) : super(key: key);

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  late AriMapPolylineBloc polylineBloc;

  @override
  Widget build(BuildContext context) {
    polylineBloc = context.read<AriMapPolylineBloc>();

    return Stack(
      children: [
        BlocListener<AriMapPolylineBloc, AriMapPolylineState>(
          bloc: polylineBloc,
          listener: (context, state) {
            if (state is InitAriMapPolylineState) {
              rebuild.value += 1; // 修改 ValueNotifier 的值
            }
            if (state is CreatePolylineLayerState) {
              rebuild.value += 1;
            }
          },
          child: ValueListenableBuilder<int>(
            valueListenable: rebuild,
            builder: (context, rebuild, child) {
              return Stack(
                children: buildLayers(),
              );
            },
          ),
        )
      ],
    );
  }

  List<Widget> buildLayers() {
    Map<Key, AriMapPolylineLayerModel> layers = polylineBloc.layers;
    List<Widget> layerWidgets = [];
    layers.forEach((key, value) {
      AriMapPolylineLayerModel layer = value;
      layerWidgets.add(AriMapPolylineLayer(
        layerKey: key,
        layer: layer,
      ));
    });
    return layerWidgets;
  }
}

class AriMapPolylineLayer extends StatelessWidget {
  AriMapPolylineLayer({Key? key, required this.layerKey, required this.layer})
      : super(key: key);

  final Key layerKey;

  final AriMapPolylineLayerModel layer;

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final polylineBloc = context.read<AriMapPolylineBloc>();

    return BlocListener<AriMapPolylineBloc, AriMapPolylineState>(
      bloc: polylineBloc,
      listener: (context, state) {
        if (state is CreatePolylineState) {
          layer.updatePolyline(state.polyline);
          rebuild.value += 1;
        } else if (state is UpdatePolylineState) {
          layer.updatePolyline(state.polyline);
          rebuild.value += 1;
        }
      },
      child: ValueListenableBuilder<int>(
        valueListenable: rebuild,
        builder: (context, rebuild, child) {
          return PolylineLayer(
            key: layerKey,
            polylines: buildPolylines(),
          );
        },
      ),
    );
  }

  List<Polyline> buildPolylines() {
    Map<Key, AriMapPolylineModel> polylines = layer.polylines;
    List<Polyline> polylineWidgets = [];
    polylines.forEach((key, value) {
      AriMapPolylineModel polyline = value;
      polylineWidgets.add(Polyline(
        points: polyline.points,
        strokeWidth: polyline.strokeWidth,
        color: polyline.color,
        borderColor: polyline.borderColor,
        borderStrokeWidth: polyline.borderStrokeWidth,
      ));
    });
    return polylineWidgets;
  }
}
