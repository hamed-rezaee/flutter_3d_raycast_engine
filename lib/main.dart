import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';
import 'package:flutter_3d_raycast_engine/controller.dart';
import 'package:flutter_3d_raycast_engine/map_editor.dart';
import 'package:flutter_3d_raycast_engine/mini_map_renderer.dart';
import 'package:flutter_3d_raycast_engine/player.dart';
import 'package:flutter_3d_raycast_engine/renderer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomPaint(
                      painter: Renderer(player: player),
                      size: screenSize,
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
      );

  void _gameLoop() {
    player.update();

    setState(() {});
  }
}
