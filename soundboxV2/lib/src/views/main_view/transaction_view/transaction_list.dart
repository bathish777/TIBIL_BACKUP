part of 'transaction_view.dart';

class _TransactionList extends StatefulWidget {
  const _TransactionList();

  @override
  State<_TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<_TransactionList> {
  final defaultLimit = Config.transactionLimitation;

  final PagingController<int, Payment> _pagingController = PagingController(
    firstPageKey: Config.transactionOffset,
  );

  @override
  void initState() {
    _pagingController.refresh();

    _pagingController.addPageRequestListener((offset) {
      context
          .read<PaymentBloc>()
          .add(PaymentLoaded(offset: offset, limit: defaultLimit));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentLoadedSuccess) {
          if(state.resetOffset == true) {
            _pagingController.refresh();
          } else {
            if (state.isLastPage == true) {
              _pagingController.appendLastPage(state.payments);
            } else {
              final nextOffset =
                  _pagingController.nextPageKey! + state.payments.length;
              _pagingController.appendPage(
                state.payments,
                nextOffset,
              );
            }
          }
        } else if (state is PaymentLoadedFailure) {
          _pagingController.error = state.exception.getErrorMessage(l10n);
        }
      },
      child: PagedListView<int, Payment>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Payment>(
          itemBuilder: (context, payment, index) {
            return Container(
              padding: EdgeInsets.symmetric(
                  vertical: widget.dip(12.5), horizontal: widget.dip(0)),
              child: Row(
                children: [
                  _Avatar(
                      avatarChar: payment.details.payerName!.characters.first),
                  Expanded(
                    child: _Content(
                      name: payment.details.payerName!,
                      dateText: payment.details.datetime.toString(),
                    ),
                  ),
                  _Amount(amount: payment.details.amount ?? '0'),
                ],
              ),
            );
          },
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Text(
              l10n.app.no_records_found,
            ),
          ),
          newPageErrorIndicatorBuilder: (context) => _errorText,
          firstPageErrorIndicatorBuilder: (context) => _errorText,
        ),
      ),
    );
  }

  get _errorText => Center(
        child: Text(_pagingController.error),
      );
}
