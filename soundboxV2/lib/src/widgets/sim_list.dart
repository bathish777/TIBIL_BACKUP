import 'package:flutter/material.dart';
import 'package:sound_box/src/config/device_config.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';

import '../data/data.dart';

class SimList extends StatefulWidget {
  const SimList({
    required this.onSelected,
    super.key,
  });

  final void Function(SimLocalData simData) onSelected;

  @override
  State<SimList> createState() => _SimListState();
}

class _SimListState extends State<SimList> {

  SimLocalData? _currentSelected;

  @override
  void initState() {
    super.initState();
    if (DeviceConfig.simListData.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        selectedAccount(DeviceConfig.simListData[0]);
        setState((){});
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (DeviceConfig.simListData.isNotEmpty) {
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
            for (int i = 0; i < DeviceConfig.simListData.length; i++)
              Column(
                children: [
                  SimCardData(
                    displayNumber: (i+1).toString(),
                    simData: DeviceConfig.simListData[i],
                    value: _currentSelected,
                    onChange: (selected) {
                      selectedAccount(selected);
                      setState(() {});
                    },
                  ),
                  if (i != DeviceConfig.simListData.length - 1)
                    Divider(
                      thickness: 1,
                      color: widget.appColors.primaryColor,
                    )
                ],
              )
          ]),
        ),
      );
    } else {
      _currentSelected = null;
      return const Center(
        child: Text('No Sim'),
      );
    }
  }

  selectedAccount(SimLocalData simData) {
    widget.onSelected(simData);
    _currentSelected = simData;
  }
}
