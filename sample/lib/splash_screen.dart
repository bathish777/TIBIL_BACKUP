// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_application_1/project/stateful.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyWidget()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 218, 16, 126) ,
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated image with border shadow
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                  
                    decoration: BoxDecoration(

                      boxShadow: [
                        BoxShadow(
                          
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/jana.png",
                      width: 250 * value, // Gradually increase size
                      height: 250 * value,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20), // Space between image and text
            // Text below the image
            Text(
              'Mobile SoundBox',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
