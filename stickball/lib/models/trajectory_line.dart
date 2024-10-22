import 'dart:math';
import 'package:flutter/material.dart';

class TrajectoryLine {
  List<Offset> points = [];
  Offset? dragStart;
  Offset? dragEnd;
  Offset playerPosition;
  Size screenSize;

  TrajectoryLine({required this.playerPosition, required this.screenSize});

  void startDrag(Offset position) {
    dragStart = playerPosition;
    dragEnd = null;
    points.clear();
  }

  void updateDrag(Offset position) {
    dragEnd = position;
    calculateTrajectory();
  }

  void endDrag() {
    dragStart = null;
    dragEnd = null;
    points.clear();
  }

  void calculateTrajectory() {
    if (dragStart == null || dragEnd == null) return;

    // Calculate the drag vector
    Offset dragVector = dragEnd! - dragStart!;
    
    // Reverse the direction and normalize
    double dragLength = dragVector.distance;
    if (dragLength == 0) return; // Prevent division by zero
    Offset normalizedDrag = Offset(-dragVector.dx / dragLength, -dragVector.dy / dragLength);
    
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
    if (points.isEmpty || dragStart == null || dragEnd == null) return;
    
    // Draw the line from player to drag end point
    canvas.drawLine(dragStart!, dragEnd!, linePaint);
    
    // Draw circles for trajectory points
    for (var point in points) {
      canvas.drawCircle(point, 5, circlePaint);
    }
  }

  void updatePlayerPosition(Offset newPosition) {
    playerPosition = newPosition;
    if (dragEnd != null) {
      calculateTrajectory();
    }
  }
}