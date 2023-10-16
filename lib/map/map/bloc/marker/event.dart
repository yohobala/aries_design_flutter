import '../../model/marker.dart';
import '../../widget/marker.dart';

abstract class AriMapMarkerEvent {}

/***************  初始化、权限有关事件 ***************/

/// 初始化事件
class InitAriMapMarkerEvent extends AriMapMarkerEvent {}

/***************  图层有关事件  ***************/

/// 更新图层
class UpdateAriMarkerLayerEvent extends AriMapMarkerEvent {
  UpdateAriMarkerLayerEvent({
    required this.layers,
  });
  final List<AriMapMarkerLayer> layers;
}

class CreateMarkerLayerEvent extends AriMapMarkerEvent {}

/***************  标记有关事件  ***************/

/// {@template UpdateAriMarkerEvent}
/// 更新标记
/// {@endtemplate}
class UpdateAriMarkerEvent extends AriMapMarkerEvent {
  /// {@macro UpdateMarkeEvent}
  UpdateAriMarkerEvent({
    required this.marker,
  });
  final AriMapMarkerModel marker;
}

class SelectedAriMarkerEvent extends AriMapMarkerEvent {
  SelectedAriMarkerEvent({
    required this.marker,
    required this.isSelected,
  });
  final AriMapMarkerModel marker;
  final bool isSelected;
}
