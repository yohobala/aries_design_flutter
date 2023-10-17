import 'package:aries_design_flutter/map/map/model/gesture.dart';
import 'package:flutter/material.dart';

class AriMapRepo {
  AriMapRepo();

  /// 图层
  ///
  /// key: 图层的key
  /// value: 图层
  Map<ValueKey<String>, AriMapGesture> get gestureLayers => _gestureLayers;

  /// 手势图层
  final Map<ValueKey<String>, AriMapGesture> _gestureLayers = {};

  /// 获取手势图层
  ///
  /// 如果不存在会创建一个新的
  GetGestureResult getGesture(ValueKey<String> key) {
    if (_gestureLayers.containsKey(key)) {
      return GetGestureResult(
        gesture: _gestureLayers[key]!,
        isNew: false,
      );
    } else {
      AriMapGesture layer = createGesture(key);
      _gestureLayers[key] = layer;
      return GetGestureResult(
        gesture: layer,
        isNew: true,
      );
    }
  }

  /// 添加图层
  void updateGesture(ValueKey<String> key, AriMapGesture gesture) {
    _gestureLayers[key] = gesture;
  }

  /// 创建手势图层
  AriMapGesture createGesture(ValueKey<String> key) {
    AriMapGesture gesture = AriMapGesture(
      key: key,
      name: key.toString(),
      polylines: {},
      markers: {},
    );
    _gestureLayers[key] = gesture;
    return gesture;
  }
}
