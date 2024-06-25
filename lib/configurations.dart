import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_3d_raycast_engine/asset.dart';
import 'package:flutter_3d_raycast_engine/map_information.dart';
import 'package:flutter_3d_raycast_engine/vector.dart';

const double width = 700;
const double height = 500;
const double margin = 8;

const Size screenSize = Size(width, height);
const Size halfScreenSize = Size(width / 2, height / 2);

const double fps = 60;
const int cycleDelay = 1000 ~/ fps;

const double fov = pi / 3;
const double halfFov = fov / 2;
const double rayStep = fov / width;
const double wallHeightMultiplier = 800;

const int mapSize = 32;
const double mapScale = 4;
const double mapRange = mapScale * mapSize;
const double editorScale = 8;

const double playerSpeed = 0.4;
const double playerRotationSpeed = 0.03;
const double playerRadius = mapScale / 4;

const double textureScale = 64;

const double epsilon = 0.0001;
const double infinity = 10000;

final List<MapInformation> map = [];

final Vector playerPosition = Vector(x: mapSize / 2, y: mapSize / 2);

final List<Asset> materials = [];
final List<Asset> sprites = [];
