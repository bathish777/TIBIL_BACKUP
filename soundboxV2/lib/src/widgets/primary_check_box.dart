import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';

class PrimaryCheckBox extends StatefulWidget {
  const PrimaryCheckBox({
    super.key,
    this.value = true,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<PrimaryCheckBox> createState() => _PrimaryCheckBoxState();
}

class _PrimaryCheckBoxState extends State<PrimaryCheckBox> {
  late bool _check;

  @override
  void initState() {
    _check = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final checkColor = widget.appColors.friarGray;

    return GestureDetector(
      onTap: () {
        setState(() {
          _check = !_check;
        });
        widget.onChanged(_check);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: widget.dip(18),
        height: widget.dip(18),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: checkColor,
            width: 1,
          ),
          borderRadius:
              BorderRadius.circular(widget.dip(4)), // Optional: Rounded corners
        ),
        child: _check
            ? Icon(
                Icons.check,
                color: checkColor,
                size: widget.dip(12),
              )
            : null,
      ),
    );
  }
}
