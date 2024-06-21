import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/player.dart';

class Renderer extends CustomPainter {
  const Renderer({required this.player});

  final Player player;

  @override
  void paint(Canvas canvas, Size size) {
    _drawSky(canvas, size);
    _drawGround(canvas, size);
    _drawWalls(canvas);
  }

  void _drawSky(Canvas canvas, Size size) => canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height / 2),
        Paint()..color = Colors.black,
      );

  void _drawGround(Canvas canvas, Size size) => canvas.drawRect(
        Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2),
        Paint()..color = Colors.green,
      );

  void _drawWalls(Canvas canvas) {
    final projections = player.castRay().projections;

    for (var i = 0; i < projections.length; i++) {
      projections[i].draw(canvas, projections.length - i - 1);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
