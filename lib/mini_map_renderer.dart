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

    player.castRay().rays.forEach((ray) => ray.draw(canvas));
    player.draw(canvas);
  }

  void _drawMap(Canvas canvas) {
    canvas.drawRect(
      const Rect.fromLTWH(
        -margin,
        -margin,
        mapSize * mapScale + margin * 2,
        mapSize * mapScale + margin * 2,
      ),
      Paint()..color = Colors.white,
    );

    final size = map.length ~/ mapSize;

    for (var row = 0; row < size; row++) {
      for (var column = 0; column < size; column++) {
        canvas.drawRect(
          Rect.fromLTWH(column * mapScale, row * mapScale, mapScale, mapScale),
          Paint()..color = assets[map[row * mapSize + column]].color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
