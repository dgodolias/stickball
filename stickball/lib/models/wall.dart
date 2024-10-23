import 'package:flutter/material.dart';

class Wall {
  Offset position;
  double width;
  double height;

  Wall({
    required this.position,
    required this.width,
    required this.height,
  });

  void draw(Canvas canvas) {
    final paint = Paint()..color = Colors.brown; // Change color to make it visible
    canvas.drawRect(Rect.fromLTWH(position.dx, position.dy, width, height), paint);
  }
}