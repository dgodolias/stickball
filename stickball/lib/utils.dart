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