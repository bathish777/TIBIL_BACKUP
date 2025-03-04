part of '../transaction_view.dart';

class TransactionAmountCard extends StatelessWidget {
  const TransactionAmountCard({
    required this.symbol,
    required this.text,
    required this.value,
    super.key,
  });

  final String symbol;
  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = appTypography.themeTextStyle;

    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: dip(5), bottom: dip(5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              symbol,
              style: themeTextStyle.primaryFontWeight500Style(
                color: appColors.primaryColor,
                fontSize: 25,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: dip(5), bottom: dip(10)),
              child: Text(
                text,
                style: themeTextStyle.secondaryFontWeight400Style(
                  color: appColors.primaryTextColor,
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              value,
              style: themeTextStyle.primaryFontWeight500Style(
                color: appColors.mulberryWood,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
