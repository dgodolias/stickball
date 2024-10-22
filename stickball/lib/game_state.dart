import 'package:flutter/material.dart';
import 'package:stickball/utils.dart';
import 'package:stickball/models/trajectory_line.dart';
import 'package:stickball/models/player.dart';

class GameState extends ChangeNotifier {
  Player? player;
  bool isGameOver = false;
  TrajectoryLine? trajectoryLine;
  Size? screenSize;

  void initializeGame(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    double width = percentageOfWidth(context, 5);
    double height = percentageOfHeight(context, 5);
    Offset position = getCenterPosition(context, width, height);

    player = Player(position: position, width: width, height: height);
    isGameOver = false;
    trajectoryLine = TrajectoryLine(player: player!, screenSize: screenSize!);

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
    if (endPoint != null && player != null) {
      player!.position = endPoint;
      trajectoryLine?.updatePlayerPosition(player!.position);
      if (_isOutOfBounds()) {
        isGameOver = true;
      }
    }
  }

  bool _isOutOfBounds() {
    if (player == null || screenSize == null) return false;
    return player!.position.dx < 0 ||
        player!.position.dx > screenSize!.width - player!.width ||
        player!.position.dy < 0 ||
        player!.position.dy > screenSize!.height - player!.height;
  }
}