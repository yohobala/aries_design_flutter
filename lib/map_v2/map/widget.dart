import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const String token = "fb525d814e62751e358854e8f95155a6";

String getTianDiTuLayer(String layerName, String layerType) {
  return "http://t0.tianditu.gov.cn/vec/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec_w&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=fb525d814e62751e358854e8f95155a6";
}

class AriMap extends StatelessWidget {
  AriMap({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    final mapBloc = context.read<AriMapBloc>();
    final MapController mapController = MapController();
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<AriMapState>(
            stream: mapBloc.stream,
            builder: (context, snapshot) {
              if (snapshot.data is MapLocationState) {
                final state = snapshot.data as MapLocationState;
                mapController!.move(state.center, state.zoom);
              }
              return FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 8.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "http://t0.tianditu.gov.cn/cva_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cva&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=fb525d814e62751e358854e8f95155a6",
                  ),
                ],
              );
            },
          ),
          Positioned(
            child: IconButton(
              onPressed: () {
                mapBloc.add(GoToPositionEvent());
              },
              icon: const Icon(Icons.add),
            ),
            bottom: 10,
            right: 10,
          ),
        ],
      ),
    );
  }
}
