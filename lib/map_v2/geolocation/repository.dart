import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AriGeoLocationRepository {
  AriGeoLocationRepository({required this.provider});

  final AriGeoLocationProvider provider;

  /// 权限是否开启
  final bool _isInit = false;

  Future<LatLng> getLocation() async {
    LatLng latLng = await provider.getCurrentLocation();

    return latLng;
  }
}
