import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_3d_raycast_engine/asset.dart';

const double width = 700;
const double height = 500;
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
const double mapScale = 4;
const double mapRange = mapScale * mapSize;
const double editorScale = 8;

const double playerSpeed = 0.4;
const double playerRotationSpeed = 0.02;
const double playerRadius = mapScale / 2;

const double textureScale = 64;

const double epsilon = 0.0001;
const double infinity = 10000;

final List<int> map = [];

const Offset playerPosition = Offset(mapSize / 2, mapSize / 2);

final List<Asset> assets = [];
