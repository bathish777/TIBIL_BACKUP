import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';

class SoundBoxSplash extends StatelessWidget {
  const SoundBoxSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: appColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: dip(135), bottom: dip(148)),
            child: Image(
              image: appImages.startupLogo,
              height: dip(150),
            ),
          ),
          Image(
            image:
                appImages.splashlogo, // Using the same image for demonstration
            height: dip(50), // Adjust height for second usage
          ),

        ],
      ),
    );
  }
}
