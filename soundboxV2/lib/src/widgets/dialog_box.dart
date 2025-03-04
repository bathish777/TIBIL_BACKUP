import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sound_box/src/domain/domain.dart';
import 'package:sound_box/src/theme/theme.dart';

class AppDialogBox extends StatefulWidget {
  const AppDialogBox({
    super.key,
    required this.child,
    required this.willPop,
    this.closeButtonPosition,
    this.closeButtonSize,
  });

  final Widget child;
  final bool willPop;
  final Size? closeButtonSize;
  final CloseButtonPosition? closeButtonPosition;

  static show(
    BuildContext context,
    Widget child, {
    bool willPop = false,
    bool barrierDismissible = false,
    void Function()? onDismiss,
    CloseButtonPosition? closeButtonPosition,
    Size? closeButtonSize,
  }) async {
    if (onDismiss != null) {
      AppDialogNavigatorObserver().registerCallbackForOnDismiss(onDismiss);
    }

    GlobalKey<AppDialogBoxState> appDialogBoxKey = GlobalKey();

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      routeSettings: const RouteSettings(name: 'app_dialog'),
      builder: (_) => PopScope(
        canPop: barrierDismissible,
        child: Align(
          alignment: Alignment.center,
          child: AppDialogBox(
            key: appDialogBoxKey,
            willPop: willPop,
            closeButtonPosition: closeButtonPosition,
            closeButtonSize: closeButtonSize,
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  State<AppDialogBox> createState() => AppDialogBoxState();
}

class AppDialogBoxState extends State<AppDialogBox> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AppDialogNavigatorObserver().registerDialog((widget.key as GlobalKey<AppDialogBoxState>));
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: widget.dip(15)),
        decoration: BoxDecoration(
            color: widget.appColors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(widget.dip(4)),
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
            ]),
        width: widget.dip(320),
        child: Stack(
          children: [
            Center(
              child: widget.child,
            ),
            if (widget.willPop)
              Positioned(
                top: widget.closeButtonPosition?.top ?? widget.dip(10),
                right: widget.closeButtonPosition?.right ?? widget.dip(10),
                child: GestureDetector(
                  onTap: () {
                    closeDialog();
                  },
                  child: SvgPicture.asset(
                    widget.appImages.close,
                    width: widget.closeButtonSize != null
                        ? widget.closeButtonSize?.width
                        : widget.dip(20),
                    height: widget.closeButtonSize != null
                        ? widget.closeButtonSize?.height
                        : widget.dip(20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  closeDialog() {
    Navigator.pop(context);
  }
}

class CloseButtonPosition {
  CloseButtonPosition(this.top, this.right);

  final double? top;
  final double? right;
}
