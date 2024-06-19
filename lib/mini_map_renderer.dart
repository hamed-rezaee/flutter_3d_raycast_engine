import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';

class MiniMapRenderer extends CustomPainter {
  const MiniMapRenderer({
    required this.playerPosition,
    required this.playerAngle,
    required this.map,
  });

  final Offset playerPosition;
  final double playerAngle;
  final List<List<int>> map;

  @override
  void paint(Canvas canvas, Size size) {
    _drawMap(canvas);
    _drawPlayer(canvas);
  }

  void _drawMap(Canvas canvas) {
    for (int row = 0; row < map.length; row++) {
      for (int column = 0; column < map[row].length; column++) {
        canvas.drawRect(
          Rect.fromLTWH(
            column * mapScale,
            row * mapScale,
            mapScale + 1,
            mapScale + 1,
          ),
          Paint()..color = (map[row][column] == 1 ? Colors.grey : Colors.white),
        );
      }
    }
  }

  void _drawPlayer(Canvas canvas) {
    final Paint paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2;

    final playerX = playerPosition.dx;
    final playerY = playerPosition.dy;

    canvas.drawCircle(playerPosition, 5, paint);

    final playerDirection = Offset(
      playerX + 10 * cos(playerAngle),
      playerY + 10 * sin(playerAngle),
    );

    canvas.drawLine(playerPosition, playerDirection, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
