import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

class AriMapPolylineLayer extends StatelessWidget {
  AriMapPolylineLayer({
    Key? key,
    required this.layerKey,
    required this.polylines,
  }) : super(key: key);

  final Key layerKey;

  final Map<ValueKey<String>, AriMapPolyline> polylines;

  final ValueNotifier<int> rebuild = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final mapState = FlutterMapState.maybeOf(context);
    if (mapState == null) {
      assert(false, 'No FlutterMapState found');
    }

    final polylineBloc = context.read<AriMapBloc>();

    Map<ValueKey<String>, AriMapPolyline> currentPolylines = polylines;

    return BlocListener<AriMapBloc, AriMapState>(
      bloc: polylineBloc,
      listener: (context, state) {
        if (state is CreatePolylineState) {
          currentPolylines[state.polyline.key] = state.polyline;
          rebuild.value += 1;
        } else if (state is UpdatePolylineState) {
          currentPolylines[state.polyline.key] = state.polyline;
          rebuild.value += 1;
        }
      },
      child: ValueListenableBuilder<int>(
        valueListenable: rebuild,
        builder: (context, rebuild, child) {
          return CustomPaint(
            painter:
                PolylinePainter(buildPolylines(currentPolylines), mapState!),
            size: Size(mapState.size.x, mapState.size.y),
          );
        },
      ),
    );
  }

  List<Polyline> buildPolylines(
      Map<ValueKey<String>, AriMapPolyline> polylines) {
    List<Polyline> polylineWidgets = [];
    polylines.forEach(
      (key, value) {
        AriMapPolyline polyline = value;
        polylineWidgets.add(
          Polyline(
            points: polyline.points,
            strokeWidth: polyline.strokeWidth,
            color: polyline.color,
            borderColor: polyline.borderColor,
            borderStrokeWidth: polyline.borderStrokeWidth,
            useStrokeWidthInMeter: polyline.useStrokeWidthInMeter,
          ),
        );
      },
    );

    return polylineWidgets;
  }
}
