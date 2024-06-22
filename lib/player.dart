import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';
import 'package:flutter_3d_raycast_engine/controller.dart';
import 'package:flutter_3d_raycast_engine/projection.dart';
import 'package:flutter_3d_raycast_engine/ray.dart';

class Player {
  Player(this.controller);

  Controller controller;
  Offset position = const Offset(mapScale * 2, mapScale * 2);
  double angle = pi / 4;

  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = mapScale / 3;

    canvas.drawCircle(position, mapScale / 2, paint);

    final playerDirection = Offset(
      position.dx + sin(angle) * mapScale,
      position.dy + cos(angle) * mapScale,
    );

    canvas.drawLine(position, playerDirection, paint);
  }

  ({List<Ray> rays, List<Projection> projections}) castRay() {
    final rays = <Ray>[];
    final projections = <Projection>[];

    final startAngle = angle - halfFov;
    final endAngle = angle + halfFov;
    final rayStartX = (position.dx / mapScale).floor() * mapScale;
    final rayStartY = (position.dy / mapScale).floor() * mapScale;

    var verticalDepth = 0.0;
    var horizontalDepth = 0.0;

    for (var currentAngle = startAngle;
        currentAngle < endAngle;
        currentAngle += rayStep) {
      var currentSin = sin(currentAngle);
      currentSin = currentSin != 0 ? currentSin : epsilon;

      var currentCos = cos(currentAngle);
      currentCos = currentCos != 0 ? currentCos : epsilon;

      var rayEndX = 0.0;
      var rayEndY = 0.0;
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

      var depth =
          verticalDepth < horizontalDepth ? verticalDepth : horizontalDepth;
      depth *= cos(angle - currentAngle);

      final wallHeight = min(mapScale * wallHeightMultiplier / depth, height);

      rays.add(Ray(start: position, end: Offset(endX, endY)));

      projections.add(
        Projection(
          depth: depth,
          wallHeight: wallHeight,
          isVertical: verticalDepth < horizontalDepth,
        ),
      );
    }

    return (rays: rays, projections: projections);
  }

  void handleKeyEvent(KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.keyW) {
      controller.forward = event is KeyRepeatEvent || event is KeyDownEvent;
    }

    if (event.logicalKey == LogicalKeyboardKey.keyS) {
      controller.backward = event is KeyRepeatEvent || event is KeyDownEvent;
    }

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      controller.rotateLeft = event is KeyRepeatEvent || event is KeyDownEvent;
    }

    if (event.logicalKey == LogicalKeyboardKey.keyD) {
      controller.rotateRight = event is KeyRepeatEvent || event is KeyDownEvent;
    }
  }

  void update() {
    if (controller.rotateLeft) {
      angle += playerRotationSpeed;
    } else if (controller.rotateRight) {
      angle -= playerRotationSpeed;
    }

    if (controller.forward) {
      final nextPosition = Offset(
        position.dx + sin(angle) * playerSpeed,
        position.dy + cos(angle) * playerSpeed,
      );

      if (_isPositionValid(nextPosition)) {
        position = nextPosition;
      }
    } else if (controller.backward) {
      final nextPosition = Offset(
        position.dx - sin(angle) * playerSpeed,
        position.dy - cos(angle) * playerSpeed,
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
