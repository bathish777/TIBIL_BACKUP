part of 'theme_manager.dart';


abstract class ColorPalette {
  Color get primaryColor;
  Color get white;
  Color get primaryTextColor;
  Color get friarGray;
  Color get mulberryWood;
  Color get silver;
  Color get tutu;
  Color get wildSand;
  Color get alto;
  Color get starDust;
  Color get doveGray;
  Color get doublePearlLusta;
  Color get errorTextColor;
  Color get sun;
  Color get invalidErrorTextColor;
  Color get celestialBlue;
}


class _DefaultColorPalette implements ColorPalette {

  @override
  Color get primaryColor =>  const Color(0xFFDA107E);

  @override
  Color get white => Colors.white;

  @override
  Color get primaryTextColor => const Color(0xFF3D3D3B);

  @override
  Color get friarGray => const Color(0xFF868683);

  @override
  Color get mulberryWood => const Color(0xFF610739);

  @override
  Color get silver => const Color(0xFFBBBBBB);

  @override
  Color get tutu => const Color(0xFFFFF7FB);

  @override
  Color get wildSand => const Color(0xFFF4F4F4);

  @override
  Color get alto => const Color(0xFFD8D8D8);

  @override
  Color get starDust =>const Color(0xFF989895);

  @override
  Color get doveGray => const Color(0xFF707070);

  @override
  Color get doublePearlLusta => const Color(0xFFFCEDD3);

  @override
  Color get errorTextColor => const Color(0xFFD50303);

  @override
  Color get sun => const Color(0xFFF9A61C);

  @override
  Color get invalidErrorTextColor => const Color(0xFFB10000);

  @override
  Color get celestialBlue => const Color(0xFF528BCD);
}

class DarkColorPalette extends _DefaultColorPalette {}

class LightColorPalette extends _DefaultColorPalette {}

abstract class ThemeAppearance {
  ColorPalette get colors;
  ImageAssets get images;
  ThemeData get themeData;
}

class DarkAppearance implements ThemeAppearance {
  @override
  ColorPalette get colors => DarkColorPalette();

  @override
  ImageAssets get images => DarkImageAssets();

  @override
  ThemeData get themeData => ThemeData(
    textTheme: ThemeTypography.primaryTextTheme,
    colorScheme: ColorScheme(
      primary: colors.primaryColor,
      primaryContainer: Colors.green,
      secondary: Colors.black,
      secondaryContainer: Colors.purple,
      surface: colors.primaryColor,
      background: Colors.black,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.grey,
      onSurface: colors.alto,
      onBackground: Colors.brown,
      onError: Colors.lightGreen,
      brightness: Brightness.dark,

    ),
  );

}

class LightAppearance implements ThemeAppearance {
  @override
  ColorPalette get colors => LightColorPalette();

  @override
  ImageAssets get images => LightImageAssets();

  @override
  ThemeData get themeData => ThemeData(
    textTheme: ThemeTypography.primaryTextTheme,
    colorScheme: ColorScheme(
      primary: colors.primaryColor,
      primaryContainer: Colors.green,
      secondary: Colors.black,
      secondaryContainer: Colors.purple,
      surface: colors.primaryColor,
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.grey,
      onSurface:  colors.alto,
      onBackground: Colors.brown,
      onError: Colors.lightGreen,
      brightness: Brightness.light,
    ),
  );
}