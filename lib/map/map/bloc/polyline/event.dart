import 'package:aries_design_flutter/aries_design_flutter.dart';

abstract class AriMapPolylineEvent {}

/***************  初始化、权限有关事件 ***************/

/// 初始化事件
class InitAriMapPolylineEvent extends AriMapPolylineEvent {}

/***************  图层有关事件  ***************/

/// 更新图层
class UpdateAriPolylineLayerEvent extends AriMapPolylineEvent {
  UpdateAriPolylineLayerEvent();
}

class CreatePolylineLayerEvent extends AriMapPolylineEvent {}

/***************  标记有关事件  ***************/

/// {@template UpdateAriPolylineEvent}
/// 更新曲线
/// {@endtemplate}
class UpdateAriPolylineEvent extends AriMapPolylineEvent {
  /// {@macro UpdatePolylineEvent}
  UpdateAriPolylineEvent({
    required this.polyline,
  });
  final AriMapPolylineModel polyline;
}
