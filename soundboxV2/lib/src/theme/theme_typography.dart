part of 'theme_manager.dart';

class ThemeTypography {
  ThemeTypography(Dip dip) : _dip = dip;

  final Dip _dip;

  static String primaryFontFamily = 'Hind';
  static String secondaryFontFamily = 'Playfair Display';

  static TextTheme primaryTextTheme =
      GoogleFonts.getTextTheme(primaryFontFamily);
  static TextTheme secondaryTextTheme =
      GoogleFonts.getTextTheme(secondaryFontFamily);

  ThemeTextStyle get themeTextStyle => ThemeTextStyle(dip: _dip);
}

class ThemeTextStyle extends _CustomizableDipTextStyle {
  ThemeTextStyle({required Dip dip}) : _dip = dip;

  @override
  final Dip _dip;
}

abstract class _CustomizableDipTextStyle {
  Dip get _dip;

  TextStyle getCustomTextStyle({
    FontWeight fontWeight = FontWeight.w400,
    Color? color = const Color(0xFF3D3D3B), // Primary Text Color
    double? fontSize = 18,
    bool isPrimaryFontFamily = true,
  }) {
    TextStyle textStyle = TextStyle(
        fontWeight: fontWeight, color: color, fontSize: _dip(fontSize!));

    return isPrimaryFontFamily
        ? textStyle
        : GoogleFonts.getFont(ThemeTypography.secondaryFontFamily,
            textStyle: textStyle);
  }

  TextStyle primaryFontWeight400Style({Color? color, double? fontSize}) {
    return getCustomTextStyle(
        fontWeight: FontWeight.w400, color: color, fontSize: fontSize);
  }

  TextStyle secondaryFontWeight400Style({Color? color, double? fontSize}) {
    return getCustomTextStyle(
        fontWeight: FontWeight.w400,
        color: color,
        fontSize: fontSize,
        isPrimaryFontFamily: false);
  }

  TextStyle primaryFontWeight500Style({Color? color, double? fontSize}) {
    return getCustomTextStyle(
        fontWeight: FontWeight.w500, color: color, fontSize: fontSize);
  }

  TextStyle secondaryFontWeight500Style({Color? color, double? fontSize}) {
    return getCustomTextStyle(
        fontWeight: FontWeight.w500,
        color: color,
        fontSize: fontSize,
        isPrimaryFontFamily: false);
  }

  TextStyle primaryFontWeight600Style({Color? color, double? fontSize}) {
    return getCustomTextStyle(
        fontWeight: FontWeight.w600, color: color, fontSize: fontSize);
  }

  TextStyle secondaryFontWeight600Style({Color? color, double? fontSize}) {
    return getCustomTextStyle(
        fontWeight: FontWeight.w600,
        color: color,
        fontSize: fontSize,
        isPrimaryFontFamily: false);
  }

  TextStyle primaryFontWeight700Style({Color? color, double? fontSize}) {
    return getCustomTextStyle(
        fontWeight: FontWeight.w700, color: color, fontSize: fontSize);
  }

  TextStyle secondaryFontWeight700Style({Color? color, double? fontSize}) {
    return getCustomTextStyle(
        fontWeight: FontWeight.w700,
        color: color,
        fontSize: fontSize,
        isPrimaryFontFamily: false);
  }

  TextStyle primaryFontWeight800Style({Color? color, double? fontSize}) {
    return getCustomTextStyle(
        fontWeight: FontWeight.w800, color: color, fontSize: fontSize);
  }

  TextStyle secondaryFontWeight800Style({Color? color, double? fontSize}) {
    return getCustomTextStyle(
        fontWeight: FontWeight.w800,
        color: color,
        fontSize: fontSize,
        isPrimaryFontFamily: false);
  }
}
