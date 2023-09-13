class Feature<T> {
  Feature({
    this.type = "Feature",
    required this.geometry,
    required this.properties,
  });

  final String type;
  final Geometry geometry;
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
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return Feature<T>(
      type: json['type'],
      geometry: Geometry.fromJson(json['geometry']),
      properties: fromJsonT(json['properties']),
    );
  }
}

class FeatureCollection<T> {
  FeatureCollection({
    this.type = "FeatureCollection",
    required this.features,
  });

  final String type;
  final List<Feature<T>> features;

  Map<String, dynamic> toJson() => {
        'type': type,
        'features': features.map((e) => e.toJson()).toList(),
      };

  factory FeatureCollection.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return FeatureCollection<T>(
      type: json['type'],
      features: List<Feature<T>>.from(
          json['features'].map((e) => Feature.fromJson(e, fromJsonT))),
    );
  }
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  final String type;
  final List<double> coordinates;

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }
}
