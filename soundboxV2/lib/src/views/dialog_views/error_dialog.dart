import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/localization/l10n.dart';

import '../../domain/bloc/authentication/authentication_bloc.dart';
import '../../widgets/dialog_box.dart';

class ErrorDialog {
  static bool isDialogOpened = false;

  static show({
    required BuildContext context,
    String? title,
    bool closeEvent = true,
    required String errorText,
  }) {
    if (!ErrorDialog.isDialogOpened) {
      ErrorDialog.isDialogOpened = true;

      AppDialogBox.show(
          context,
          ErrorView(
            title: title,
            errorText: errorText,
            closeEvent: closeEvent,
          ), onDismiss: () {
        ErrorDialog.isDialogOpened = false;
      });
    }
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    this.title,
    required this.errorText,
    required this.closeEvent,
  });

  final String? title;
  final String errorText;
  final bool closeEvent;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final themeTextStyle = appTypography.themeTextStyle;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: dip(31),
        horizontal: dip(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            softWrap: true,
            maxLines: 3,
            textAlign: TextAlign.center,
            title ?? l10n.app.unexpected_error,
            style: appTypography.themeTextStyle.primaryFontWeight700Style(
              color: appColors.primaryTextColor,
              fontSize: 18,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: dip(20),
            ),
            child: Text(
              softWrap: true,
              maxLines: 3,
              textAlign: TextAlign.center,
              errorText,
              style: appTypography.themeTextStyle.primaryFontWeight400Style(
                color: appColors.primaryTextColor,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: dip(20),
            ),
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: dip(19), vertical: dip(0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(dip(4)),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (closeEvent) {
                      context.read<AuthenticationBloc>().add(
                            AuthenticationCheckUserCredentialEvent(),
                          );
                    }
                  },
                  child: Center(
                    child: Text(
                      L10n.of(context).app.ok_text,
                      style: themeTextStyle
                          .primaryFontWeight600Style(
                            color: appColors.white,
                            fontSize: 14,
                          )
                          .copyWith(height: 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
