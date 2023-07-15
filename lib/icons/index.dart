// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

/// 图标
class AriIcons {
  AriIcons._();

  /// 在 pubspec.yaml 中配置的family
  static const String iconFont = 'AriIcons';

  /// 包名,字体文件所在的包名
  static const String iconFontPackage = "aries_design_flutter";

  /// <i class='cupertino-icons md-36'>layers</i> &#x2014;
  /// 图层图标
  static const IconData layers =
      IconData(0xe70b, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>pencil</i> &#x2014;
  /// 铅笔图标
  static const IconData pencil =
      IconData(0xe61b, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>location_fill</i> &#x2014;
  /// 定位图标，填充
  static const IconData position_fill =
      IconData(0xe627, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>location</i> &#x2014;
  /// 定位图标，空心
  static const IconData location =
      IconData(0xe628, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_left</i> &#x2014;
  /// 左箭头
  static const IconData arrow_left =
      IconData(0xe659, fontFamily: iconFont, fontPackage: iconFontPackage);

  /// <i class='cupertino-icons md-36'>arrow_right</i> &#x2014;
  /// 右箭头
  static const IconData arrow_right =
      IconData(0xe65b, fontFamily: iconFont, fontPackage: iconFontPackage);
}
