import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_raycast_engine/asset.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';
import 'package:flutter_3d_raycast_engine/controller.dart';
import 'package:flutter_3d_raycast_engine/helpers.dart';
import 'package:flutter_3d_raycast_engine/map_editor.dart';
import 'package:flutter_3d_raycast_engine/mini_map_renderer.dart';
import 'package:flutter_3d_raycast_engine/player.dart';
import 'package:flutter_3d_raycast_engine/renderer.dart';
import 'package:statsfl/statsfl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  playerSprite = await loadImageFromAsset('assets/textures/pistol.png');
  map.addAll(await loadMap());
  assets.addAll(await Asset.loadAssets());

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Player player = Player(Controller());

  bool showMiniMap = true;
  bool enableTexture = true;
  bool showStats = true;

  @override
  void initState() {
    super.initState();

    Timer.periodic(
      const Duration(milliseconds: cycleDelay),
      (_) => _gameLoop(),
    );
  }

  @override
  Widget build(BuildContext context) => KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          player.handleKeyEvent(event);

          if (event.logicalKey == LogicalKeyboardKey.digit1 &&
              event is KeyDownEvent) {
            showMiniMap = !showMiniMap;
          }

          if (event.logicalKey == LogicalKeyboardKey.digit2 &&
              event is KeyDownEvent) {
            enableTexture = !enableTexture;
          }

          if (event.logicalKey == LogicalKeyboardKey.digit3 &&
              event is KeyDownEvent) {
            showStats = !showStats;
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(margin),
                      child: StatsFl(
                        isEnabled: showStats,
                        align: Alignment.topRight,
                        child: ClipRect(
                          child: CustomPaint(
                            painter: Renderer(
                              player: player,
                              enableTexture: enableTexture,
                            ),
                            size: screenSize,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(margin),
                      child: MapEditor(),
                    ),
                  ],
                ),
                if (showMiniMap)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(margin * 2),
                      child: CustomPaint(
                        painter: MiniMapRenderer(player: player, map: map),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  void _gameLoop() {
    player.update();

    setState(() {});
  }
}
