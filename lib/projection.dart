import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';
import 'package:flutter_3d_raycast_engine/helpers.dart';

class Projection {
  const Projection({
    required this.textureIndex,
    required this.depth,
    required this.wallHeight,
    required this.textureOffset,
    required this.isVertical,
  });

  final int textureIndex;
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

    if (enableTexture) {
      final shadingIntensity = (1 - depth / maxDepth).clamp(0.0, 1.0);
      final shadeValue = (255 * shadingIntensity).toInt();
      final shadedColor =
          Color.fromARGB(255, shadeValue, shadeValue, shadeValue);

      final sourceRect =
          Rect.fromLTWH(textureOffset % textureScale, 0, 1, textureScale);
      final destinationRect =
          Rect.fromLTWH(offset, (height - wallHeight) / 2, 1, wallHeight);

      canvas.drawImageRect(
        assets[textureIndex].image!,
        sourceRect,
        destinationRect,
        Paint()
          ..colorFilter = ColorFilter.mode(shadedColor, BlendMode.modulate),
      );
    } else {
      canvas.drawRect(
        Rect.fromLTWH(offset, (height - wallHeight) / 2, 1, wallHeight),
        Paint()
          ..color = getColorBasedOnDepth(
            color: assets[textureIndex].color,
            depth: depth,
            maxDepth: maxDepth,
          ),
      );
    }
  }
}
