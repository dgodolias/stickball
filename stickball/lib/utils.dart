// utils.dart
import 'package:flutter/material.dart';

void printScreenDimensions(BuildContext context) {
  final Size size = MediaQuery.sizeOf(context);
  final double width = size.width;
  final double height = size.height;

  // Print the dimensions
  print('Screen width: $width');
  print('Screen height: $height');
}

double percentageOfWidth(BuildContext context, double percentage) {
  final double width = MediaQuery.sizeOf(context).width;
  return (percentage / 100) * width;
}

double percentageOfHeight(BuildContext context, double percentage) {
  final double height = MediaQuery.sizeOf(context).height;
  return (percentage / 100) * height;
}

Offset getCenterPosition(BuildContext context, double playerWidth, double playerHeight) {
  final double screenWidth = MediaQuery.sizeOf(context).width;
  final double screenHeight = MediaQuery.sizeOf(context).height;
  return Offset(
    (screenWidth - playerWidth) / 2,
    (screenHeight - playerHeight) / 2,
  );
}

Offset moveByPercentage(BuildContext context, Offset currentPosition, double widthPercentage, double heightPercentage, double playerWidth, double playerHeight) {
  final Offset newPosition = currentPosition + Offset(
    percentageOfWidth(context, widthPercentage),
    percentageOfHeight(context, heightPercentage),
  );
  return Offset(
    newPosition.dx - playerWidth / 2,
    newPosition.dy - playerHeight / 2,
  );
}