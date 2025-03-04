import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/localization/l10n.dart';

class LoaderMask extends StatelessWidget {
  const LoaderMask({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Container(
      color: Colors.black.withOpacity(0.7), // Semi-transparent overlay
      child: Center(
        child: FittedBox(
          child: Container(
            decoration: BoxDecoration(
              color: appColors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(dip(4)),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(253, 228, 241, 0.15),
                  offset: Offset(-2, -2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: Color.fromRGBO(253, 228, 241, 0.15),
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            width: dip(320),
            padding: EdgeInsets.all(dip(16)), // Add some padding if needed
            child: Center(
              child: Container(
                padding: EdgeInsets.only(
                  top: dip(60),
                  bottom: dip(137),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      title,
                      style: appTypography.themeTextStyle
                          .primaryFontWeight600Style(
                        color: appColors.primaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: dip(80),
                    ),
                    const _AnimatedLoading(),
                  ],
                ),
              ), // Loading indicator or animation
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedLoading extends StatefulWidget {
  const _AnimatedLoading({super.key});

  @override
  State<_AnimatedLoading> createState() => __AnimatedLoadingState();
}

class __AnimatedLoadingState extends State<_AnimatedLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 3,
    ),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
        turns: _controller,
        child: Center(
          child: SvgPicture.asset(
            widget.appImages.loading,
            width: widget.dip(250),
            height: widget.dip(250),
          ),
        ));
  }
}
