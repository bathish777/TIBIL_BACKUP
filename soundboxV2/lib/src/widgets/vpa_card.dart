import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';

import '../data/data.dart';
import '../localization/l10n.dart';

class VpaCard extends StatefulWidget {
  const VpaCard({
    super.key,
    required this.upi,
    required this.value,
    required this.onChange,
  });

  final Upi upi;
  final Upi? value;
  final void Function(Upi upi) onChange;

  @override
  State<VpaCard> createState() => _VpaCardState();
}

class _VpaCardState extends State<VpaCard> {
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
            child: PrimaryRadio<Upi>(
              value: widget.upi,
              groupValue: widget.value,
              onChanged: (Upi? value) {
                widget.onChange(value!);
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.upi.customerVpa ?? '',
                  style: textThemeStyle.primaryFontWeight400Style(
                    color: appColors.primaryTextColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  widget.upi.customerName ?? '',
                  style: textThemeStyle.primaryFontWeight700Style(
                    color: appColors.primaryTextColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}