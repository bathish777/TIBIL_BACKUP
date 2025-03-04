part of 'transaction_view.dart';

class _TransactionSummaryTopBar extends StatelessWidget {
  const _TransactionSummaryTopBar();

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return BlocBuilder<PaymentBloc, PaymentState>(builder: (context, state) {
      double count = 0;
      double amount = 0;

      if (state is PaymentLoadedSuccess) {
        count = state.paymentSummary.count;
        amount = state.paymentSummary.amount;
      }

      if(state is PaymentLoadInProgress && state.paymentSummary != null) {
        count = state.paymentSummary!.count;
        amount = state.paymentSummary!.amount;
      }

      return IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: appColors.white,
            borderRadius: BorderRadius.all(Radius.circular(dip(4))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: TransactionAmountCard(
                  symbol: Config.hashSymbol,
                  text: l10n.app.total_transaction,
                  value: (count.round()).toString(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: dip(5), bottom: dip(5)),
                child: VerticalDivider(
                  thickness: 2,
                  color: appColors.tutu,
                ),
              ),
              Flexible(
                child: TransactionAmountCard(
                  symbol: Config.currencySymbol,
                  text: l10n.app.total_amount,
                  value: Utils.getFormattedAmount(
                    amount: amount,
                    showCurrencySymbol: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
