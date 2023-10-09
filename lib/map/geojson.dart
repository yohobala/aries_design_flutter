import 'package:latlong2/latlong.dart';

class Feature<T, G extends Geometry> {
  Feature({
    this.type = "Feature",
    required this.geometry,
    required this.properties,
  });

  final String type;
  final G geometry;
  final T properties;

  /// ```
  /// String jsonString = jsonEncode(feature.toJson());
  /// ```
  Map<String, dynamic> toJson() => {
        'type': type,
        'geometry': geometry.toJson(),
        'properties': (properties as dynamic).toJson(),
      };

  /// ```
  /// Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  /// Feature<MakerInfo> deserializedFeature = Feature.fromJson(jsonMap, (json) => MakerInfo.fromJson(json));
  /// ```
  factory Feature.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    Map<String, dynamic> geoJson = json['geometry'];
    Geometry geometry;
    switch (geoJson['type']) {
      case 'Point':
        geometry = Point.fromJson(geoJson);
        break;
      case 'LineString':
        geometry = LineString.fromJson(geoJson);
        break;
      default:
        throw Exception('Unsupported geometry type');
    }
    return Feature<T, G>(
      type: json['type'],
      geometry: geometry as G,
      properties: fromJsonT(json['properties']),
    );
  }
}

class FeatureCollection<T, G extends Geometry> {
  FeatureCollection({
    this.type = "FeatureCollection",
    required this.features,
  });

  final String type;
  final List<Feature<T, G>> features;

  Map<String, dynamic> toJson() => {
        'type': type,
        'features': features.map((e) => e.toJson()).toList(),
      };

  factory FeatureCollection.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return FeatureCollection<T, G>(
      type: json['type'],
      features: List<Feature<T, G>>.from(json['features'].map(
        (e) => Feature<T, G>.fromJson(e, fromJsonT),
      )),
    );
  }
}

abstract class Geometry<T> {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  final String type;
  final T coordinates;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  Geometry.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        coordinates = json['coordinates'] as T;
}

class Point extends Geometry<List<double>> {
  Point({
    required List<double> coordinates,
  }) : super(
          type: "Point",
          coordinates: coordinates,
        );

  Point.fromJson(Map<String, dynamic> json)
      : super(
          type: "Point",
          coordinates: (json['coordinates'] as List<dynamic>)
              .map((e) => e as double)
              .toList(),
        );

  Point.latlngToPoint(LatLng latLng)
      : super(
          type: "Point",
          coordinates: [latLng.longitude, latLng.latitude],
        );

  LatLng get latLng => LatLng(coordinates[1], coordinates[0]);
}

class LineString extends Geometry<List<List<double>>> {
  LineString({
    required List<List<double>> coordinates,
  }) : super(
          type: "LineString",
          coordinates: coordinates,
        );

  @override
  LineString.fromJson(Map<String, dynamic> json)
      : super(
          type: "LineString",
          coordinates: (json['coordinates'] as List<dynamic>)
              .map((e) => (e as List<dynamic>).map((e) => e as double).toList())
              .toList(),
        );

  LineString.latlngsToLineString(List<LatLng> latLngs)
      : super(
          type: "LineString",
          coordinates: latLngs.map((e) => [e.longitude, e.latitude]).toList(),
        );

  List<LatLng> get latLngs =>
      coordinates.map((e) => LatLng(e[1], e[0])).toList();
}
