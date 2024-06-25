import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/player.dart';

class Renderer extends CustomPainter {
  const Renderer({required this.player, required this.enableTexture});

  final Player player;
  final bool enableTexture;

  @override
  void paint(Canvas canvas, Size size) {
    _drawSky(canvas, size);
    _drawGround(canvas, size);
    _drawWalls(canvas);
  }

  void _drawSky(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height / 2),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.black.withOpacity(0.7)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height / 2)),
    );
  }

  void _drawGround(Canvas canvas, Size size) => canvas.drawRect(
        Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 39, 13, 3),
              const Color.fromARGB(255, 39, 13, 3).withOpacity(0.8),
            ],
          ).createShader(
            Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2),
          ),
      );

  void _drawWalls(Canvas canvas) {
    final projections = player.castRay().projections;

    for (var i = 0; i < projections.length; i++) {
      projections[i].draw(
        canvas,
        projections.length - i - 1,
        enableTexture: enableTexture,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
