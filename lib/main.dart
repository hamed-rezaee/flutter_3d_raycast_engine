import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_raycast_engine/asset.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';
import 'package:flutter_3d_raycast_engine/controller.dart';
import 'package:flutter_3d_raycast_engine/helpers.dart';
import 'package:flutter_3d_raycast_engine/map_editor.dart';
import 'package:flutter_3d_raycast_engine/mini_map_renderer.dart';
import 'package:flutter_3d_raycast_engine/player.dart';
import 'package:flutter_3d_raycast_engine/renderer.dart';
import 'package:flutter_3d_raycast_engine/sprite_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  skybox = await Asset.loadSkyboxTexture();
  ground = await Asset.loadGroundTexture();

  sprites.addAll(await Asset.loadSprites());
  materials.addAll(await Asset.loadMaterials());
  map.addAll(await loadMap());

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Player player = Player(Controller());
  final SpriteManager spriteManager = SpriteManager();

  bool showMiniMap = true;
  bool enableTexture = true;

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
        },
        child: MaterialApp(
          theme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(margin),
                        child: ClipRect(
                          child: CustomPaint(
                            painter: Renderer(
                              player: player,
                              spriteManager: spriteManager,
                              enableTexture: enableTexture,
                              skyboxImage: skybox,
                              groundImage: ground,
                              playerPosition: player.position,
                              playerAngle: player.angle,
                            ),
                            size: screenSize,
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
                        padding: const EdgeInsets.all(margin * 4),
                        child: CustomPaint(
                          painter: MiniMapRenderer(player: player, map: map),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );

  void _gameLoop() {
    player.update();

    setState(() {});
  }
}
