import 'package:flutter/material.dart';
import 'index.dart';
import 'generator.dart';

final AriThemeColor ariThemeDark = generateThemeColor(
  colorScheme: _colorScheme,
  prime: _prime,
);

/// Ari的深色主题
final ariThemeDataDark = generateThemeData(
  Brightness.dark,
  colorTheme: ariThemeDark,
);

/// 配色
/// primary: #765b00
/// Secondary: #9e8f6e
/// Tertiary: #7495ac
/// Neutral: #a7a29c
final ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFF4BF48),
  onPrimary: Color(0xFF402D00),
  primaryContainer: Color(0xFF5C4300),
  onPrimaryContainer: Color(0xFFFFDEA1),
  secondary: Color(0xFFD8C4A0),
  onSecondary: Color(0xFF3B2F15),
  secondaryContainer: Color(0xFF53452A),
  onSecondaryContainer: Color(0xFFF5E0BB),
  tertiary: Color(0xFFA4C9FF),
  onTertiary: Color(0xFF00315D),
  tertiaryContainer: Color(0xFF004884),
  onTertiaryContainer: Color(0xFFD4E3FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1E1B16),
  onBackground: Color(0xFFE9E1D8),
  surface: Color(0xFF1E1B16),
  onSurface: Color(0xFFE9E1D8),
  surfaceVariant: _prime.grey,
  onSurfaceVariant: Color(0xFFD1C5B4),
  outline: Color(0xFF998F80),
  onInverseSurface: Color(0xFF1E1B16),
  inverseSurface: Color(0xFFE9E1D8),
  inversePrimary: Color(0xFF7A5900),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFF4BF48),
  outlineVariant: Color(0xFF4D4639),
  scrim: Color(0xFF000000),
);

AriThemeColorPrime _prime = const AriThemeColorPrime(
  blue: Color.fromARGB(255, 144, 202, 249),
  green: Color.fromARGB(255, 165, 214, 167),
  red: Color.fromARGB(255, 239, 154, 154),
  yellow: Color.fromARGB(255, 255, 245, 157),
  orange: Color.fromARGB(255, 255, 204, 128),
  grey: Color.fromARGB(255, 70, 70, 70),
  onGrey: Color.fromARGB(255, 130, 130, 130),
  onGrey2: Color.fromARGB(255, 150, 150, 150),
  white: Color.fromARGB(255, 240, 240, 240),
);
