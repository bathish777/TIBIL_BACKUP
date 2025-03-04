// ignore_for_file: prefer_const_constructors, unnecessary_import

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/boxes.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar
      appBar: AppBar(
        title: Text('SOUND BOX'),
        centerTitle: true,
        backgroundColor: Colors.pink[500],

        //leading
        leading: Icon(Icons.home_filled),
        //action
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          IconButton(onPressed: null, icon: Icon(Icons.favorite)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: null, icon: Icon(Icons.person)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_sharp))
        ],
        //shape
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(120))),

        //elevation
        elevation: 60,
      ),
      body: Center(
        child: (Column(
          children: [
            TextButton(onPressed: () {}, child: Text("hello")),
           
            ElevatedButton(onPressed: () {}, child: Text("signin")),
            TextField(
              decoration: InputDecoration(
                labelText: "User name",
                hintText: "enter name",
                prefixIcon: Icon(Icons.person),
                suffixIcon: Icon(Icons.verified),
                prefixText: " Mr. ",
              ),
            ),
            TextField(
                decoration: InputDecoration(
                    labelText: "User Ph No",
                    hintText: "Enter Ph No",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.contact_page),
                    prefixText: " 91 . ",
                    helperText: "Enter Ph No",
                    labelStyle: TextStyle(
                      color: Colors.red,
                    ))),
            TextField(
              maxLength: 5,
              obscureText: true,
            ),
            TextField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                label: Text("user"),
                filled: true,
                fillColor: Colors.blue,
              ),
            )
          ],
        )),
      ),
    );
  }
}
