import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'header.dart';

class BaseContainer extends StatelessWidget {
  const BaseContainer({
    super.key,
    required this.title,
    required this.child,
    this.willPopUp = true,
  });

  final String title;
  final Widget child;
  final bool willPopUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Header(
          title: title,
          willPopUp: willPopUp,
          hideQRCode: true,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: dip(20),
              horizontal: dip(10),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
