part of '../transaction_view.dart';

class _Content extends StatelessWidget {
  const _Content({required this.name, required this.dateText});

  final String name;
  final String dateText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dip(0), horizontal: dip(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: appTypography.themeTextStyle.primaryFontWeight600Style(
                color: appColors.primaryTextColor, fontSize: 12),
          ),
          Padding(
            padding: EdgeInsets.only(top: dip(6)),
            child: Text(
              dateText,
              style: appTypography.themeTextStyle.primaryFontWeight400Style(
                color: appColors.primaryTextColor,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
