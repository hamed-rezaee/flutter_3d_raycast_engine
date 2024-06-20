import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';

class Player {
  Player();

  Offset position = const Offset(mapScale + 20, mapScale + 20);
  double angle = 0;

  void draw(Canvas canvas) {
    final paint = Paint()
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
    final rays = <Offset>[];

    final startAngle = angle - halfFov;
    final endAngle = angle + halfFov;
    final rayStartX = (position.dx / mapScale).floor() * mapScale;
    final rayStartY = (position.dy / mapScale).floor() * mapScale;

    for (var currentAngle = startAngle;
        currentAngle < endAngle;
        currentAngle += rayStep) {
      var currentSin = sin(currentAngle);
      currentSin = currentSin != 0 ? currentSin : 0.000001;

      var currentCos = cos(currentAngle);
      currentCos = currentCos != 0 ? currentCos : 0.000001;

      var rayEndX = 0.0;
      var rayEndY = 0.0;
      var verticalDepth = 0.0;
      var rayDirectionX = 0;

      if (currentSin > 0) {
        rayEndX = rayStartX + mapScale;
        rayDirectionX = 1;
      } else {
        rayEndX = rayStartX;
        rayDirectionX = -1;
      }

      for (var offset = 0.0; offset < mapRange; offset += mapScale) {
        verticalDepth = (rayEndX - position.dx) / currentSin;
        rayEndY = position.dy + verticalDepth * currentCos;

        var mapTargetX = (rayEndX / mapScale).floor();
        final mapTargetY = (rayEndY / mapScale).floor();

        if (currentSin <= 0) {
          mapTargetX += rayDirectionX;
        }

        final targetSquare = mapTargetY * mapSize + mapTargetX;

        if (targetSquare < 0 || targetSquare >= map.length) {
          break;
        }

        if (map[targetSquare] != 0) {
          break;
        }

        rayEndX += rayDirectionX * mapScale;
      }

      final tempX = rayEndX;
      final tempY = rayEndY;

      var horizontalDepth = 0.0;
      int rayDirectionY;

      if (currentCos > 0) {
        rayEndY = rayStartY + mapScale;
        rayDirectionY = 1;
      } else {
        rayEndY = rayStartY;
        rayDirectionY = -1;
      }

      for (var offset = 0.0; offset < mapRange; offset += mapScale) {
        horizontalDepth = (rayEndY - position.dy) / currentCos;
        rayEndX = position.dx + horizontalDepth * currentSin;

        final mapTargetX = (rayEndX / mapScale).floor();
        var mapTargetY = (rayEndY / mapScale).floor();

        if (currentCos <= 0) {
          mapTargetY += rayDirectionY;
        }

        final targetSquare = mapTargetY * mapSize + mapTargetX;

        if (targetSquare < 0 || targetSquare >= map.length) {
          break;
        }

        if (map[targetSquare] != 0) {
          break;
        }

        rayEndY += rayDirectionY * mapScale;
      }

      final endX = verticalDepth < horizontalDepth ? tempX : rayEndX;
      final endY = verticalDepth < horizontalDepth ? tempY : rayEndY;

      rays.add(Offset(endX, endY));
    }

    return rays;
  }

  void drawRays(Canvas canvas, List<Offset> rays) {
    final paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 2;

    for (final ray in rays) {
      canvas.drawLine(position, ray, paint);
    }
  }

  void handleKeyEvent(KeyEvent value) {
    final isRotateLeft = value.logicalKey == LogicalKeyboardKey.keyA;
    final isRotateRight = value.logicalKey == LogicalKeyboardKey.keyD;
    final isMoveForward = value.logicalKey == LogicalKeyboardKey.keyW;
    final isMoveBackward = value.logicalKey == LogicalKeyboardKey.keyS;

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
    final row = (position.dy / mapScale).floor();
    final column = (position.dx / mapScale).floor();

    return map[row * mapSize + column] == 0;
  }
}
