import 'package:flutter/material.dart';

class Vector {
  Vector({this.x = 0, this.y = 0});

  double x;
  double y;

  Offset get toOffset => Offset(x, y);

  double get magnitude => x * x + y * y;

  Vector operator +(Vector other) => Vector(x: x + other.x, y: y + other.y);

  Vector operator -(Vector other) => Vector(x: x - other.x, y: y - other.y);
}
