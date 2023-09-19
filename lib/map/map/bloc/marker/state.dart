import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/widgets.dart';

abstract class AriMarkerState {}

/***************  初始化、权限有关状态  ***************/

class InitAriMarkerBlocState extends AriMarkerState {}

class InitAriMarkerState extends AriMarkerState {}

/***************  图层有关状态  ***************/

class UpdateMarkerLayerState extends AriMarkerState {}

class CreateMarkerLayerState extends AriMarkerState {}

/***************  标记有关状态  ***************/

class UpdateMarkerState extends AriMarkerState {
  UpdateMarkerState({
    required this.marker,
    required this.layerKey,
  });

  final Key layerKey;
  final AriMarkerModel marker;
}

class CreateMarkerState extends AriMarkerState {
  CreateMarkerState({
    required this.marker,
    required this.layerKey,
  });

  final AriMarkerModel marker;
  final Key layerKey;
}

class SelectdMarkerState extends AriMarkerState {
  SelectdMarkerState({
    required this.marker,
    required this.isSelected,
  });

  final AriMarkerModel marker;
  final bool isSelected;
}
