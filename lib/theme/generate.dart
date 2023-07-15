import 'package:flutter/material.dart';

import 'metrics.dart';
import 'index.dart';

/// 生成不同Brightness模式下的度量主题
ThemeData generateMetricsTheme(ThemeData baseTheme) {
  return baseTheme.copyWith(
    // 在这里修改你的共享样式
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
          shape: AriTheme.button.standardShape,
          tapTargetSize: AriTheme.button.tapTargetSize,
          minimumSize: AriTheme.button.iconButtonSize,
          maximumSize: AriTheme.button.iconButtonSize),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: AriTheme.button.standardShape,
        tapTargetSize: AriTheme.button.tapTargetSize,
        padding: AriTheme.button.padding,
        minimumSize: AriTheme.button.buttonSize,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: AriTheme.button.standardShape,
        tapTargetSize: AriTheme.button.tapTargetSize,
        padding: AriTheme.button.padding,
        minimumSize: AriTheme.button.buttonSize,
      ),
    ),
  );
}

/// 生成不同Brightness模式下的颜色主题
///
/// - `brightness`：系统亮度模式
/// - `ariColorTheme`：Ari的颜色主题
///
/// 通过传入的[brightness]得到相应模式的度量主题，
/// 然后再通过[ariColorTheme]修改主题的颜色，
/// 最后输出修改后的主题
///
/// 一般外部调是获得这个修改过颜色的主题，而不是获得度量主题
///
/// 需要传入`useMaterial3: true`,否则会使用Material2的主题
ThemeData generateColorTheme(Brightness brightness,
    {required AriThemeColor colorTheme}) {
  var baseTheme = generateMetricsTheme(
      ThemeData(useMaterial3: true, brightness: brightness));

  return baseTheme.copyWith(
    colorScheme: colorTheme.colorScheme,
  );
}
