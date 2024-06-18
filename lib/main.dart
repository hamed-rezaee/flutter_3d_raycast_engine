import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';
import 'package:flutter_3d_raycast_engine/renderer.dart';

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Timer? _timer;

  int oldCycleTime = 0;
  int cycleCount = 0;
  String fpsRate = 'Calculating...';

  @override
  void initState() {
    super.initState();

    _timer =
        Timer.periodic(const Duration(milliseconds: cycleDelay), _gameLoop);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('3D Raycast Engine ($fpsRate)')),
          body: const Center(
            child: CustomPaint(
              painter: Renderer(),
              size: screenSize,
            ),
          ),
        ),
      );

  void _gameLoop(Timer timer) {
    _calculateFPS();
  }

  void _calculateFPS() {
    cycleCount++;

    if (cycleCount >= fps) {
      cycleCount = 0;
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final timeDifference = currentTime - oldCycleTime;

    oldCycleTime = currentTime;

    if (currentTime % fps == 0) {
      fpsRate = '${(1000 / timeDifference).toStringAsFixed(2)} FPS';
    }

    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: cycleDelay), _calculateFPS);

    setState(() {});
  }
}
