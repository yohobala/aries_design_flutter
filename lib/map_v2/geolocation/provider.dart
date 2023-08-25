import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AriGeoLocationProvider {
  Future<LatLng> getCurrentLocation() async {
    // 直接与定位API通信以获取当前位置
    // 返回LatLng对象或null
    Position position = await Geolocator.getCurrentPosition();
    LatLng latLng = LatLng(position.latitude, position.longitude);

    return latLng;
  }
}
