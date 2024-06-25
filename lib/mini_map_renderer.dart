import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';
import 'package:flutter_3d_raycast_engine/map_information.dart';
import 'package:flutter_3d_raycast_engine/player.dart';

class MiniMapRenderer extends CustomPainter {
  const MiniMapRenderer({
    required this.player,
    required this.map,
  });

  final Player player;
  final List<MapInformation> map;

  @override
  void paint(Canvas canvas, Size size) {
    _drawMap(canvas);

    player.drawInMiniMap(canvas);
    player.castRay().rays.forEach((ray) => ray.draw(canvas));
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
      Paint()..color = Colors.black.withOpacity(0.5),
    );

    final size = map.length ~/ mapSize;

    for (var row = 0; row < size; row++) {
      for (var column = 0; column < size; column++) {
        canvas.drawRect(
          Rect.fromLTWH(column * mapScale, row * mapScale, mapScale, mapScale),
          Paint()
            ..color =
                materials[map[row * mapSize + column].materialIndex].color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
