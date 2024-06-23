import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color getColorBasedOnDepth({
  required Color color,
  required double depth,
  required double maxDepth,
  double adjustment = 0.1,
}) {
  final ratio = (1 - depth / (maxDepth + epsilon)) + adjustment;

  var red = (color.red * ratio).toInt();
  var green = (color.green * ratio).toInt();
  var blue = (color.blue * ratio).toInt();

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
    image
        .loadBuffer(
          key,
          // ignore: deprecated_member_use
          PaintingBinding.instance.instantiateImageCodecFromBuffer,
        )
        .addListener(
          ImageStreamListener(
            (image, synchronousCall) => completer.complete(image.image),
          ),
        );

    return completer.future;
  }

  final buffer = await ui.ImmutableBuffer.fromAsset(assetName);
  final codec = await ui.instantiateImageCodecFromBuffer(buffer);
  final frame = await codec.getNextFrame();

  return frame.image;
}

List<int> generateMap() => List.generate(
      mapSize * mapSize,
      (index) => index % mapSize == 0 ||
              index % mapSize == mapSize - 1 ||
              index < mapSize ||
              index >= mapSize * (mapSize - 1)
          ? assets.last.index
          : assets.first.index,
    );

Future<void> saveMap(List<int> map) async =>
    (await SharedPreferences.getInstance())
        .setStringList('map', map.map((e) => e.toString()).toList());

Future<List<int>> loadMap() async {
  final map = (await SharedPreferences.getInstance()).getStringList('map');

  return map?.map(int.parse).toList() ?? generateMap();
}
