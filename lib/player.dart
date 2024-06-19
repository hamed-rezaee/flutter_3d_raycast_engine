import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void handleKeyEvent(KeyEvent value) {
    bool isRotateLeft = value.logicalKey == LogicalKeyboardKey.keyA;
    bool isRotateRight = value.logicalKey == LogicalKeyboardKey.keyD;
    bool isMoveForward = value.logicalKey == LogicalKeyboardKey.keyW;
    bool isMoveBackward = value.logicalKey == LogicalKeyboardKey.keyS;

    if (isRotateLeft) {
      angle -= 0.1;
    } else if (isRotateRight) {
      angle += 0.1;
    }

    if (isMoveForward) {
      final nextPosition = Offset(
        position.dx + cos(angle) * mapSpeed,
        position.dy + sin(angle) * mapSpeed,
      );

      if (_isPositionValid(nextPosition)) {
        position = nextPosition;
      }
    } else if (isMoveBackward) {
      final nextPosition = Offset(
        position.dx - cos(angle) * mapSpeed,
        position.dy - sin(angle) * mapSpeed,
      );

      if (_isPositionValid(nextPosition)) {
        position = nextPosition;
      }
    }

    angle = angle % (2 * pi);
  }

  bool _isPositionValid(Offset position) {
    final int row = (position.dy / mapScale).floor();
    final int column = (position.dx / mapScale).floor();

    return map[row][column] == 0;
  }
}
