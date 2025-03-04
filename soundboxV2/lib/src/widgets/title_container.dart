import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';

class TitleContainer extends StatelessWidget {
  const TitleContainer({super.key, required this.title, this.titleSize = 35});

  final String title;
  final double? titleSize;

  @override
  Widget build(BuildContext context) {
    final appTextStyle = appTypography.themeTextStyle;

    double width = MediaQuery.of(context).size.width;
    double expandWidth = width + dip(140);

    return SizedBox(
      width: expandWidth,
      height: dip(230),
      child: Stack(
        children: [
          Positioned(
            top: dip(-90),
            left: dip(-70),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(dip(expandWidth / 2)),
                bottomRight: Radius.circular(dip(expandWidth / 2)),
              ),
              child: Container(
                color: appColors.primaryColor,
                width: expandWidth,
                height: dip(320),
              ),
            ),
          ),
          Positioned(
            top: dip(5),
            left: dip(5),
            child: Image(
              image: appImages.loginJanaLogo,
              height: dip(35),
            ),
          ),
          Positioned(
            top: dip(94),
            left: 0, // Adjust left position if needed
            right: 0, // Adjust right position if needed
            child: SizedBox(
              width: double.infinity, // Make the text span the entire width
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: appTextStyle.secondaryFontWeight800Style(
                    color: appColors.white,
                    fontSize: titleSize,
                  ), // Center align the text horizontally
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
