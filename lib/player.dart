import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';

class Player {
  Player();

  Offset position = const Offset(mapScale + 20, mapScale + 20);
  double angle = 0;

  void draw(Canvas canvas) {
    final Paint paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;

    canvas.drawCircle(position, 5, paint);

    final playerDirection = Offset(
      position.dx + 10 * cos(angle),
      position.dy + 10 * sin(angle),
    );

    canvas.drawLine(position, playerDirection, paint);
  }
}
