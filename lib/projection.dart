import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';
import 'package:flutter_3d_raycast_engine/helpers.dart';

class Projection {
  const Projection({
    required this.materialIndex,
    required this.depth,
    required this.wallHeight,
    required this.textureOffset,
    required this.isVertical,
  });

  final int materialIndex;
  final double depth;
  final double wallHeight;
  final double textureOffset;
  final bool isVertical;

  void draw(
    Canvas canvas,
    double offset, {
    required bool enableTexture,
  }) {
    const maxDepth = mapScale * mapSize + epsilon;

    final shadedColor = getColorBasedOnDepth(
      color: Colors.grey[isVertical ? 200 : 500]!,
      depth: depth,
      maxDepth: maxDepth,
    );

    final sourceRect =
        Rect.fromLTWH(textureOffset % textureScale, 0, 1, textureScale);
    final destinationRect =
        Rect.fromLTWH(offset, (height - wallHeight) / 2, 1, wallHeight);

    canvas.drawImageRect(
      materials[materialIndex].image!,
      sourceRect,
      destinationRect,
      Paint()
        ..colorFilter = ColorFilter.mode(
          shadedColor,
          enableTexture ? BlendMode.modulate : BlendMode.src,
        ),
    );
  }
}
