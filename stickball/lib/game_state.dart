import 'package:flutter/material.dart';
import 'package:stickball/utils.dart';
import 'package:stickball/models/trajectory_line.dart';

class GameState extends ChangeNotifier {
  Offset? _position;
  double? width;
  double? height;
  bool isGameOver = false;
  TrajectoryLine? trajectoryLine;
  Size? screenSize;

  void initializeGame(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = percentageOfWidth(context, 5);
    height = percentageOfHeight(context, 5);
    _position = getCenterPosition(context, width!, height!);
    isGameOver = false;
    trajectoryLine = TrajectoryLine(playerPosition: _position!, screenSize: screenSize!);
    notifyListeners();
  }

  void startDrag(Offset position) {
    trajectoryLine?.startDrag(position);
    notifyListeners();
  }

  void updateDrag(Offset position) {
    trajectoryLine?.updateDrag(position);
    notifyListeners();
  }

  void endDrag() {
    if (trajectoryLine?.getEndPoint() != null) {
      movePlayerAlongTrajectory();
    }
    trajectoryLine?.endDrag();
    notifyListeners();
  }

  void movePlayerAlongTrajectory() {
    Offset? endPoint = trajectoryLine?.getEndPoint();
    if (endPoint != null) {
      _position = endPoint;
      trajectoryLine?.updatePlayerPosition(_position!);
      if (_isOutOfBounds()) {
        isGameOver = true;
      }
    }
  }

  bool _isOutOfBounds() {
    if (_position == null || screenSize == null) return false;
    return _position!.dx < 0 ||
        _position!.dx > screenSize!.width - width! ||
        _position!.dy < 0 ||
        _position!.dy > screenSize!.height - height!;
  }

  Offset? get position => _position;
}