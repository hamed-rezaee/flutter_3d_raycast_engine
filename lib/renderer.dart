import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';
import 'package:flutter_3d_raycast_engine/player.dart';
import 'package:flutter_3d_raycast_engine/sprite_manager.dart';
import 'package:flutter_3d_raycast_engine/vector.dart';

class Renderer extends CustomPainter {
  const Renderer({
    required this.player,
    required this.spriteManager,
    required this.enableTexture,
    required this.playerPosition,
    required this.playerAngle,
    this.skyboxImage,
    this.groundImage,
  });

  final Player player;
  final SpriteManager spriteManager;
  final bool enableTexture;
  final ui.Image? skyboxImage;
  final ui.Image? groundImage;
  final Vector playerPosition;
  final double playerAngle;

  @override
  void paint(Canvas canvas, Size size) {
    _drawSky(canvas, size);
    _drawGround(canvas, size);
    _drawWalls(canvas);
    spriteManager.draw(canvas, player, map);
    _drawPistol(canvas);
  }

  void _drawSky(Canvas canvas, Size size) {
    if (skyboxImage != null) {
      final skyWidth = skyboxImage!.width.toDouble();
      final skyHeight = skyboxImage!.height.toDouble();
      final offsetX = (skyWidth -
              ((playerAngle / (2 * 3.141592653589793)) * skyWidth) % skyWidth) %
          skyWidth;
      final firstWidth = skyWidth - offsetX;
      final firstDstWidth = size.width * (firstWidth / skyWidth);
      final src = Rect.fromLTWH(offsetX, 0, firstWidth, skyHeight);

      canvas.drawImageRect(
        skyboxImage!,
        src,
        Rect.fromLTWH(0, 0, firstDstWidth, size.height / 2),
        Paint(),
      );

      if (offsetX > 0.0) {
        final src2 = Rect.fromLTWH(0, 0, offsetX, skyHeight);
        canvas.drawImageRect(
          skyboxImage!,
          src2,
          Rect.fromLTWH(
              firstDstWidth, 0, size.width - firstDstWidth, size.height / 2),
          Paint(),
        );
      }
    } else {
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
  }

  void _drawGround(Canvas canvas, Size size) {
    if (groundImage != null) {
      final groundWidth = groundImage!.width.toDouble();
      final groundHeight = groundImage!.height.toDouble();
      final px = playerPosition.x;
      final py = playerPosition.y;
      final pa = playerAngle;
      final cosA = math.cos(pa);
      final sinA = math.sin(pa);
      final screenW = size.width.toInt();
      final screenH = size.height.toInt();
      final horizon = (screenH / 2).toInt();
      final image = groundImage!;
      const step = 4;
      const scale = 0.7;

      for (var y = horizon + 1; y < screenH; y += step) {
        final screenY = y - horizon;
        final denom = (2.0 * screenY).abs() < 1e-5 ? 1e-5 : 2.0 * screenY;
        final perspective = scale * textureScale * screenH / denom;

        for (var x = 0; x < screenW; x += step) {
          final screenX = x - screenW / 2;
          final worldX = px +
              (cosA * perspective) +
              (sinA * perspective * screenX / (screenW / 2));
          final worldY = py +
              (sinA * perspective) -
              (cosA * perspective * screenX / (screenW / 2));

          var texX = (worldX / textureScale).floor() % groundWidth.toInt();
          var texY = (worldY / textureScale).floor() % groundHeight.toInt();

          if (texX < 0) texX += groundWidth.toInt();
          if (texY < 0) texY += groundHeight.toInt();

          canvas.drawImageRect(
            image,
            Rect.fromLTWH(texX.toDouble(), texY.toDouble(), 1, 1),
            Rect.fromLTWH(
                x.toDouble(), y.toDouble(), step.toDouble(), step.toDouble()),
            Paint(),
          );
        }
      }
    } else {
      canvas.drawRect(
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
    }
  }

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
