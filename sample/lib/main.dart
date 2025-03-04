// ignore_for_file: prefer_const_constructors



// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:flutter_application_1/widgets/container.dart';
// ignore: duplicate_import


// import './widgets/container.dart';
// import './widgets/rowcolumn.dart';
// import './widgets/text.dart';
// import './widgets/buttons.dart';
// import './widgets/photos.dart';
// import './widgets/soundbox.dart';


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // For FilteringTextInputFormatter
// import 'package:pinput/pinput.dart';
// import 'confirm_otp_page.dart'; // Import Confirm OTP Page
// import 'dashboard_page.dart'; // Import Dashboard Page


import 'package:flutter/material.dart';

// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'splash_screen.dart';




void main()  {
  //  await Hive.initFlutter();
  // runApp(MaterialApp(
  //   home: MyWidget(),
  // ));
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, title: "SOUND BOX", home:  SplashScreen());
  }
}
