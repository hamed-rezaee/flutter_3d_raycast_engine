import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';

class MiniMapRenderer extends CustomPainter {
  const MiniMapRenderer(this.map);

  final List<List<int>> map;

  @override
  void paint(Canvas canvas, Size size) {
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
