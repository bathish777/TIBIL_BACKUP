// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For FilteringTextInputFormatter

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();

    _phoneController.addListener(() {
      setState(() {
        _isPhoneValid = _phoneController.text.length == 10;
      });
    });
  }

  // void _submit() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     // Perform the sign-up logic here
  //     print('Name: ${_nameController.text}');
  //     print('Phone: ${_phoneController.text}');
  //     // Navigate to another page or show success message
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Minimize the space the column takes
              crossAxisAlignment: CrossAxisAlignment.center, // Center the children horizontally
              children: [
                Container(
                  width: 300, // Adjust the width as needed
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 300, // Adjust the width as needed
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter 10-digit phone number',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isPhoneValid ? (){}: null,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
