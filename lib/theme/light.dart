import 'package:flutter/material.dart';
import 'index.dart';
import 'generator.dart';

final AriThemeColor ariThemeLight = generateThemeColor(
  colorScheme: _colorScheme,
  prime: _prime,
);

/// Aries的浅色主题
final ariThemeDataLight = generateThemeData(
  Brightness.light,
  colorTheme: ariThemeLight,
);

/// 配色
/// primary: #fbce71
/// Secondary: #a08e6e
/// Tertiary: #5e93d8
/// Neutral: #959088
final ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.light,
  // 用于图标，字体的颜色
  primary: _prime.yellow!, //Color(0xFF7A5900),
  onPrimary: Color(0xFFFFFFFF),
  // 用于容器的颜色
  primaryContainer: Color(0xFFFFDEA1),
  onPrimaryContainer: Color(0xFF261900),
  secondary: Color(0xFF6C5C3F),
  onSecondary: Color(0xFFFFFFFF),
  // 如果字体，图标使用了primary，可以使用这个颜色当背景色
  secondaryContainer: Color(0xFFFFEFD5), //Color(0xFFF5E0BB),
  onSecondaryContainer: Color(0xFF241A04),
  tertiary: Color(0xFF1B60A5),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFD4E3FF),
  onTertiaryContainer: Color(0xFF001C39),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFFFBFF),
  onBackground: Color(0xFF1E1B16),
  surface: Color(0xFFFFFBFF),
  onSurface: Color(0xFF1E1B16),
  // 高亮的背景色，用于与背景做区别，通常用于容器，输入框等
  surfaceVariant: _prime.grey, //Color(0xFFEDE1CF),
  onSurfaceVariant: Color(0xFF4D4639),
  outline: Color(0xFF7F7667),
  onInverseSurface: Color(0xFFF8EFE7),
  inverseSurface: Color(0xFF34302A),
  inversePrimary: Color(0xFFF4BF48),
  shadow: Color(0xFF000000),
  // 用于设置了elevation后的背景色
  surfaceTint: Color(0xFF7A5900),
  outlineVariant: Color(0xFFD1C5B4),
  scrim: Color(0xFF000000),
);

AriThemeColorPrime _prime = const AriThemeColorPrime(
  blue: Color.fromARGB(255, 55, 135, 245),
  green: Color.fromARGB(255, 70, 187, 74),
  red: Color.fromARGB(255, 239, 64, 64),
  yellow: Color.fromARGB(255, 248, 176, 12),
  orange: Color.fromARGB(255, 251, 140, 0),
  purple: Color.fromRGBO(152, 79, 255, 1),
  grey: Color.fromARGB(255, 241, 241, 241),
  onGrey: Color.fromARGB(255, 180, 180, 180),
  onGrey600: Color.fromARGB(255, 160, 160, 160),
  onGrey700: Color.fromARGB(255, 140, 140, 140),
  white: Color.fromARGB(255, 240, 240, 240),
);
