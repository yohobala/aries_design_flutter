import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/widgets.dart';

abstract class AriMapMarkerState {}

/***************  初始化、权限有关状态  ***************/

class InitAriMapMarkerBlocState extends AriMapMarkerState {}

class InitAriMapMarkerState extends AriMapMarkerState {}

/***************  图层有关状态  ***************/

class UpdateMarkerLayerState extends AriMapMarkerState {}

class CreateMarkerLayerState extends AriMapMarkerState {}

/***************  标记有关状态  ***************/

class UpdateMarkerState extends AriMapMarkerState {
  UpdateMarkerState({
    required this.marker,
    required this.layerKey,
  });

  final Key layerKey;
  final AriMapMarkerModel marker;
}

class CreateMarkerState extends AriMapMarkerState {
  CreateMarkerState({
    required this.marker,
    required this.layerKey,
  });

  final AriMapMarkerModel marker;
  final Key layerKey;
}

class SelectdMarkerState extends AriMapMarkerState {
  SelectdMarkerState({
    required this.marker,
    required this.isSelected,
  });

  final AriMapMarkerModel marker;
  final bool isSelected;
}
