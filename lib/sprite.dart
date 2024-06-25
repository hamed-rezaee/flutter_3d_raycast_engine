import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';

class Sprite {
  const Sprite({
    required this.spriteIndex,
    required this.depth,
    required this.wallHeight,
    required this.textureOffset,
  });

  final int spriteIndex;
  final double depth;
  final double wallHeight;
  final double textureOffset;

  void draw(
    Canvas canvas,
    double offset, {
    required bool enableTexture,
  }) {
    if (sprites[spriteIndex].image == null) {
      return;
    }

    final sourceRect =
        Rect.fromLTWH(textureOffset % textureScale, 0, 1, textureScale);
    final destinationRect =
        Rect.fromLTWH(offset, (height - wallHeight) / 2, 1, wallHeight);

    canvas.drawImageRect(
      sprites[spriteIndex].image!,
      sourceRect,
      destinationRect,
      Paint(),
    );
  }
}
