import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';

import '../data/data.dart';
import '../localization/l10n.dart';

class AccountCard extends StatefulWidget {
  const AccountCard({
    super.key,
    required this.account,
    required this.value,
    required this.onChange,
  });

  final Account account;
  final Account? value;
  final void Function(Account account) onChange;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final textThemeStyle = widget.appTypography.themeTextStyle;
    final appColors = widget.appColors;

    final l10n = L10n.of(context);

    return Padding(
      padding: EdgeInsets.all(widget.dip(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: widget.dip(10),
              top: widget.dip(10),
            ),
            child: PrimaryRadio<Account>(
              value: widget.account,
              groupValue: widget.value,
              onChanged: (Account? value) {
                widget.onChange(value!);
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.account.customerId ?? '',
                  style: textThemeStyle.primaryFontWeight400Style(
                    color: appColors.primaryTextColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  widget.account.customerFullName ?? '',
                  style: textThemeStyle.primaryFontWeight700Style(
                    color: appColors.primaryTextColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.account.accountId ?? '',
                  style: textThemeStyle.primaryFontWeight400Style(
                    color: appColors.primaryTextColor,
                    fontSize: 14,
                  ),
                ),
                if (_expanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        textAlign: TextAlign.start,
                        TextSpan(
                          text: '${l10n.app.account_type} ',
                          style: textThemeStyle.primaryFontWeight400Style(
                            color: appColors.starDust,
                            fontSize: 10,
                          ),
                          children: [
                            TextSpan(
                              text: widget.account.accountType ?? '',
                              style: textThemeStyle.primaryFontWeight400Style(
                                color: appColors.primaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        textAlign: TextAlign.start,
                        TextSpan(
                          text: '${l10n.app.ifsc_code} ',
                          style: textThemeStyle.primaryFontWeight400Style(
                            color: appColors.starDust,
                            fontSize: 10,
                          ),
                          children: [
                            TextSpan(
                              text: widget.account.IFSCCode ?? '',
                              style: textThemeStyle.primaryFontWeight400Style(
                                color: appColors.primaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: widget.dip(10),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: Icon(
                _expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                color: appColors.primaryColor,
                size: widget.dip(20),
              ),
            ),
          )
        ],
      ),
    );
  }
}