import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickball/game_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MyApp(),
    ),
  );
}