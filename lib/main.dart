import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';
import 'package:flutter_3d_raycast_engine/controller.dart';
import 'package:flutter_3d_raycast_engine/mini_map_renderer.dart';
import 'package:flutter_3d_raycast_engine/player.dart';
import 'package:flutter_3d_raycast_engine/renderer.dart';

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final Player player = Player(Controller());

  bool showMiniMap = true;

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

          if (event.logicalKey == LogicalKeyboardKey.keyQ &&
              event is KeyDownEvent) {
            showMiniMap = !showMiniMap;
          }
        },
        child: MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    CustomPaint(
                      painter: Renderer(player: player),
                      size: screenSize,
                    ),
                  ],
                ),
                if (showMiniMap)
                  Positioned(
                    top: mapOffset,
                    right: halfScreenSize.width - mapOffset,
                    child: CustomPaint(
                      painter: MiniMapRenderer(
                        player: player,
                        map: map,
                      ),
                      size: halfScreenSize,
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
