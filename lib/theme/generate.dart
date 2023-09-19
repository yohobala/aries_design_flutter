import 'package:flutter/material.dart';

import 'index.dart';

/// 生成不同Brightness模式下的AriThemeColor
AriThemeColor generateThemeColor({
  required ColorScheme colorScheme,
  required AriThemeColorPrime prime,
}) {
  // MODULE:
  // 阴影样式
  AriThemeColorBoxShadow boxShadow = AriThemeColorBoxShadow(
    standard: BoxShadow(
      color: colorScheme.shadow.withOpacity(0.2), // 设置透明度
      // 扩散阴影,当为0时不扩散
      spreadRadius: 0,
      // 模仿 FloatingActionButton 的 elevation
      // 但是在滑动的时候会造成阴影和背景分离
      blurRadius: 6,
      // 模仿 FloatingActionButton 的阴影偏移
      offset: Offset(0, 3),
    ),
    bottomSheet: BoxShadow(
      color: colorScheme.shadow.withOpacity(0.2),
      blurRadius: 5,
      offset: Offset(0, -3),
    ),
  );

  // MODULE:
  // 按钮样式
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
          colorScheme.primaryContainer,
        ),
      ),
      segmentedIconButtonContainer: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: AriTheme.button.segmentedIconButtonContainer.borderRadius,
        boxShadow: [
          boxShadow.standard,
        ],
      ),
      filledIconButton: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          colorScheme.primaryContainer,
        ),
      ),
      markerIcon: colorScheme.background);

  // MODULE:
  // 弹出框样式
  AriThemeColorModal modal = AriThemeColorModal(
    bottomSheet: BoxDecoration(
      color: colorScheme.background,
      borderRadius: AriTheme.modal.bottomSheet.borderRadius,
      boxShadow: [
        boxShadow.bottomSheet,
      ],
    ),
  );

  // MODULE:
  // 渐变样式
  AriThemeColorGradient gradient = AriThemeColorGradient(
    loginBackgroundGradient: LinearGradient(
      colors: <Color>[
        colorScheme.primaryContainer,
        Color.fromARGB(1, 251, 27, 109),
      ],

      /// 渐变的开始位置
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: <double>[0.2, 1.0],
      tileMode: TileMode.clamp,
    ),
  );

  final AriThemeColor ariThemeColor = AriThemeColor(
    colorScheme: colorScheme,
    prime: prime,
    shadow: boxShadow,
    button: button,
    modal: modal,
    gradient: gradient,
  );

  return ariThemeColor;
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

/// 生成不同Brightness模式下的ThemeData需要的度量样式
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
