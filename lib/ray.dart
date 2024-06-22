import 'package:flutter/material.dart';

class Ray {
  Ray({required this.start, required this.end});

  final Offset start;
  final Offset end;

  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 0.1;

    canvas.drawLine(start, end, paint);
  }
}
