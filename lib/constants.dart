import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/enums.dart';

const double width = 960;
const double height = 540;
const double margin = 8;

const Size screenSize = Size(width, height);
const Size halfScreenSize = Size(width / 2, height / 2);

const double fps = 60;
const int cycleDelay = 1000 ~/ fps;

const double fov = 1;
const double halfFov = fov / 2;
const double rayStep = fov / width;
const double wallHeightMultiplier = 800;

const int mapSize = 32;
const double mapScale = 5;
const double mapRange = mapScale * mapSize;
const double editorScale = 10;

const double playerSpeed = 0.4;
const double playerRotationSpeed = 0.02;

const double epsilon = 0.0001;

final List<int> map = List.generate(
  mapSize * mapSize,
  (index) => index % mapSize == 0 ||
          index % mapSize == mapSize - 1 ||
          index < mapSize ||
          index >= mapSize * (mapSize - 1)
      ? MaterialInformation.stoneWall.index
      : MaterialInformation.empty.index,
);

Offset playerPosition = const Offset(mapSize / 2, mapSize / 2);
