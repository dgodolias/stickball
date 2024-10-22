import 'package:flutter/material.dart';

class TrajectoryLine {
  List<Offset> points = [];
  Offset? touchStartPoint;      // The position where the touch started
  Offset? currentTouchPoint;    // The current touch position
  Offset playerPosition;
  Size screenSize;

  Offset? greenLineEndPoint;    // Endpoint of the green line

  TrajectoryLine({required this.playerPosition, required this.screenSize});

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

    // Calculate the movement vector (delta)
    Offset delta = currentTouchPoint! - touchStartPoint!;

    // The green line shows the drag movement
    greenLineEndPoint = playerPosition + delta;

    // For the trajectory, reverse the delta to predict movement in the opposite direction
    Offset reversedDelta = -delta;

    // Optionally, apply a scaling factor to adjust the speed
    double scalingFactor = 1.0; // Adjust as needed (e.g., 1.5 for faster movement)

    // Calculate the trajectory endpoint (yellow dots)
    Offset trajectoryEndPoint = playerPosition + reversedDelta * scalingFactor;

    // Generate points along the trajectory from player's position to trajectory endpoint
    int numPoints = 10;
    points.clear();
    for (int i = 0; i < numPoints; i++) {
      double t = i / (numPoints - 1); // Value from 0 to 1
      Offset point = Offset.lerp(playerPosition, trajectoryEndPoint, t)!;
      points.add(point);
    }
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
      canvas.drawLine(playerPosition, greenLineEndPoint!, linePaint);
    }

    // Draw yellow circles for trajectory points (mirrored direction)
    final circlePaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    for (var point in points) {
      canvas.drawCircle(point, 5, circlePaint);
    }
  }

  void updatePlayerPosition(Offset newPosition) {
    playerPosition = newPosition;
    if (touchStartPoint != null && currentTouchPoint != null) {
      calculateTrajectory();
    }
  }
}