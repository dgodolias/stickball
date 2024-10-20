// main.dart
import 'package:flutter/material.dart';
import 'package:stickball/models/player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Move the Player"),
        ),
        body: Center(
          child: MyPlayer(),
        ),
      ),
    );
  }
}