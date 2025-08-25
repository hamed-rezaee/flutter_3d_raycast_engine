import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';
import 'package:flutter_3d_raycast_engine/map_information.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color getColorBasedOnDepth({
  required Color color,
  required double depth,
  required double maxDepth,
  double adjustment = 0.1,
}) {
  final ratio = (1 - depth / (maxDepth + epsilon)) + adjustment;

  var red = ((color.r * 255.0) * ratio).round();
  var green = ((color.g * 255.0) * ratio).round();
  var blue = ((color.b * 255.0) * ratio).round();

  red = red.clamp(0, 255);
  green = green.clamp(0, 255);
  blue = blue.clamp(0, 255);

  return Color.fromARGB(255, red, green, blue);
}

Future<ui.Image> loadImageFromAsset(String assetName) async {
  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();

    final image = AssetImage(assetName);
    final key = await image.obtainKey(ImageConfiguration.empty);

    final completer = Completer<ui.Image>();
    image.loadBuffer(
      key,
      (buffer,
          {int? cacheWidth, int? cacheHeight, bool allowUpscaling = false}) {
        return PaintingBinding.instance.instantiateImageCodecWithSize(buffer);
      },
    ).addListener(
      ImageStreamListener(
        (image, synchronousCall) => completer.complete(image.image),
      ),
    );

    return completer.future;
  }

  final buffer = await ui.ImmutableBuffer.fromAsset(assetName);
  final codec = await ui.instantiateImageCodecWithSize(buffer);
  final frame = await codec.getNextFrame();

  return frame.image;
}

List<MapInformation> generateMap() => List.generate(
      mapSize * mapSize,
      (index) => index % mapSize == 0 ||
              index % mapSize == mapSize - 1 ||
              index < mapSize ||
              index >= mapSize * (mapSize - 1)
          ? MapInformation(materialIndex: materials.last.index)
          : MapInformation(),
    );

Future<void> saveMap(List<MapInformation> map) async {
  await (await SharedPreferences.getInstance()).setStringList(
    'map_material',
    map.map((e) => e.materialIndex.toString()).toList(),
  );

  await (await SharedPreferences.getInstance()).setStringList(
    'map_sprite',
    map.map((e) => e.spriteIndex.toString()).toList(),
  );
}

Future<List<MapInformation>> loadMap() async {
  final map =
      (await SharedPreferences.getInstance()).getStringList('map_material');
  final sprite =
      (await SharedPreferences.getInstance()).getStringList('map_sprite');

  final emptyMap = generateMap();

  if (map == null || sprite == null) {
    return emptyMap;
  } else {
    return List.generate(
      emptyMap.length,
      (index) => MapInformation(
        materialIndex: int.parse(map[index]),
        spriteIndex: int.parse(sprite[index]),
      ),
    );
  }
}
