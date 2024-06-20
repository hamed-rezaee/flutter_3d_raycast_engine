import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';
import 'package:flutter_3d_raycast_engine/player.dart';

class MiniMapRenderer extends CustomPainter {
  const MiniMapRenderer({
    required this.player,
    required this.map,
  });

  final Player player;
  final List<int> map;

  @override
  void paint(Canvas canvas, Size size) {
    _drawMap(canvas);
    player.drawRays(canvas, player.castRay());
    player.draw(canvas);
  }

  void _drawMap(Canvas canvas) {
    final int size = map.length ~/ mapSize;

    for (int row = 0; row < size; row++) {
      for (int column = 0; column < size; column++) {
        canvas.drawRect(
          Rect.fromLTWH(
            column * mapScale,
            row * mapScale,
            mapScale + 1,
            mapScale + 1,
          ),
          Paint()
            ..color =
                (map[row * mapSize + column] == 1) ? Colors.grey : Colors.white,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
