import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For FilteringTextInputFormatter
import 'package:flutter_application_1/project/dashboard_page.dart';
import 'package:pinput/pinput.dart';

import 'package:flutter_application_1/project/sign_up_page.dart'; // Import the SignUpPage

void main() {
  runApp(MaterialApp(
    home: MyWidget(),
  ));
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpPage = false;
  bool _isPhoneValid = false;
  bool _isOtpValid = false;
  bool _isChecked = true;

  // Navigate to OTP page
  void _navigateToOtpPage() {
    if (_phoneController.text.isNotEmpty && _phoneController.text.length == 10 && _isChecked) {
      setState(() {
        _isOtpPage = true;
      });
    }
  }

  // Verify OTP and navigate to Dashboard
  void _verifyOtp() {
    if (_otpController.text.length == 4) {
      print('OTP entered: ${_otpController.text}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage(phoneNumber: _phoneController.text)),
      );
    }
  }

  // Navigate to Sign Up page
  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  // Validation
  @override
  void initState() {
    super.initState();

    _phoneController.addListener(() {
      setState(() {
        _isPhoneValid = _phoneController.text.length == 10;
      });
    });

    _otpController.addListener(() {
      setState(() {
        _isOtpValid = _otpController.text.length == 4;
      });
    });
  }

  // Show terms and conditions popup
  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms and Conditions'),
          content: Container(
            width: 200, // Adjust width as needed
            height: 120, // Adjust height as needed
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: Container(
            width: 350,
            height: 500,
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: ArcPainter(),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80),
                if (!_isOtpPage)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          
                          width: 270,
                          height: 42,
                          child: TextField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              
                              labelText: "Phone Number",
                              hintText: "Enter 10-digit phone number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.zero,
                                  bottomRight: Radius.zero,
                                  topRight: Radius.zero,
                                ),
                                borderSide: BorderSide(color: Color(0xFF989895), width: 1),
                              ),
                              counterText: "",
                            ),
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                              activeColor: Colors.grey,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'I agree with the ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      decoration: TextDecoration.underline, // Underline text
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = _showTermsAndConditions,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Enter OTP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          child: Pinput(
                            length: 4,
                            controller: _otpController,
                            defaultPinTheme: PinTheme(
                              width: 56,
                              height: 56,
                              textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onCompleted: (pin) {
                              print('OTP entered: $pin');
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: !_isOtpPage
                        ? (_isPhoneValid && _isChecked ? _navigateToOtpPage : null)
                        : (_isOtpValid ? _verifyOtp : null),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        !_isOtpPage
                            ? (_isPhoneValid && _isChecked ?  Color.fromARGB(255, 218, 16, 126)  : Colors.grey)
                            : (_isOtpValid ?  Color.fromARGB(255, 218, 16, 126) : Colors.grey),
                      ),
                    ),
                    child: Text(
                      !_isOtpPage ? 'Sign In' : 'Submit',
                      style: TextStyle(
                        color: Colors.white, // Change the text color to white
                      ),
                    ),
                  ),
                ),
                if (!_isOtpPage) // Show the "Sign Up" text only on the phone input page
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'New to the app?  Please ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextSpan(
                            text: 'Sign up',
                            style: TextStyle(
                              fontSize: 14,
                              color:  Color.fromARGB(255, 218, 16, 126) ,
                              decoration: TextDecoration.underline, // Underline text
                            ),
                            recognizer: TapGestureRecognizer()..onTap = _navigateToSignUp,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color.fromARGB(255, 218, 16, 126) // Background color of the arc
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(size.width / 2, size.height * 3, size.width, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

