import 'package:flutter/material.dart';
import 'index.dart';
import 'generate.dart';

/// Aries的浅色主题
final ariThemeDataLight = generateColorTheme(
  Brightness.light,
  colorTheme: ariThemeLight,
);

final AriThemeColor ariThemeLight = AriThemeColor(
  colorScheme: _colorScheme,
  shadow: _boxShadow,
  button: _button,
  modal: _modal,
);

/// 配色
/// primary: #765b00
/// Secondary: #9e8f6e
/// Tertiary: #7495ac
/// Neutral: #a7a29c
const ColorScheme _colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF765B00),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFDF93),
  onPrimaryContainer: Color(0xFF241A00),
  secondary: Color(0xFF6A5D3F),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFF3E1BB),
  onSecondaryContainer: Color(0xFF231A04),
  tertiary: Color(0xFF00658D),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFC6E7FF),
  onTertiaryContainer: Color(0xFF001E2D),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFFFBFF),
  onBackground: Color(0xFF1E1B16),
  surface: Color(0xFFFFFBFF),
  onSurface: Color(0xFF1E1B16),
  surfaceVariant: Color(0xFFECE1CF),
  onSurfaceVariant: Color(0xFF4C4639),
  outline: Color(0xFF7E7667),
  onInverseSurface: Color(0xFFF7F0E7),
  inverseSurface: Color(0xFF33302A),
  inversePrimary: Color(0xFFEDC148),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF765B00),
  outlineVariant: Color(0xFFCFC5B4),
  scrim: Color(0xFF000000),
);

AriThemeBoxShadow _boxShadow = AriThemeBoxShadow(
  standard: BoxShadow(
    color: _colorScheme.shadow.withOpacity(0.2), // 设置透明度
    spreadRadius: 0, // 不要扩散阴影
    blurRadius: 6, // 模仿 FloatingActionButton 的 elevation
    offset: Offset(0, 3), // 模仿 FloatingActionButton 的阴影偏移
  ),
  bottomSheet: BoxShadow(
    color: _colorScheme.shadow.withOpacity(0.2), // 设置透明度
    spreadRadius: 0, // 不要扩散阴影
    blurRadius: 10, // 模仿 FloatingActionButton 的 elevation
    offset: Offset(0, 0), // 模仿 FloatingActionButton 的阴影偏移
  ),
);

AriThemeColorButton _button = AriThemeColorButton(
  gradientButton: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      Colors.transparent,
    ),
    foregroundColor: MaterialStateProperty.all<Color>(
      _colorScheme.onPrimary,
    ),
  ),
  segmentedIconButton: ButtonStyle(
    foregroundColor:
        MaterialStateProperty.all<Color>(_colorScheme.onSecondaryContainer),
  ),
  segmentedIconButtonContainer: BoxDecoration(
    color: _colorScheme.secondaryContainer,
    borderRadius: AriTheme.button.segmentedIconButtonContainer.borderRadius,
    boxShadow: [
      _boxShadow.standard,
      BoxShadow(
        color: _colorScheme.outlineVariant,
        spreadRadius: 0,
        blurRadius: 7,
        offset: Offset(0, 5), // 阴影的偏移，向下偏移3
      )
    ],
  ),
);

AriThemeColorModal _modal = AriThemeColorModal(
  bottomSheet: BoxDecoration(
    color: _colorScheme.surface.withOpacity(0.8),
    borderRadius: AriTheme.modal.bottomSheet.borderRadius,
    boxShadow: [
      _boxShadow.bottomSheet,
    ],
  ),
);
