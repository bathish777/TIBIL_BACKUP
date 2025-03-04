import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sound_box/src/config/config.dart';
import 'package:sound_box/src/data/exceptions/unexpected_server_response_exception.dart';
import 'package:sound_box/src/domain/bloc/blocs.dart';
import 'package:sound_box/src/domain/bloc/payment_bloc/payment_bloc.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';
import 'package:sound_box/src/data/models/models.dart';

import 'package:sound_box/src/config/utils.dart';
import 'package:sound_box/src/localization/l10n.dart';
import 'package:sound_box/src/views/main_view/tab_view_config.dart';

part 'transaction_summary_top_bar.dart';

part 'transaction_list.dart';

part 'widgets/avatar.dart';

part 'widgets/content.dart';

part 'widgets/amount.dart';

part 'widgets/transaction_amount_card.dart';

class TransactionView extends StatefulWidget {
  static const routeName = '/transaction';

  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  @override
  void initState() {
    super.initState();
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
            title: l10n.app.transaction,
            rootTabIndex: TabViewConfig.transactionViewIndex,
          ),
          const HeaderText(),
          const DateHeader(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: widget.dip(10),
                  right: widget.dip(10),
                  bottom: widget.dip(24)),
              child: Column(
                children: [
                  const _TransactionSummaryTopBar(),
                  SizedBox(height: widget.dip(10)),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(widget.dip(10)),
                      decoration: BoxDecoration(
                        color: widget.appColors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(widget.dip(4)),
                        ),
                      ),
                      child: const _TransactionList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
