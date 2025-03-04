import 'package:flutter/material.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace with actual data
    final String name = "Ibrahim";
    final String phoneNumber = "8921385682";

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Color.fromARGB(255, 218, 16, 126),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Phone Number: $phoneNumber', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
