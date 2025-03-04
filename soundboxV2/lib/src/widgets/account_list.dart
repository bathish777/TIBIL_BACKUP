import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';

import '../data/data.dart';

class AccountList extends StatefulWidget {
  const AccountList({
    required this.accounts,
    required this.onSelected,
    super.key,
  });

  final List<Account>? accounts;
  final void Function(Account account) onSelected;

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  late List<Account>? accounts;

  Account? _currentSelected;

  @override
  void initState() {
    super.initState();
    accounts = widget.accounts;
    if (accounts != null && accounts!.isNotEmpty) {
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       selectedAccount(accounts![0]);
     });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (accounts != null && accounts!.isNotEmpty) {
      return SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: widget.appColors.primaryColor),
            borderRadius: BorderRadius.all(
              Radius.circular(
                widget.dip(4),
              ),
            ),
          ),
          child: Column(children: [
            for (int i = 0; i < accounts!.length; i++)
              Column(
                children: [
                  AccountCard(
                    account: accounts![i],
                    value: _currentSelected,
                    onChange: (selected) {
                      selectedAccount(selected);
                      setState(() {});
                    },
                  ),
                  if (i != accounts!.length - 1)
                    Divider(
                      thickness: 1,
                      color: widget.appColors.primaryColor,
                    )
                ],
              )
          ]),
        ),
      );
    }
    return const Center(
      child: Text('No Accounts'),
    );
  }

  selectedAccount(Account account) {
    widget.onSelected(account);
    _currentSelected = account;
  }
}
