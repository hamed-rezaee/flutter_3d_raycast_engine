import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';

Color getColorBasedOnDepth({
  required Color color,
  required double depth,
  required double maxDepth,
  double adjustment = 0.1,
}) {
  final ratio = (1 - depth / (maxDepth + epsilon)) + adjustment;

  var red = (color.red * ratio).toInt();
  var green = (color.green * ratio).toInt();
  var blue = (color.blue * ratio).toInt();

  red = red.clamp(0, 255);
  green = green.clamp(0, 255);
  blue = blue.clamp(0, 255);

  return Color.fromARGB(255, red, green, blue);
}
