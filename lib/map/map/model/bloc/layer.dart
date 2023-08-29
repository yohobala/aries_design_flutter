import 'package:flutter/material.dart';

class AriLayerModel {
  AriLayerModel({
    required this.url,
    this.backgroundColor = Colors.transparent,
  });

  /// 图层的地址
  final String url;

  /// 图层的背景色, 默认透明
  late Color backgroundColor;
}
