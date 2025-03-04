
part of 'theme_manager.dart';

extension WidgetExtension on Widget {
  /// Getter for Dip (Design Independent Pixels) to handle design metrics.
  Dip get dip => ThemeManager.dip;

  /// Getter for retrieving the application's text styles from the Theme.
  ThemeTypography get appTypography => ThemeManager.currentThemeTypography;

  /// Getter for accessing app images from the theme assets.
  ImageAssets get appImages => ThemeManager.currentThemeImages;

  /// Getter for retrieving the current theme mode.
  ThemeAppearanceType get themeMode => ThemeManager.currentThemeMode;

  /// Getter for retrieving the current color palette from the Theme.
  ColorPalette get appColors => ThemeManager.currentThemeColors;
}