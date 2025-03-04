import 'package:sound_box/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:sound_box/src/views/dialog_views/mute_announcement_view.dart';
import 'package:sound_box/src/widgets/dialog_box.dart';

import 'package:sound_box/src/data/app_dependency_injection.dart';
import 'package:sound_box/src/domain/bloc/blocs.dart';

import '../domain/domain.dart';

class MuteSwitch extends StatefulWidget {
  const MuteSwitch({
    super.key,
    required this.onChange,
  });

  final void Function(bool value)? onChange;

  @override
  State<MuteSwitch> createState() => _MuteSwitchState();
}

class _MuteSwitchState extends State<MuteSwitch> {
  late bool isMuted;

  late PreferenceController preferenceController;

  @override
  void initState() {
    super.initState();
    preferenceController = getIt<PreferenceController>();
    isMuted = preferenceController.mute;
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.dip(35);
    final height = widget.dip(15);

    return GestureDetector(
      onTap: () {
        _setUpMute();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(
            color: !isMuted
                ? widget.appColors.primaryColor
                : widget.appColors.alto,
            width: widget.dip(1),
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              curve: Curves.easeInOut,
              left: !isMuted ? (width - height) : 0,
              top: 1,
              bottom: 1,
              duration: const Duration(milliseconds: 200),
              child: SizedBox.square(
                dimension: height - widget.dip(2),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: !isMuted
                        ? widget.appColors.primaryColor
                        : widget.appColors.alto,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loaderMask(bool show) {
    if(show){
      AppDialogBox.show(
        context,
        Padding(
          padding: EdgeInsets.all(
            widget.dip(80),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: widget.appColors.primaryColor,
            ),
          ),
        ),
      );
    } else {
      AppDialogNavigatorObserver().popUpDialogBox();
    }
  }

  _setUpMute() async {
    loaderMask(true);
    final preferences =
        await preferenceController.changeMuteAnnouncement(!isMuted);
    loaderMask(false);
    AppDialogBox.show(
      context,
      MuteAnnouncementView(isMuted: isMuted),
      barrierDismissible: true,
    );
    if (preferences != null) {
      isMuted = preferences.mute;
      if (widget.onChange != null) widget.onChange!(isMuted);
      setState(() {});
    }
  }
}
