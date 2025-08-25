import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';
import 'package:flutter_3d_raycast_engine/player.dart';
import 'package:flutter_3d_raycast_engine/sprite_manager.dart';

class Renderer extends CustomPainter {
  const Renderer({
    required this.player,
    required this.spriteManager,
    required this.enableTexture,
  });

  final Player player;
  final SpriteManager spriteManager;
  final bool enableTexture;

  @override
  void paint(Canvas canvas, Size size) {
    _drawSky(canvas, size);
    _drawGround(canvas, size);
    _drawWalls(canvas);
    spriteManager.draw(canvas, player, map);
    _drawPistol(canvas);
  }

  void _drawSky(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height / 2),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.black.withValues(alpha: 0.7)],
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
              const Color.fromARGB(255, 39, 13, 3).withValues(alpha: 0.8),
            ],
          ).createShader(
            Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2),
          ),
      );

  void _drawWalls(Canvas canvas) {
    final projections = player.castRayWall().projections;

    for (var i = 0; i < projections.length; i++) {
      projections[i].draw(
        canvas,
        projections.length - i - 1,
        enableTexture: enableTexture,
      );
    }
  }

  void _drawPistol(Canvas canvas) {
    final pistolSprite = sprites[1].image!;

    final sourceRect = Rect.fromLTWH(
      0,
      0,
      pistolSprite.width.toDouble(),
      pistolSprite.height.toDouble(),
    );
    final destinationRect = Rect.fromLTWH(
      screenSize.width / 2 - pistolSprite.width / 2,
      screenSize.height - pistolSprite.height * 2,
      pistolSprite.width * 2,
      pistolSprite.height * 2,
    );
    canvas.drawImageRect(
      pistolSprite,
      sourceRect,
      destinationRect,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
