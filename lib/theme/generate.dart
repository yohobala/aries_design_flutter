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

/// 生成不同Brightness模式下的ThemeData
///
/// - `brightness`：系统亮度模式
/// - `ariColorTheme`：Ari的颜色主题
///
/// 通过传入的[brightness]得到相应模式的度量主题，
/// 然后再通过[ariColorTheme]修改主题的colorScheme，
/// 最后输出修改后的主题
///
/// 一般外部调是获得这个修改过颜色的主题，而不是获得度量主题
///
/// 需要传入`useMaterial3: true`,否则会使用Material2的主题
ThemeData generateThemeData(Brightness brightness,
    {required AriThemeColor colorTheme}) {
  var baseTheme = generateMetricsTheme(
      ThemeData(useMaterial3: true, brightness: brightness));

  return baseTheme.copyWith(
    colorScheme: colorTheme.colorScheme,
  );
}

AriThemeColor generateThemeColor({
  required ColorScheme colorScheme,
}) {
  AriThemeBoxShadow boxShadow = AriThemeBoxShadow(
    standard: BoxShadow(
      color: colorScheme.shadow.withOpacity(0.2), // 设置透明度
      spreadRadius: 0, // 不要扩散阴影
      blurRadius: 6, // 模仿 FloatingActionButton 的 elevation
      offset: Offset(0, 3), // 模仿 FloatingActionButton 的阴影偏移
    ),
    bottomSheet: BoxShadow(
      color: colorScheme.shadow.withOpacity(0.2), // 设置透明度
      spreadRadius: 0, // 不要扩散阴影
      blurRadius: 10, // 模仿 FloatingActionButton 的 elevation
      offset: Offset(0, 0), // 模仿 FloatingActionButton 的阴影偏移
    ),
  );

  AriThemeColorButton button = AriThemeColorButton(
    gradientButton: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        Colors.transparent,
      ),
      foregroundColor: MaterialStateProperty.all<Color>(
        colorScheme.onPrimary,
      ),
    ),
    segmentedIconButton: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(
        colorScheme.onSecondaryContainer,
      ),
    ),
    segmentedIconButtonContainer: BoxDecoration(
      color: colorScheme.secondaryContainer,
      borderRadius: AriTheme.button.segmentedIconButtonContainer.borderRadius,
      boxShadow: [
        boxShadow.standard,
      ],
    ),
  );

  AriThemeColorModal modal = AriThemeColorModal(
    bottomSheet: BoxDecoration(
      color: colorScheme.surface.withOpacity(0.8),
      borderRadius: AriTheme.modal.bottomSheet.borderRadius,
      boxShadow: [
        boxShadow.bottomSheet,
      ],
    ),
  );

  final AriThemeColor ariThemeColor = AriThemeColor(
      colorScheme: colorScheme,
      shadow: boxShadow,
      button: button,
      modal: modal);

  return ariThemeColor;
}
