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
  primary: Color(0xFF7A5900),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFDEA1),
  onPrimaryContainer: Color(0xFF261900),
  secondary: Color(0xFF6C5C3F),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFF5E0BB),
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
  blue: Color.fromARGB(255, 30, 136, 229),
  green: Color.fromARGB(255, 67, 160, 71),
  red: Color.fromARGB(255, 229, 57, 53),
  yellow: Color(0xFFFFDF93),
  orange: Color.fromARGB(255, 251, 140, 0),
  grey: Color.fromARGB(255, 240, 240, 240),
  onGrey: Color.fromARGB(255, 180, 180, 180),
  onGrey2: Color.fromARGB(255, 160, 160, 160),
  white: Color.fromARGB(255, 240, 240, 240),
);

// AriThemeColorPrime _prime = AriThemeColorPrime(
//   blue: Colors.blue[600]!,
//   green: Colors.green[600]!,
//   red: Colors.red[600]!,
//   yellow: _colorScheme.primaryContainer,
//   orange: Colors.orange[600]!,
//   white: Colors.white,
//   ,
// );
