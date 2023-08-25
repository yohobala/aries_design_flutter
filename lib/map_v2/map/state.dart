import 'package:latlong2/latlong.dart';

abstract class AriMapState {}

class InitialState extends AriMapState {}

/// 位置信息
class MapLocationState extends AriMapState {
  MapLocationState({
    required this.center,
    required this.zoom,
  });
  final LatLng center;
  final double zoom;
}

class IsCenterOnPostion extends AriMapState {}
