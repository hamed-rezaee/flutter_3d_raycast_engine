import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/vector.dart';

class Ray {
  Ray({required this.start, required this.end});

  final Vector start;
  final Vector end;

  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 0.1;

    canvas.drawLine(start.toOffset, end.toOffset, paint);
  }
}
