import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';

class PrimaryRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const PrimaryRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.size = 24.0,
    this.activeColor = const Color(0xFFDA107E),
    this.inactiveColor = const Color(0xFFD8D8D8),
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? appColors.primaryColor : appColors.alto,
            width: 1,
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? size / 2 : 0.0,
            height: isSelected ? size / 2 : 0.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? appColors.primaryColor : appColors.alto,
            ),
          ),
        ),
      ),
    );
  }
}