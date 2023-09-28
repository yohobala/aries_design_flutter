import 'package:aries_design_flutter/aries_design_flutter.dart';
import 'package:flutter/material.dart';

abstract class AriMapPolylineState {}

/***************  初始化、权限有关状态  ***************/

class InitAriMapPolylineBlocEvent extends AriMapPolylineState {}

class InitAriMapPolylineState extends AriMapPolylineState {}

/***************  图层有关状态  ***************/

class UpdatePolylineLayerState extends AriMapPolylineState {}

class CreatePolylineLayerState extends AriMapPolylineState {}

/***************  线有关状态  ***************/

class UpdatePolylineState extends AriMapPolylineState {
  UpdatePolylineState({
    required this.polyline,
    required this.layerKey,
  });

  final Key layerKey;
  final AriMapPolylineModel polyline;
}

class CreatePolylineState extends AriMapPolylineState {
  CreatePolylineState({
    required this.polyline,
    required this.layerKey,
  });

  final AriMapPolylineModel polyline;
  final Key layerKey;
}
