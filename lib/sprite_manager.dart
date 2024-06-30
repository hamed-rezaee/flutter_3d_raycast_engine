import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';
import 'package:flutter_3d_raycast_engine/map_information.dart';
import 'package:flutter_3d_raycast_engine/player.dart';
import 'package:flutter_3d_raycast_engine/vector.dart';

class SpriteManager {
  void draw(Canvas canvas, Player player, List<MapInformation> map) =>
      _prepareSprites(player, map)
          .forEach((sprite) => sprite.drawSprites(canvas));

  List<Sprite> _prepareSprites(Player player, List<MapInformation> map) {
    final sprites = <Sprite>[];

    for (var i = 0; i < map.length; i++) {
      if (map[i].spriteIndex != 0) {
        sprites.add(
          Sprite(
            spriteIndex: map[i].spriteIndex,
            position: Vector(
              x: (i % mapSize + 0.5) * mapScale,
              y: (i ~/ mapSize + 0.5) * mapScale,
            ),
            player: player,
            map: map,
          ),
        );
      }
    }

    return _sortSprites(sprites, player);
  }

  List<Sprite> _sortSprites(List<Sprite> sprites, Player player) {
    sprites.sort(
      (a, b) => (b.position - player.position).magnitude >
              (a.position - player.position).magnitude
          ? 1
          : -1,
    );

    return sprites;
  }
}

class Sprite {
  const Sprite({
    required this.spriteIndex,
    required this.position,
    required this.player,
    required this.map,
  });

  final int spriteIndex;
  final Vector position;
  final Player player;
  final List<MapInformation> map;

  void drawSprites(Canvas canvas) {
    final image = sprites[spriteIndex].image;

    if (image == null) return;

    final dx = position.x - player.position.x;
    final dy = position.y - player.position.y;
    final spriteDistance = sqrt(dx * dx + dy * dy);
    final spriteAngle = atan2(dy, dx) - player.angle;
    final size = viewDistance / spriteDistance;

    final sourceRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final destinationRect = Rect.fromLTWH(
      width / 2 - spriteAngle * width / fov,
      height / 2,
      size,
      size,
    );

    canvas.drawImageRect(image, sourceRect, destinationRect, Paint());
  }
}
