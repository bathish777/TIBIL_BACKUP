import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'image_assets.dart';
import 'theme_appearance_type.dart';

import 'dip.dart';

part 'light_dark_theme_appearance.dart';

part 'theme_typography.dart';

part 'widget_extension.dart';

class ThemeManager {
  factory ThemeManager() {
    return _instance;
  }

  // Singleton Constructor
  ThemeManager._();

  static final ThemeManager _instance = ThemeManager._();

  static late Dip _dip;
  static late ThemeAppearanceType _currentThemeMode;
  static late ColorPalette _currentThemeColors;
  static late ThemeTypography _currentThemeTypography;
  static late ImageAssets _currentThemeImages;

  static late ThemeData _themeData;

  static Dip get dip => _dip;

  static ThemeAppearanceType get currentThemeMode => _currentThemeMode;

  static ColorPalette get currentThemeColors => _currentThemeColors;

  static ThemeTypography get currentThemeTypography => _currentThemeTypography;

  static ImageAssets get currentThemeImages => _currentThemeImages;

  static ThemeData get themeData => _themeData;

  static final DarkAppearance _darkAppearance = DarkAppearance();
  static final LightAppearance _lightAppearance = LightAppearance();

  static void setupTypography(Dip dip) {
    _dip = dip;
    _currentThemeTypography = ThemeTypography(dip);
  }

  static ThemeData buildThemeData(ThemeAppearanceType themeType) {
    switch (themeType) {
      case ThemeAppearanceType.dark:
        _currentThemeMode = ThemeAppearanceType.dark;
        _currentThemeColors = _darkAppearance.colors;
        _currentThemeImages = _darkAppearance.images;
        _themeData = _darkAppearance.themeData;
        break;
      default:
        _currentThemeMode = ThemeAppearanceType.light;
        _currentThemeColors = _lightAppearance.colors;
        _currentThemeImages = _lightAppearance.images;
        _themeData = _lightAppearance.themeData;
        break;
    }
    return _themeData;
  }
}
