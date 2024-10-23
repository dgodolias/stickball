import 'dart:math';
import 'package:flutter/material.dart';

late final double SCRNwidth;
late final double SCRNheight;

void setScreenDimensions(BuildContext context) {
  final Size size = MediaQuery.sizeOf(context);
  SCRNwidth = size.width;
  SCRNheight = size.height;

  // Print the dimensions
  print('Screen width: $SCRNwidth');
  print('Screen height: $SCRNheight');
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

// Helper functions from your .h files
double createTrajectoryFunc(double theta, double v, double x_new, double x_start,
    double y_start, double ya, double yb) {
  double x = x_new - x_start;
  double y = (tan(theta) * x - (9.81 / (2 * pow(v, 2) * pow(cos(theta), 2))) * pow(x, 2));
  return y;
}

double createVelocity(double xa, double ya, double xb, double yb) {
  if (ya == yb) {
    if (xa > xb) return pow(pow(xa - xb, 2) + pow(ya - yb, 2), 0.5) / 2;
    if (xa < xb) return -pow(pow(xa - xb, 2) + pow(ya - yb, 2), 0.5) / 2;
    if (xa == xb) return 0;
  }
  if (ya > yb) return -pow(pow(xa - xb, 2) + pow(ya - yb, 2), 0.5) / 2;
  return pow(pow(xa - xb, 2) + pow(ya - yb, 2), 0.5) / 2;
}

double starting_trajectory_angle(double xa, double ya, double xb, double yb) {
  if (xa == xb) return 1.57078;
  return atan((ya - yb) / (xb - xa));
}

double StartingVelocityX(double v, double theta) {
  if (theta < 0) {
    return -v * cos(theta);
  }
  return v * cos(theta);
}