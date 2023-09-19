import 'package:aries_design_flutter/aries_design_flutter.dart';

abstract class AriMarkerEvent {}

/***************  初始化、权限有关事件 ***************/

/// 初始化事件
class InitAriMarkerEvent extends AriMarkerEvent {}

/***************  图层有关事件  ***************/

/// 更新图层
class UpdateMarkerLayerEvent extends AriMarkerEvent {
  UpdateMarkerLayerEvent({
    required this.layers,
  });
  final List<AriMarkerLayer> layers;
}

class CreateMarkerLayerEvent extends AriMarkerEvent {}

/***************  标记有关事件  ***************/

/// {@template UpdateMarkeEvent}
/// 更新标记
/// {@endtemplate}
class UpdateMarkeEvent extends AriMarkerEvent {
  /// {@macro UpdateMarkeEvent}
  UpdateMarkeEvent({
    required this.marker,
  });
  final AriMarkerModel marker;
}

class SelectedMarkerEvent extends AriMarkerEvent {
  SelectedMarkerEvent({
    required this.marker,
    required this.isSelected,
  });
  final AriMarkerModel marker;
  final bool isSelected;
}
