import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/config/config.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/views/main_view/tab_view_config.dart';
import 'package:sound_box/src/widgets/widgets.dart';

import '../../../config/utils.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/domain/bloc/blocs.dart';
import '../../../localization/l10n.dart';
import '../../../notification_service/notification_handler.dart';

part 'widgets/total_transaction_amount_card.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({super.key});

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  @override
  void initState() {
    context.read<PaymentBloc>().add(const PaymentLoaded(resetOffset: true));
    super.initState();
    getIt<NotificationHandler>().startNotificationHandler();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Container(
      color: widget.appColors.tutu,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(
            title: l10n.app.dashboard,
            rootTabIndex: TabViewConfig.dashboardViewIndex,
          ),
          const HeaderText(),
          const DateHeader(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: widget.dip(10),
                  right: widget.dip(10),
                  bottom: widget.dip(24)),
              child: BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, paymentState) {
                  if (paymentState is PaymentLoadedSuccess) {
                    return Column(
                      children: [
                        Flexible(
                          child: _TotalTransactionAmountCard(
                            paymentSummary: paymentState.paymentSummary,
                          ),
                        ),
                        SizedBox(
                          height: widget.dip(15),
                        ),
                        Flexible(
                          child: _TotalTransactionAmountCard(
                            paymentSummary: paymentState.paymentSummary,
                            isAmountCard: true,
                          ),
                        ),
                      ],
                    );
                  } else if (paymentState is PaymentLoadedFailure) {
                    return Center(
                      child: Text(paymentState.exception.getErrorMessage(l10n)),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: widget.appColors.primaryColor,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
