// TODO Implement this library.import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class LanguagePreferencePage extends StatefulWidget {
  @override
  _LanguagePreferencePageState createState() => _LanguagePreferencePageState();
}

class _LanguagePreferencePageState extends State<LanguagePreferencePage> {
  bool _isHindiSelected = false;
  bool _isKannadaSelected = false;
  bool _isEnglishSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Language Preference'),
        backgroundColor: Color.fromARGB(255, 218, 16, 126),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: Text('Hindi'),
              value: _isHindiSelected,
              onChanged: (bool? value) {
                setState(() {
                  _isHindiSelected = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Kannada'),
              value: _isKannadaSelected,
              onChanged: (bool? value) {
                setState(() {
                  _isKannadaSelected = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('English'),
              value: _isEnglishSelected,
              onChanged: (bool? value) {
                setState(() {
                  _isEnglishSelected = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
