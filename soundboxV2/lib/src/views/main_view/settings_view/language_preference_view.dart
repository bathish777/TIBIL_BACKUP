import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';

import 'package:sound_box/src/data/app_dependency_injection.dart';
import 'package:sound_box/src/domain/bloc/blocs.dart';
import '../../../domain/domain.dart';
import '../../../localization/l10n.dart';
import '../../../widgets/dialog_box.dart';

class LanguagePreferenceView extends StatefulWidget {
  const LanguagePreferenceView({super.key});

  @override
  State<LanguagePreferenceView> createState() => LanguagePreferenceViewState();
}

class LanguagePreferenceViewState extends State<LanguagePreferenceView> {
  late List<AppLanguage> languages;

  late Locale _currentLocale;

  late PreferenceController preferenceController;

  @override
  void initState() {
    super.initState();
    preferenceController = getIt<PreferenceController>();
    languages = L10n.supportedLanguages;
    _currentLocale = preferenceController.locale;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return BaseContainer(
      title: l10n.app.language_preference,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: widget.dip(4),
          horizontal: widget.dip(10),
        ),
        decoration: BoxDecoration(
          color: widget.appColors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(widget.dip(4)),
          ),
        ),
        child: Column(
          children: [
            for (int i = 0; i < languages.length; i++)
              LanguageRadioButton(
                value: _currentLocale,
                language: languages[i],
                isLast: (i == languages.length - 1),
                onChange: _setLocal,
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

  void _setLocal(Locale locale) async {

    loaderMask(true);

    final preferences =
        await preferenceController.changeAppLocale(locale);

    loaderMask(false);

    if (preferences != null) {
      setState(() {
        _currentLocale = locale;
      });
    }
  }
}
