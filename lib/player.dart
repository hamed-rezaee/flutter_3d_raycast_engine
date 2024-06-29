import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';
import 'package:flutter_3d_raycast_engine/controller.dart';
import 'package:flutter_3d_raycast_engine/projection.dart';
import 'package:flutter_3d_raycast_engine/ray.dart';
import 'package:flutter_3d_raycast_engine/vector.dart';

class Player {
  Player(this.controller);

  Controller controller;
  Vector position = Vector(x: mapScale * 2, y: mapScale * 2);
  double angle = pi / 4;

  ({List<Ray> rays, List<Projection> projections}) castRayWall() {
    final rays = <Ray>[];
    final projections = <Projection>[];

    final startAngle = angle - halfFov;
    final endAngle = angle + halfFov;
    final rayStartX = (position.x / mapScale).floor() * mapScale;
    final rayStartY = (position.y / mapScale).floor() * mapScale;

    var verticalDepth = 0.0;
    var horizontalDepth = 0.0;

    for (var currentAngle = startAngle;
        currentAngle < endAngle;
        currentAngle += rayStep) {
      var materialY = 0;
      var materialX = 0;

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
        verticalDepth = (rayEndX - position.x) / currentSin;
        rayEndY = position.y + verticalDepth * currentCos;

        var mapTargetX = (rayEndX / mapScale).floor();
        final mapTargetY = (rayEndY / mapScale).floor();

        if (currentSin <= 0) {
          mapTargetX += rayDirectionX;
        }

        final targetSquare = mapTargetY * mapSize + mapTargetX;

        if (targetSquare < 0 || targetSquare >= map.length) {
          break;
        }

        if (map[targetSquare].materialIndex != 0) {
          materialY = map[targetSquare].materialIndex;

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
        horizontalDepth = (rayEndY - position.y) / currentCos;
        rayEndX = position.x + horizontalDepth * currentSin;

        final mapTargetX = (rayEndX / mapScale).floor();
        var mapTargetY = (rayEndY / mapScale).floor();

        if (currentCos <= 0) {
          mapTargetY += rayDirectionY;
        }

        final targetSquare = mapTargetY * mapSize + mapTargetX;

        if (targetSquare < 0 || targetSquare >= map.length) {
          break;
        }

        if (map[targetSquare].materialIndex != 0) {
          materialX = map[targetSquare].materialIndex;

          break;
        }

        rayEndY += rayDirectionY * mapScale;
      }

      final endX = verticalDepth < horizontalDepth ? tempX : rayEndX;
      final endY = verticalDepth < horizontalDepth ? tempY : rayEndY;

      var depth =
          verticalDepth < horizontalDepth ? verticalDepth : horizontalDepth;
      depth *= cos(angle - currentAngle);

      final wallHeight = min(mapScale * wallHeightMultiplier / depth, infinity);
      final isVertical = verticalDepth > horizontalDepth;

      rays.add(Ray(start: position, end: Vector(x: endX, y: endY)));

      projections.add(
        Projection(
          materialIndex: isVertical ? materialX : materialY,
          depth: depth,
          wallHeight: wallHeight,
          textureOffset:
              _calculateTextureOffset(isVertical, endY, endX).floorToDouble(),
          isVertical: verticalDepth < horizontalDepth,
        ),
      );
    }

    return (rays: rays, projections: projections);
  }

  double _calculateTextureOffset(bool isVertical, double endY, double endX) =>
      (isVertical ? endX : endY) / mapScale * textureScale;

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

    if (event.logicalKey == LogicalKeyboardKey.keyQ) {
      controller.strafeLeft = event is KeyRepeatEvent || event is KeyDownEvent;
    }

    if (event.logicalKey == LogicalKeyboardKey.keyE) {
      controller.strafeRight = event is KeyRepeatEvent || event is KeyDownEvent;
    }
  }

  void update() {
    var nextPosition = position;

    if (controller.rotateLeft) {
      angle += playerRotationSpeed;
    } else if (controller.rotateRight) {
      angle -= playerRotationSpeed;
    }

    if (controller.forward) {
      nextPosition = Vector(
        x: position.x + sin(angle) * playerSpeed,
        y: position.y + cos(angle) * playerSpeed,
      );
    } else if (controller.backward) {
      nextPosition = Vector(
        x: position.x - sin(angle) * playerSpeed,
        y: position.y - cos(angle) * playerSpeed,
      );
    }

    if (controller.strafeLeft) {
      nextPosition = Vector(
        x: position.x + cos(angle) * playerSpeed,
        y: position.y - sin(angle) * playerSpeed,
      );
    } else if (controller.strafeRight) {
      nextPosition = Vector(
        x: position.x - cos(angle) * playerSpeed,
        y: position.y + sin(angle) * playerSpeed,
      );
    }

    if (_isPositionValid(nextPosition)) {
      position = nextPosition;
    }

    angle = angle % (2 * pi);
  }

  bool _isPositionValid(Vector position) {
    final rowLeft = ((position.y - playerRadius) / mapScale).floor();
    final columnTop = ((position.x - playerRadius) / mapScale).floor();
    final rowRight = ((position.y + playerRadius) / mapScale).floor();
    final columnBottom = ((position.x + playerRadius) / mapScale).floor();

    return map[rowLeft * mapSize + columnTop].materialIndex == 0 &&
        map[rowLeft * mapSize + columnBottom].materialIndex == 0 &&
        map[rowRight * mapSize + columnTop].materialIndex == 0 &&
        map[rowRight * mapSize + columnBottom].materialIndex == 0;
  }
}
