import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';
import '../data/data.dart';

class VpaList extends StatefulWidget {
  const VpaList({
    required this.upis,
    required this.onSelected,
    super.key,
  });

  final List<Upi> upis;
  final void Function(Upi upi) onSelected;

  @override
  State<VpaList> createState() => _VpaListState();
}

class _VpaListState extends State<VpaList> {
  late List<Upi> upis;

  Upi? _currentSelected;

  @override
  void initState() {
    super.initState();
    upis = widget.upis;
    if (upis.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        selectedUpi(upis[0]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (upis.isNotEmpty) {
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
            for (int i = 0; i < upis.length; i++)
              Column(
                children: [
                  VpaCard(
                    upi: upis[i],
                    value: _currentSelected,
                    onChange: (selected) {
                      selectedUpi(selected);
                      setState(() {});
                    },
                  ),
                  if (i != upis.length - 1)
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
      child: Text('No Vpas'),
    );
  }

  selectedUpi(Upi upi) {
    widget.onSelected(upi);
    _currentSelected = upi;
  }
}
