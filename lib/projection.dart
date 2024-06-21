import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';
import 'package:flutter_3d_raycast_engine/helpers.dart';

class Projection {
  const Projection({
    required this.depth,
    required this.wallHeight,
    required this.isVertical,
  });

  final double depth;
  final double wallHeight;
  final bool isVertical;

  void draw(Canvas canvas, double offset) {
    final maxDepth = mapScale * mapSize + epsilon;

    final paint = Paint()
      ..color = isVertical
          ? getColorBasedOnDepth(
              color: Colors.grey[200]!,
              depth: depth,
              maxDepth: maxDepth,
            )
          : getColorBasedOnDepth(
              color: Colors.grey[600]!,
              depth: depth,
              maxDepth: maxDepth,
            );

    canvas.drawRect(
      Rect.fromLTWH(offset, (height - wallHeight) / 2, 1, wallHeight),
      paint,
    );
  }
}
