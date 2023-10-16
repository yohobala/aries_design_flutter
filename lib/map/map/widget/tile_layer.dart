import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AriMapLayer extends StatelessWidget {
  AriMapLayer({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    final mapBloc = context.read<AriMapBloc>();
    return Scaffold(
      body: StreamBuilder<AriMapState>(
        stream: mapBloc.stream,
        builder: (context, state) {
          if (state.data is UpdateLayerState) {
            final s = state.data as UpdateLayerState;
            return Stack(
              children: buildLayers(s.layers),
            );
          } else {
            // NOTE:
            // 这里的layers是默认的图层
            // 需要用mapBloc.layers，不然当移动页面，会变成空白
            return Stack(
              children: buildLayers(mapBloc.layers),
            );
          }
        },
      ),
    );
  }
}

List<TileLayer> buildLayers(List<AriLayerModel> layers) {
  List<TileLayer> tileLayers = [];
  for (var layer in layers) {
    tileLayers.add(
      TileLayer(
        urlTemplate: layer.url,
        backgroundColor: layer.backgroundColor,
        tileProvider: CachedNetworkTileProvider(),
      ),
    );
  }
  return tileLayers;
}

/// 缓存网络图层
class CachedNetworkTileProvider extends TileProvider {
  CachedNetworkTileProvider();

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    final url = getTileUrl(coordinates, options);
    return CachedNetworkImageProvider(url, cacheManager: DefaultCacheManager());
  }
}
