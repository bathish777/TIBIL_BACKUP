
part of '../transaction_view.dart';

class _Amount extends StatelessWidget {
  const _Amount({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Center(
        child: Text(
          Utils.getFormattedAmount(amount: double.parse(amount)),
          style: appTypography.themeTextStyle.primaryFontWeight600Style(
            color: appColors.primaryTextColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}