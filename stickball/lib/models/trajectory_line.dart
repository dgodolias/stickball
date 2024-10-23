import 'package:flutter/material.dart';
import 'package:stickball/models/player.dart';
import 'package:stickball/utils.dart';

class TrajectoryLine {
  List<Offset> points = [];
  Offset? touchStartPoint;      // The position where the touch started
  Offset? currentTouchPoint;    // The current touch position
  Player player;
  Size screenSize;

  Offset? greenLineEndPoint;    // Endpoint of the green line

  TrajectoryLine({required this.player, required this.screenSize});

  void startDrag(Offset position) {
    touchStartPoint = position;
    currentTouchPoint = position;
    points.clear();
  }

  void updateDrag(Offset position) {
    currentTouchPoint = position;
    calculateTrajectory();
  }

  void endDrag() {
    touchStartPoint = null;
    currentTouchPoint = null;
    greenLineEndPoint = null;
    points.clear();
  }

  void calculateTrajectory() {
    if (touchStartPoint == null || currentTouchPoint == null) return;

        // Log player position and touch point
    print('TRAJECTORY:Player Position: dx=${player.position.dx}, dy=${player.position.dy}');
    print('TRAJECTORY:Touch Point: dx=${currentTouchPoint!.dx}, dy=${currentTouchPoint!.dy}');
    
    // Calculate the angle (theta)
    double theta = starting_trajectory_angle(
      player.position.dx,
      player.position.dy,
      currentTouchPoint!.dx,
      currentTouchPoint!.dy,
    );
    print('TRAJECTORY:Theta: $theta');
    
    // Calculate the initial velocity (v)
    double v = createVelocity(
      player.position.dx,
      player.position.dy,
      currentTouchPoint!.dx,
      currentTouchPoint!.dy,
    );
    print('TRAJECTORY:Initial Velocity (v): $v');

    // Generate points along the trajectory
    int numPoints = 10;
    points.clear();
    for (int i = 0; i < numPoints; i++) {
      double t = i / (numPoints - 1);
      double x = player.position.dx +
          StartingVelocityX(v, theta) * t * (numPoints - 1); // Adjust time step as needed
      double y = player.position.dy -
          createTrajectoryFunc(theta, v, x, player.position.dx, player.position.dy, 0, 0);
      points.add(Offset(x, y));
    }

    // Set the green line end point
    greenLineEndPoint = currentTouchPoint;
  }

  Offset? getEndPoint() {
    return points.isNotEmpty ? points.last : null;
  }

  void draw(Canvas canvas) {
    if (touchStartPoint == null || currentTouchPoint == null) return;

    // Draw the green line from player's position to greenLineEndPoint
    if (greenLineEndPoint != null) {
      final linePaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawLine(player.position, greenLineEndPoint!, linePaint);
    }

    // Draw yellow circles for trajectory points (mirrored direction)
    final circlePaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    for (var point in points) {
      canvas.drawCircle(point, screenSize.height * 0.01, circlePaint);
    }
  }

  void updatePlayerPosition(Offset newPosition) {
    player.position = newPosition;
  }
}