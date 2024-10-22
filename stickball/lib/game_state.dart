import 'package:flutter/material.dart';
import 'package:stickball/utils.dart';

class GameState extends ChangeNotifier {
Offset? _position;
double? width;
double? height;
bool isGameOver = false;

void initializeGame(BuildContext context) {
  width = percentageOfWidth(context, 5);
  height = percentageOfHeight(context, 5);
  _position = getCenterPosition(context, width!, height!);
  isGameOver = false;
  notifyListeners();
}

void movePlayer(BuildContext context) {
  if (_position == null) return;
  _position = moveByPercentage(context, _position!, 0.2, 1.8, width!, height!);
  
  // Check if player is out of bounds
  if (_isOutOfBounds(context)) {
    isGameOver = true;
  }
  
  notifyListeners();
}

bool _isOutOfBounds(BuildContext context) {
  if (_position == null) return false;
  final Size screenSize = MediaQuery.of(context).size;
  return _position!.dx < 0 ||
         _position!.dx > screenSize.width - width! ||
         _position!.dy < 0 ||
         _position!.dy > screenSize.height - height!;
}

Offset? get position => _position;
}