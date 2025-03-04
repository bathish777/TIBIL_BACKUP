part of '../transaction_view.dart';

class _Avatar extends StatelessWidget {
  const _Avatar({super.key, required this.avatarChar});

  final String avatarChar;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dip(40),
      child: ClipOval(
        child: Material(
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          child: Center(
            child: Text(
              avatarChar,
              style: appTypography.themeTextStyle.secondaryFontWeight700Style(
                  color: appColors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}