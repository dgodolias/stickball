import 'dart:math';
import 'package:flutter/material.dart';

class TrajectoryLine {
  List<Offset> points = [];
  Offset? startPoint;
  Offset? endPoint;
  Offset playerPosition;
  Size screenSize;

  TrajectoryLine({required this.playerPosition, required this.screenSize});

  void startDrag(Offset position) {
    startPoint = playerPosition; // Start from the player's center
    endPoint = null;
    points.clear();
  }

  void updateDrag(Offset position) {
    endPoint = position;
    calculateTrajectory();
  }

  void endDrag() {
    startPoint = null;
    endPoint = null;
    points.clear();
  }

  void calculateTrajectory() {
    if (startPoint == null || endPoint == null) return;

    // Calculate the drag vector
    Offset dragVector = endPoint! - startPoint!;
    
    // Reverse the direction
    Offset reversedVector = -dragVector;
    
    // Normalize the reversed vector
    double dragLength = reversedVector.distance;
    Offset normalizedDrag = Offset(reversedVector.dx / dragLength, reversedVector.dy / dragLength);
    
    // Calculate the total trajectory length (you can adjust this factor)
    double trajectoryLength = dragLength * 1.5;

    points.clear();
    for (int i = 0; i < 10; i++) {
      double t = i / 9.0; // Distribute points evenly along the trajectory
      double x = playerPosition.dx + normalizedDrag.dx * t * trajectoryLength;
      double y = playerPosition.dy + normalizedDrag.dy * t * trajectoryLength;
      points.add(Offset(x, y));
    }
  }

  Offset? getEndPoint() {
    return points.isNotEmpty ? points.last : null;
  }

  void draw(Canvas canvas, Paint linePaint, Paint circlePaint) {
    if (points.isEmpty) return;
    
    // Draw the green line from player to drag end point
    canvas.drawLine(playerPosition, endPoint!, linePaint);
    
    // Draw yellow circles for trajectory points
    for (var point in points) {
      canvas.drawCircle(point, 5, circlePaint);
    }
  }
}