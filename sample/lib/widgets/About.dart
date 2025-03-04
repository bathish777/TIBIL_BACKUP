import 'package:flutter/material.dart';
class About extends StatelessWidget {
  const About ({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("hello"),
        
      ),
      body: Center(child: Column(
        children: [
          
          ElevatedButton(onPressed: () {Navigator.pop(context);
          },child: Text("Back"),
      ),],

      ),),

    );
  }
}