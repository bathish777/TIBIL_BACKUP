import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sound_box/src/data/repositories/terms_conditions_repository.dart';
import 'package:sound_box/src/localization/l10n.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../data/app_dependency_injection.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({super.key});

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    final PlatformDispatcher platformDispatcher = PlatformDispatcher.instance;
    final FlutterView view = platformDispatcher.views.first;
    final Size pSize = view.physicalSize / view.devicePixelRatio;

    return Container(
      padding: EdgeInsets.only(
        top: widget.dip(19),
        bottom: widget.dip(19),
        left: widget.dip(19),
        right: widget.dip(10),
      ),
      height: pSize.height * (0.90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: widget.dip(4), bottom: widget.dip(25)),
            child: Text(
              l10n.app.term_condition,
              style: widget.appTypography.themeTextStyle
                  .secondaryFontWeight700Style(
                    color: widget.appColors.primaryColor,
                    fontSize: 16,
                  )
                  .copyWith(height: 0),
            ),
          ),
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(Colors.transparent),
                trackColor: MaterialStateProperty.all(Colors.transparent),
                trackBorderColor: MaterialStateProperty.all(Colors.transparent),
                thumbVisibility: MaterialStateProperty.all(false),
                thickness: MaterialStateProperty.all(3),
                radius: Radius.circular(widget.dip(2)),
              ),
              child: RawScrollbar(
                controller: _scrollController,
                thumbColor: widget.appColors.primaryColor,
                thickness: 3,
                radius: const Radius.circular(2),
                child: Padding(
                  padding: EdgeInsets.only(right: widget.dip(6)),
                  child: FutureBuilder(
                    builder: (context, state) {
                      if (state.hasData) {
                        final rawHtml = state.data;

                        return SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                            padding: EdgeInsets.only(right: widget.dip(6)),
                            child: Html(
                              data: rawHtml,
                              style: {
                                "body": Style(
                                  fontSize: FontSize.medium,
                                  color: widget.appColors.primaryTextColor,
                                ),
                              },
                            ),
                          ),
                        );
                      } else if (state.hasError) {
                        return Center(
                          child: Text(
                            L10n.of(context).app.terms_conditions_error_text,
                            style: widget.appTypography.themeTextStyle.primaryFontWeight400Style(
                              color: widget.appColors.primaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    future: getIt<TermsConditionsRepository>().get(),
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
