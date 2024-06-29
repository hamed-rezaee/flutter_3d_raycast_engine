import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';
import 'package:flutter_3d_raycast_engine/player.dart';
import 'package:flutter_3d_raycast_engine/vector.dart';

class Sprite {
  const Sprite({
    required this.spriteIndex,
    required this.position,
    required this.player,
  });

  final int spriteIndex;
  final Vector position;
  final Player player;

  void draw(Canvas canvas) {
    final sprite = sprites[spriteIndex].image;

    if (sprite == null) {
      return;
    }

    final spriteX = (spertePositions[0].x + 0.5) * mapScale;
    final spriteY = (spertePositions[0].y + 0.5) * mapScale;

    final dx = spriteX - player.position.x;
    final dy = spriteY - player.position.y;
    final spriteDistance = sqrt(dx * dx + dy * dy);
    final spriteAngle = atan2(dy, dx) - player.angle;
    final size = viewDistance / spriteDistance;

    final sourceRect = Rect.fromLTWH(
      0,
      0,
      sprite.width.toDouble(),
      sprite.height.toDouble(),
    );

    final destinationRect = Rect.fromLTWH(
      width / 2 - spriteAngle * width / fov,
      height / 2,
      size,
      size,
    );

    canvas.drawImageRect(sprite, sourceRect, destinationRect, Paint());
  }
}
