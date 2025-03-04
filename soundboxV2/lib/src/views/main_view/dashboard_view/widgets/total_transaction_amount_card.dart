part of '../dash_board_view.dart';

class _TotalTransactionAmountCard extends StatelessWidget {
  const _TotalTransactionAmountCard({
    required this.paymentSummary,
    this.isAmountCard = false,
  });

  final PaymentSummary paymentSummary;
  final bool isAmountCard;

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = appTypography.themeTextStyle;
    final l10n = L10n.of(context);

    return InkWell(
      onTap: () => BlocProvider.of<SettingTabCubit>(context)
          .setActiveTabIndex(TabViewConfig.transactionViewIndex),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.all(Radius.circular(dip(4))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: dip(isAmountCard ? 33 : 35)),
              child: Text(
                isAmountCard ? Config.currencySymbol : Config.hashSymbol,
                style: themeTextStyle
                    .primaryFontWeight500Style(
                      color: appColors.primaryColor,
                      fontSize: 75,
                    )
                    .copyWith(height: 1),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: dip(isAmountCard ? 13 : 15),
              ),
              child: Text(
                isAmountCard
                    ? l10n.app.total_amount
                    : l10n.app.total_transaction,
                style: themeTextStyle
                    .secondaryFontWeight700Style(
                      color: appColors.primaryTextColor,
                      fontSize: 18,
                    )
                    .copyWith(height: 1),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: dip(isAmountCard ? 47 : 50),
              ),
              child: Text(
                isAmountCard
                    ? Utils.getFormattedAmount(
                        amount: paymentSummary.amount,
                        showCurrencySymbol: false,
                      )
                    : (paymentSummary.count.round()).toString(),
                style: themeTextStyle
                    .primaryFontWeight500Style(
                      color: appColors.mulberryWood,
                      fontSize: isAmountCard ? 55 : 75,
                    )
                    .copyWith(height: 1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
