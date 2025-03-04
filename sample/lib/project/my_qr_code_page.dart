import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQRCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String qrData = "https://example.com"; // Replace with actual QR code data

    return Scaffold(
      appBar: AppBar(
        title: Text('My QR Code'),
        backgroundColor: Color.fromARGB(255, 218, 16, 126),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
      ),
    );
  }
}
