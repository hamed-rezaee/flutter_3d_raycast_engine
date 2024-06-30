import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/helpers.dart';

class Asset {
  Asset({
    required this.index,
    required this.name,
    required this.color,
    required this.image,
    this.showInEditor = true,
  });

  final int index;
  final String name;
  final Color color;
  final ui.Image? image;
  final bool showInEditor;

  static Future<List<Asset>> loadSprites() async => <Asset>[
        Asset(
          index: 0,
          name: 'Empty',
          color: Colors.transparent,
          image: null,
          showInEditor: false,
        ),
        Asset(
          index: 1,
          name: 'Player',
          color: Colors.brown,
          image: await loadImageFromAsset('assets/sprites/player.png'),
          showInEditor: false,
        ),
        Asset(
          index: 2,
          name: 'Steven',
          color: Colors.blue,
          image: await loadImageFromAsset('assets/sprites/steven.png'),
        ),
      ];

  static Future<List<Asset>> loadMaterials() async => <Asset>[
        Asset(
          index: 0,
          name: 'Empty',
          color: Colors.transparent,
          image: null,
          showInEditor: false,
        ),
        Asset(
          index: 1,
          name: 'Blue Wall',
          color: Colors.blue,
          image: await loadImageFromAsset('assets/textures/blue_wall.png'),
        ),
        Asset(
          index: 2,
          name: 'Brick Wall',
          color: Colors.orange,
          image: await loadImageFromAsset('assets/textures/brick_wall.png'),
        ),
        Asset(
          index: 3,
          name: 'Closed Door',
          color: Colors.black,
          image: await loadImageFromAsset('assets/textures/closed_door.png'),
        ),
        Asset(
          index: 4,
          name: 'Dart Wall',
          color: Colors.indigo,
          image: await loadImageFromAsset('assets/textures/dart_wall.png'),
        ),
        Asset(
          index: 5,
          name: 'Elevator',
          color: Colors.purple,
          image: await loadImageFromAsset('assets/textures/elevator.png'),
        ),
        Asset(
          index: 6,
          name: 'Flutter Wall',
          color: Colors.blue,
          image: await loadImageFromAsset('assets/textures/flutter_wall.png'),
        ),
        Asset(
          index: 7,
          name: 'Iron Door',
          color: Colors.blueGrey,
          image: await loadImageFromAsset('assets/textures/iron_door.png'),
        ),
        Asset(
          index: 8,
          name: 'Open Door',
          color: Colors.green,
          image: await loadImageFromAsset('assets/textures/open_door.png'),
        ),
        Asset(
          index: 9,
          name: 'Stone Wall',
          color: Colors.grey,
          image: await loadImageFromAsset('assets/textures/stone_wall.png'),
        ),
      ];
}
