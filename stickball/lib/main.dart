// main.dart
import 'package:flutter/material.dart';
import 'package:stickball/models/player.dart';
import 'package:stickball/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Print the screen dimensions
    printScreenDimensions(context);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MyPlayer(),
        ),
      ),
    );
  }
}