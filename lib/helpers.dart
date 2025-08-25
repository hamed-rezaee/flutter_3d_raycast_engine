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
  final invMaxDepth = 1.0 / (maxDepth + epsilon);
  final ratio = (1 - depth * invMaxDepth) + adjustment;

  var red = ((color.r * 255.0) * ratio).round();
  var green = ((color.g * 255.0) * ratio).round();
  var blue = ((color.b * 255.0) * ratio).round();

  red = red.clamp(0, 255);
  green = green.clamp(0, 255);
  blue = blue.clamp(0, 255);

  return Color.fromARGB(255, red, green, blue);
}

final Map<String, Future<ui.Image>> _imageCache = {};
Future<ui.Image> loadImageFromAsset(String assetName) async {
  if (_imageCache.containsKey(assetName)) {
    return _imageCache[assetName]!;
  }

  final completer = Completer<ui.Image>();

  _imageCache[assetName] = completer.future;

  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    final image = AssetImage(assetName);
    final key = await image.obtainKey(ImageConfiguration.empty);

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
  } else {
    final buffer = await ui.ImmutableBuffer.fromAsset(assetName);
    final codec = await ui.instantiateImageCodecWithSize(buffer);
    final frame = await codec.getNextFrame();
    completer.complete(frame.image);
  }

  return completer.future;
}

List<MapInformation>? _cachedMap;
List<MapInformation> generateMap() {
  if (_cachedMap != null) return List<MapInformation>.from(_cachedMap!);
  _cachedMap = List.generate(
    mapSize * mapSize,
    (index) => index % mapSize == 0 ||
            index % mapSize == mapSize - 1 ||
            index < mapSize ||
            index >= mapSize * (mapSize - 1)
        ? MapInformation(materialIndex: materials.last.index)
        : MapInformation(),
  );

  return List<MapInformation>.from(_cachedMap!);
}

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<void> saveMap(List<MapInformation> map) async {
  final prefs = await _prefs;
  final materialList =
      List<String>.generate(map.length, (i) => map[i].materialIndex.toString());
  final spriteList =
      List<String>.generate(map.length, (i) => map[i].spriteIndex.toString());

  await prefs.setStringList('map_material', materialList);
  await prefs.setStringList('map_sprite', spriteList);
}

Future<List<MapInformation>> loadMap() async {
  final prefs = await _prefs;
  final materialList = prefs.getStringList('map_material');
  final spriteList = prefs.getStringList('map_sprite');
  final emptyMap = generateMap();

  if (materialList == null || spriteList == null) {
    return emptyMap;
  }

  final len = emptyMap.length;

  if (materialList.length != len || spriteList.length != len) {
    return emptyMap;
  }

  return List.generate(
    len,
    (index) => MapInformation(
      materialIndex: int.parse(materialList[index]),
      spriteIndex: int.parse(spriteList[index]),
    ),
  );
}
