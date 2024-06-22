import 'package:flutter/material.dart';

enum MaterialInformation {
  empty('Empty', Colors.transparent),
  stoneWall('Stone Wall', Colors.grey),
  woodWall('Wood Wall', Colors.brown),
  brickWall('Brick Wall', Colors.red),
  pictureWall('Picture Wall', Colors.pink),
  door('Door', Colors.indigo),
  window('Window', Colors.purple),
  sky('Sky', Colors.blue),
  ground('Ground', Colors.green);

  const MaterialInformation(this.name, this.color);

  final String name;
  final Color color;

  static Color getColorByValue(int value) => MaterialInformation.values
      .firstWhere(
        (element) => element.index == value,
        orElse: () => MaterialInformation.stoneWall,
      )
      .color;
}
