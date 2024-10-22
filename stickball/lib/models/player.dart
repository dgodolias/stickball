import 'package:flutter/material.dart';

class Player {
  Offset position;
  double width;
  double height;

  Player({
    required this.position,
    required this.width,
    required this.height,
  });

  void move(Offset delta) {
    position += delta;
  }

  void draw(Canvas canvas) {
    final paint = Paint()..color = Colors.blue;
    canvas.drawCircle(position, width / 2, paint);
  }
}
