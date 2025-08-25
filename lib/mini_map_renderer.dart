import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';
import 'package:flutter_3d_raycast_engine/map_information.dart';
import 'package:flutter_3d_raycast_engine/player.dart';
import 'package:flutter_3d_raycast_engine/vector.dart';

class MiniMapRenderer extends CustomPainter {
  const MiniMapRenderer({
    required this.player,
    required this.map,
  });

  final Player player;
  final List<MapInformation> map;

  @override
  void paint(Canvas canvas, Size size) {
    player.castRayWall().rays.forEach((ray) => ray.draw(canvas));
    _drawPlayer(canvas);

    _drawMap(canvas);
  }

  void _drawMap(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromLTRBR(
        -margin,
        -margin,
        mapRange + margin,
        mapRange + margin,
        const Radius.circular(4),
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.5),
    );

    final size = map.length ~/ mapSize;

    for (var row = 0; row < size; row++) {
      for (var column = 0; column < size; column++) {
        canvas
          ..drawRect(
            Rect.fromLTWH(
              column * mapScale,
              row * mapScale,
              mapScale,
              mapScale,
            ),
            Paint()
              ..color =
                  materials[map[row * mapSize + column].materialIndex].color,
          )
          ..drawCircle(
            Offset(
              column * mapScale + mapScale / 2,
              row * mapScale + mapScale / 2,
            ),
            mapScale / 3,
            Paint()
              ..color =
                  materials[map[row * mapSize + column].spriteIndex].color,
          );
      }
    }
  }

  void _drawPlayer(Canvas canvas) {
    final position = player.position.toOffset;
    final angle = player.angle;

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = playerRadius;

    canvas.drawCircle(position, mapScale / 2, paint);

    final playerDirection = Vector(
      x: position.dx + sin(angle) * mapScale,
      y: position.dy + cos(angle) * mapScale,
    );

    canvas.drawLine(position, playerDirection.toOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
