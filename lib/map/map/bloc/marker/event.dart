import 'package:aries_design_flutter/map/map/index.dart';

abstract class AriMapMarkerEvent {}

/***************  初始化、权限有关事件 ***************/

/// 初始化事件
class InitAriMapMarkerEvent extends AriMapMarkerEvent {}

/***************  图层有关事件  ***************/

/// 更新图层
class UpdateMarkerLayerEvent extends AriMapMarkerEvent {
  UpdateMarkerLayerEvent({
    required this.layers,
  });
  final List<AriMapMarkerLayer> layers;
}

class CreateMarkerLayerEvent extends AriMapMarkerEvent {}

/***************  标记有关事件  ***************/

/// {@template UpdateMarkeEvent}
/// 更新标记
/// {@endtemplate}
class UpdateMarkeEvent extends AriMapMarkerEvent {
  /// {@macro UpdateMarkeEvent}
  UpdateMarkeEvent({
    required this.marker,
  });
  final AriMapMarkerModel marker;
}

class SelectedMarkerEvent extends AriMapMarkerEvent {
  SelectedMarkerEvent({
    required this.marker,
    required this.isSelected,
  });
  final AriMapMarkerModel marker;
  final bool isSelected;
}
