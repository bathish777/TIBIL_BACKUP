import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';

import '../data/data.dart';
import '../localization/l10n.dart';

class SimCardData extends StatefulWidget {
  const SimCardData({
    super.key,
    required this.simData,
    required this.value,
    required this.onChange,
    this.displayNumber,
  });

  final SimLocalData simData;
  final SimLocalData? value;
  final String? displayNumber;
  final void Function(SimLocalData simData) onChange;

  @override
  State<SimCardData> createState() => _SimCardDataState();
}

class _SimCardDataState extends State<SimCardData> {
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
            child: PrimaryRadio<SimLocalData>(
              value: widget.simData,
              groupValue: widget.value,
              onChanged: (SimLocalData? value) {
                widget.onChange(value!);
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIM ${widget.displayNumber ?? widget.simData.number}',
                  style: textThemeStyle.primaryFontWeight400Style(
                    color: appColors.primaryTextColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  widget.simData.carrier ?? '',
                  style: textThemeStyle.primaryFontWeight700Style(
                    color: appColors.primaryTextColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
