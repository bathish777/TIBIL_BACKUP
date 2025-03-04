// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

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
        child: Container(
          //color:Colors.yellowAccent,  
          height: 500,
          width: double.infinity,
          margin:EdgeInsets.all(40) ,
          padding: EdgeInsets.all(190),
          alignment:Alignment.center ,
          decoration: BoxDecoration(
            color: Colors.purple,
            border: Border.all(color: Colors.black, width: 5),
            borderRadius: BorderRadius.circular(40),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              BoxShadow(color: Colors.black, 
              offset: Offset(5, 5),blurRadius:20, )
            ]
            

          ) ,

          child: Text("hello ibrahim hello",
          style: TextStyle(fontSize: 40, color: Colors.white)),

            
        )
        ),
    );
  }
}
