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
      ..strokeWidth = mapScale / 3;

    canvas.drawCircle(position, mapScale / 2, paint);

    final playerDirection = Offset(
      position.dx + sin(angle) * mapScale,
      position.dy + cos(angle) * mapScale,
    );

    canvas.drawLine(position, playerDirection, paint);
  }

  List<Offset> castRay() {
    final List<Offset> rays = [];

    double startAngle = angle - halfFov;
    double endAngle = angle + halfFov;
    double rayStartX = (position.dx / mapScale).floor() * mapScale;
    double rayStartY = (position.dy / mapScale).floor() * mapScale;

    for (double currentAngle = startAngle;
        currentAngle < endAngle;
        currentAngle += rayStep) {
      double currentSin = sin(currentAngle);
      currentSin = currentSin != 0 ? currentSin : 0.000001;

      double currentCos = cos(currentAngle);
      currentCos = currentCos != 0 ? currentCos : 0.000001;

      double rayEndX = 0, rayEndY = 0, verticalDepth = 0;
      int rayDirectionX = 0;

      if (currentSin > 0) {
        rayEndX = rayStartX + mapScale;
        rayDirectionX = 1;
      } else {
        rayEndX = rayStartX;
        rayDirectionX = -1;
      }

      for (double offset = 0; offset < mapRange; offset += mapScale) {
        verticalDepth = (rayEndX - position.dx) / currentSin;
        rayEndY = position.dy + verticalDepth * currentCos;

        int mapTargetX = (rayEndX / mapScale).floor();
        int mapTargetY = (rayEndY / mapScale).floor();

        if (currentSin <= 0) {
          mapTargetX += rayDirectionX;
        }

        int targetSquare = mapTargetY * mapSize + mapTargetX;

        if (targetSquare < 0 || targetSquare >= map.length) {
          break;
        }

        if (map[targetSquare] != 0) {
          break;
        }

        rayEndX += rayDirectionX * mapScale;
      }

      double tempX = rayEndX;
      double tempY = rayEndY;

      double horizontalDepth = 0;
      int rayDirectionY;

      if (currentCos > 0) {
        rayEndY = rayStartY + mapScale;
        rayDirectionY = 1;
      } else {
        rayEndY = rayStartY;
        rayDirectionY = -1;
      }

      for (double offset = 0; offset < mapRange; offset += mapScale) {
        horizontalDepth = (rayEndY - position.dy) / currentCos;
        rayEndX = position.dx + horizontalDepth * currentSin;

        int mapTargetX = (rayEndX / mapScale).floor();
        int mapTargetY = (rayEndY / mapScale).floor();

        if (currentCos <= 0) {
          mapTargetY += rayDirectionY;
        }

        int targetSquare = mapTargetY * mapSize + mapTargetX;

        if (targetSquare < 0 || targetSquare >= map.length) {
          break;
        }

        if (map[targetSquare] != 0) {
          break;
        }

        rayEndY += rayDirectionY * mapScale;
      }

      double endX = verticalDepth < horizontalDepth ? tempX : rayEndX;
      double endY = verticalDepth < horizontalDepth ? tempY : rayEndY;

      rays.add(Offset(endX, endY));
    }

    return rays;
  }

  void drawRays(Canvas canvas, List<Offset> rays) {
    final Paint paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2;

    for (final ray in rays) {
      canvas.drawLine(position, ray, paint);
    }
  }

  void handleKeyEvent(KeyEvent value) {
    bool isRotateLeft = value.logicalKey == LogicalKeyboardKey.keyA;
    bool isRotateRight = value.logicalKey == LogicalKeyboardKey.keyD;
    bool isMoveForward = value.logicalKey == LogicalKeyboardKey.keyW;
    bool isMoveBackward = value.logicalKey == LogicalKeyboardKey.keyS;

    if (isRotateLeft) {
      angle += 0.1;
    } else if (isRotateRight) {
      angle -= 0.1;
    }

    if (isMoveForward) {
      final nextPosition = Offset(
        position.dx + sin(angle) * mapSpeed,
        position.dy + cos(angle) * mapSpeed,
      );

      if (_isPositionValid(nextPosition)) {
        position = nextPosition;
      }
    } else if (isMoveBackward) {
      final nextPosition = Offset(
        position.dx - sin(angle) * mapSpeed,
        position.dy - cos(angle) * mapSpeed,
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

    return map[row * mapSize + column] == 0;
  }
}
