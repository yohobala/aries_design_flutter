export 'metrics.dart';
export 'light.dart';
export 'dark.dart';

import 'package:flutter/material.dart';
import 'light.dart';
import 'dark.dart';
import 'metrics.dart';

class AriThemeController {
  AriThemeController._internal();
  // 单例模式
  static final AriThemeController _instance = AriThemeController._internal();

  factory AriThemeController() {
    return _instance;
  }

  /// 获取对于Brightness模式下的themeData
  ///
  ///  ThemeData是MaterialApp的theme属性，一般是用在MaterialApp的theme属性中,
  /// 代码中获得样式推荐使用AriTheme
  ///
  /// *参数*
  /// - `brightness`: 亮度模式
  ///
  /// *return*
  /// - `ThemeData`: 对应的ThemeData
  ThemeData getThemeData(Brightness? brightness) {
    if (brightness == Brightness.light || brightness == null) {
      return ariThemeDataLight;
    } else {
      return ariThemeDataDark;
    }
  }

  /// 获取对于Brightness模式下的AriThemeColor
  ///
  /// AriThemeColor是当前灯光模式下的颜色样式，如果是需要数值方面的样式，调用[AriTheme]即可
  ///
  /// AriThemeColor通过AriThemeController().getTheme()来获取，
  /// 例如：
  /// ```dart
  /// Brightness brightness = MediaQuery.of(context).platformBrightness;
  /// AriThemeColor themeColor = AriThemeController().getTheme(brightness);
  /// ```
  ///
  /// *参数*
  /// - `brightness`: 亮度模式
  ///
  /// *return*
  /// - `AriThemeColor`: 对应的AriThemeColor
  AriThemeColor getThemeColor(Brightness? brightness) {
    if (brightness == Brightness.light || brightness == null) {
      return ariThemeLight;
    } else {
      return ariThemeDark;
    }
  }
}

/// Aries的度量或数值方面的主题设置
///
/// 不涉及到颜色的主题设置，都放在该类中,
/// 使用的时候直接调用[AriTheme]即可，不用实例化
///
/// 例如：
/// ```dart
/// double insets = AriTheme.insets.standard
/// ````
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

  /// 输入框
  static final AriThemeTextField textField = AriThemeTextField();
}

/***************  以下是AriThemeColor颜色主题的类 ***************/

/// {@template ari_theme_color}
/// Aries的颜色主题
///
/// 应该通过LeapThemeController().getTheme()来对应的主题。例如
/// ```dart
/// Brightness brightness = MediaQuery.of(context).platformBrightness;
/// AriThemeColor themeColor = AriThemeController().getThemeColor(brightness);
/// ```
/// {@endtemplate}
@immutable
class AriThemeColor {
  /// {@macro ari_theme_color}
  AriThemeColor(
      {required this.colorScheme,
      required this.prime,
      required this.shadow,
      required this.button,
      required this.modal,
      required this.gradient});

  /// 主色调
  final ColorScheme colorScheme;

  final AriThemeColorPrime prime;

  /// 阴影
  final AriThemeColorBoxShadow shadow;

  /// 按钮
  final AriThemeColorButton button;

  /// 弹出框
  final AriThemeColorModal modal;

  /// 渐变
  final AriThemeColorGradient gradient;
}

/// {@template ari_theme_color_scheme}
/// Aries的不同颜色的主要颜色
/// {@endtemplate}
@immutable
class AriThemeColorPrime {
  AriThemeColorPrime({
    required this.red,
    required this.green,
    required this.blue,
    required this.yellow,
    required this.orange,
  });

  final Color red;
  final Color green;
  final Color blue;
  final Color yellow;
  final Color orange;
}

/// Aries的阴影样式
@immutable
class AriThemeColorBoxShadow {
  const AriThemeColorBoxShadow({
    required this.standard,
    required this.bottomSheet,
  });

  /// 标准阴影
  final BoxShadow standard;

  /// 底部弹出框阴影
  final BoxShadow bottomSheet;
}

/// Aries的按钮样式
@immutable
class AriThemeColorButton {
  const AriThemeColorButton({
    required this.gradientButton,
    required this.segmentedIconButton,
    required this.segmentedIconButtonContainer,
    required this.filledIconButton,
  });

  /// 渐变按钮
  final ButtonStyle gradientButton;

  ///  segmentedIconButton单个按钮的样式
  final ButtonStyle segmentedIconButton;

  /// segmentedIconButton容器的样式
  final BoxDecoration segmentedIconButtonContainer;

  final ButtonStyle filledIconButton;
}

/// Aries的弹出框样式
@immutable
class AriThemeColorModal {
  const AriThemeColorModal({
    required this.bottomSheet,
  });

  /// 底部弹出框
  final BoxDecoration bottomSheet;
}

/// Aries的渐变样式
@immutable
class AriThemeColorGradient {
  const AriThemeColorGradient({
    required this.loginBackgroundGradient,
  });

  final Gradient loginBackgroundGradient;
}
