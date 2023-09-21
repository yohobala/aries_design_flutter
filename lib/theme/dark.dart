import 'package:flutter/material.dart';
import 'index.dart';
import 'generate.dart';

/// Ari的深色主题
final ariThemeDataDark = generateThemeData(
  Brightness.dark,
  colorTheme: ariThemeDark,
);

final AriThemeColor ariThemeDark = generateThemeColor(
  colorScheme: _colorScheme,
  prime: _prime,
);

/// 配色
/// primary: #765b00
/// Secondary: #9e8f6e
/// Tertiary: #7495ac
/// Neutral: #a7a29c
final ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFEDC148),
  onPrimary: Color(0xFF3E2E00),
  primaryContainer: Color(0xFF594400),
  onPrimaryContainer: Color(0xFFFFDF93),
  secondary: Color(0xFFD6C5A0),
  onSecondary: Color(0xFF392F15),
  secondaryContainer: Color(0xFF51462A),
  onSecondaryContainer: Color(0xFFF3E1BB),
  tertiary: Color(0xFF83CFFF),
  onTertiary: Color(0xFF00344B),
  tertiaryContainer: Color(0xFF004C6B),
  onTertiaryContainer: Color(0xFFC6E7FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1E1B16),
  onBackground: Color(0xFFE8E1D9),
  surface: Color(0xFF1E1B16),
  onSurface: Color(0xFFE8E1D9),
  surfaceVariant: Color(0xFF4C4639),
  onSurfaceVariant: Color(0xFFCFC5B4),
  outline: Color(0xFF989080),
  onInverseSurface: Color(0xFF1E1B16),
  inverseSurface: Color(0xFFE8E1D9),
  inversePrimary: Color(0xFF765B00),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFEDC148),
  outlineVariant: Color(0xFF4C4639),
  scrim: Color(0xFF000000),
);

AriThemeColorPrime _prime = AriThemeColorPrime(
  blue: Colors.blue[200]!,
  green: Colors.green[200]!,
  red: Colors.red[200]!,
  yellow: _colorScheme.primaryContainer,
  orange: Colors.orange[200]!,
  white: Colors.grey,
  grey: Colors.grey[800]!,
);
