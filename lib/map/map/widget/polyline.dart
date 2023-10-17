import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/plugin_api.dart';

import 'package:aries_design_flutter/aries_design_flutter.dart';

// /// 初始化AriMap的依赖
// List<SingleChildWidget> ariMapPolylineProvider() {
//   return [
//     Provider<AriMapBloc>(create: (_) => AriMapBloc()),
//   ];
// }

// class AriMapPolyline extends StatelessWidget {
//   AriMapPolyline({Key? key}) : super(key: key);

//   final ValueNotifier<int> rebuild = ValueNotifier(0);

//   late final AriMapBloc polylineBloc;

//   @override
//   Widget build(BuildContext context) {
//     polylineBloc = context.read<AriMapBloc>();

//     return Stack(
//       children: [
//         BlocListener<AriMapBloc, AriMapState>(
//           bloc: polylineBloc,
//           listener: (context, state) {
//             if (state is InitAriMapPolylineState) {
//               rebuild.value += 1; // 修改 ValueNotifier 的值
//             }
//             if (state is CreatePolylineLayerState) {
//               rebuild.value += 1;
//             }
//           },
//           child: ValueListenableBuilder<int>(
//             valueListenable: rebuild,
//             builder: (context, rebuild, child) {
//               return Stack(
//                 children: buildLayers(),
//               );
//             },
//           ),
//         )
//       ],
//     );
//   }

//   List<Widget> buildLayers() {
//     Map<Key, AriMapPolylineLayerModel> layers = polylineBloc.layers;
//     List<Widget> layerWidgets = [];
//     layers.forEach((key, value) {
//       AriMapPolylineLayerModel layer = value;
//       layerWidgets.add(AriMapPolylineLayer(
//         layerKey: key,
//         layer: layer,
//       ));
//     });
//     return layerWidgets;
//   }
// }

// class AriMapPolylineLayer extends StatelessWidget {
//   AriMapPolylineLayer({Key? key, required this.layerKey, required this.layer})
//       : super(key: key);

//   final Key layerKey;

//   final AriMapPolylineLayerModel layer;

//   final ValueNotifier<int> rebuild = ValueNotifier(0);

//   @override
//   Widget build(BuildContext context) {
//     final polylineBloc = context.read<AriMapBloc>();

//     return BlocListener<AriMapBloc, AriMapState>(
//       bloc: polylineBloc,
//       listener: (context, state) {
//         if (state is CreatePolylineState) {
//           layer.updatePolyline(state.polyline);
//           rebuild.value += 1;
//         } else if (state is UpdatePolylineState) {
//           layer.updatePolyline(state.polyline);
//           rebuild.value += 1;
//         }
//       },
//       child: ValueListenableBuilder<int>(
//         valueListenable: rebuild,
//         builder: (context, rebuild, child) {
//           return TappablePolylineLayer(
//             key: layerKey,
//             polylines: buildPolylines(),
//             polylineCulling: true,
//             pointerDistanceTolerance: 20,
//             onTap: (polylines, tapPosition) => print(
//               'Tapped: ' +
//                   polylines.map((polyline) => polyline.tag).join(',') +
//                   ' at ' +
//                   tapPosition.globalPosition.toString(),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   List<TaggedPolyline> buildPolylines() {
//     Map<Key, AriMapPolylineModel> polylines = layer.polylines;
//     List<TaggedPolyline> polylineWidgets = [];
//     polylines.forEach((key, value) {
//       AriMapPolylineModel polyline = value;
//       polylineWidgets.add(TaggedPolyline(
//         points: polyline.points,
//         strokeWidth: polyline.strokeWidth,
//         color: polyline.color,
//         borderColor: polyline.borderColor,
//         borderStrokeWidth: polyline.borderStrokeWidth,
//         tag: polyline.key.toString(),
//       ));
//     });
//     return polylineWidgets;
//   }
// }

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
