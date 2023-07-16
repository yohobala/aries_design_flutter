export 'metrics.dart';
export 'light.dart';
export 'dark.dart';

import 'package:flutter/material.dart';
import 'light.dart';
import 'dark.dart';
import 'metrics.dart';

class AriThemeController {
  // 单例模式
  static final AriThemeController _instance = AriThemeController._internal();

  factory AriThemeController() {
    return _instance;
  }

  /// 获取对于Brightness模式下的themeData
  ///
  /// - `brightness` 亮度模式
  ///
  /// *return*
  /// - `ThemeData` 对应的themeData
  ///
  /// ThemeData是MaterialApp的theme属性，一般是用在MaterialApp的theme属性中,
  /// 代码中获得样式推荐使用LeapTheme
  ThemeData getThemeData(Brightness? brightness) {
    if (brightness == Brightness.light || brightness == null) {
      return ariThemeDataLight;
    } else {
      return ariThemeDataDark;
    }
  }

  /// 获取对于Brightness模式下的AriThemeColor
  ///
  /// - `brightness` 亮度模式
  ///
  /// *return*
  /// - `AriThemeColor` 对应的AriThemeColor
  AriThemeColor getTheme(Brightness? brightness) {
    if (brightness == Brightness.light || brightness == null) {
      return ariThemeLight;
    } else {
      return ariThemeDark;
    }
  }

  AriThemeController._internal();
}

/// Aries的度量或数值方面的主题设置
///
/// 不涉及到颜色的主题设置，都放在该类中
///
/// 使用的时候直接调用AriTheme即可，不用实例化
///
/// 例如：
/// ```dart
/// double insets = AriTheme.insets.standard
/// ````
///
/// 颜色主题是AriThemeColor类，通过AriThemeController().getTheme()来获取
///
/// 例如：
/// ```dart
/// Brightness brightness = MediaQuery.of(context).platformBrightness;
/// AriThemeColor themeColor = AriThemeController().getTheme(brightness);
/// ```
@immutable
class AriTheme {
  /// 间距
  ///
  /// 一般是用于widget之间的间距
  static final AriThemeInsets insets = AriThemeInsets();

  /// widget与屏幕的间距
  ///
  /// 一般用于设定与屏幕的间距
  static final AriThemeWindowsInsets windowsInsets = AriThemeWindowsInsets();

  /// 圆角
  static final AriThemeBorderRadius borderRadius = AriThemeBorderRadius();

  /// 动画时间
  static final AriThemeDuration duration = AriThemeDuration();

  /// 文本样式
  static final AriThemeTextStyle textStyle = AriThemeTextStyle();

  /// 模糊效果
  static final AriThemeFilter filter = AriThemeFilter();

  /// 按钮
  static final AriThemeButton button = AriThemeButton();

  /// 弹出框
  static final AriThemeModal modal = AriThemeModal();
}

/// Aries的颜色主题
///
/// 应该通过LeapThemeController().getTheme()来对应的主题。例如
/// ```dart
/// Brightness brightness = MediaQuery.of(context).platformBrightness;
/// AriThemeColor themeColor = AriThemeController().getTheme(brightness);
/// ```
@immutable
class AriThemeColor {
  /// 主色调
  final ColorScheme colorScheme;

  /// 阴影
  final AriThemeBoxShadow shadow;

  /// 按钮
  final AriThemeColorButton button;

  /// 弹出框
  final AriThemeColorModal modal;

  AriThemeColor({
    required this.colorScheme,
    required this.shadow,
    required this.button,
    required this.modal,
  });
}

/// Aries的阴影样式
@immutable
class AriThemeBoxShadow {
  /// 标准阴影
  final BoxShadow standard;

  /// 底部弹出框阴影
  final BoxShadow bottomSheet;
  const AriThemeBoxShadow({
    required this.standard,
    required this.bottomSheet,
  });
}

/// Aries的按钮样式
@immutable
class AriThemeColorButton {
  /// 渐变按钮
  final ButtonStyle gradientButton;

  ///  segmentedIconButton单个按钮的样式
  final ButtonStyle segmentedIconButton;

  /// segmentedIconButton容器的样式
  final BoxDecoration segmentedIconButtonContainer;

  const AriThemeColorButton({
    required this.gradientButton,
    required this.segmentedIconButton,
    required this.segmentedIconButtonContainer,
  });
}

/// Aries的弹出框样式
class AriThemeColorModal {
  /// 底部弹出框
  final BoxDecoration bottomSheet;

  const AriThemeColorModal({
    required this.bottomSheet,
  });
}
