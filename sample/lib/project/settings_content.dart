import 'package:flutter/material.dart';
// import 'package:flutter_application_1/project/LanguagePreferencePage';
import 'package:flutter_application_1/project/my_profile_page.dart';
import 'package:flutter_application_1/project/my_qr_code_page.dart';
import 'language_preference_page.dart'; // Import the new page

class SettingsContent extends StatefulWidget {
  @override
  _SettingsContentState createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  bool _isMuted = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.person),
          title: Text('My Profile'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyProfilePage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.qr_code),
          title: Text('My QR Code'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyQRCodePage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.announcement),
          title: Text('Announcement'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isMuted
                  ? Icon(Icons.notifications_off, color: Colors.red, size: 24)
                  : Icon(Icons.notifications_active, color: Colors.green, size: 24),
              SizedBox(width: 8),
              Switch(
                value: !_isMuted,
                onChanged: (value) {
                  setState(() {
                    _isMuted = !value; // Invert the value to match the icon
                  });
                },
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.language),
          title: Text('My Language Preference'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LanguagePreferencePage()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Sign Out'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Implement sign out functionality or navigate to a sign out page
          },
        ),
      ],
    );
  }
}
