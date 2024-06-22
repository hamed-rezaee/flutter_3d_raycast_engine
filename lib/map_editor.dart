import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/constants.dart';
import 'package:flutter_3d_raycast_engine/enums.dart';

const Size size = Size(editorScale * mapSize, editorScale * mapSize);

class MapEditor extends StatefulWidget {
  const MapEditor({super.key});

  @override
  State<MapEditor> createState() => _MapEditorState();
}

class _MapEditorState extends State<MapEditor> {
  int selectedMaterial = 1;

  @override
  Widget build(BuildContext context) => Listener(
        onPointerMove: _onPointerMoveHandler,
        onPointerDown: _onPointerDownHandler,
        child: Row(
          children: [
            CustomPaint(painter: MapEditorPainter(), size: size),
            const SizedBox(width: margin),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final material in MaterialInformation.values)
                  _materialPicker(
                    material: material,
                    onTap: () =>
                        setState(() => selectedMaterial = material.index),
                  ),
              ],
            ),
          ],
        ),
      );

  void _onPointerMoveHandler(PointerEvent event) {
    final row = (event.localPosition.dy / editorScale).floor();
    final column = (event.localPosition.dx / editorScale).floor();

    if (row >= 0 && row < mapSize && column >= 0 && column < mapSize) {
      map[row * mapSize + column] = event.buttons == 1 ? selectedMaterial : 0;

      setState(() {});
    }
  }

  void _onPointerDownHandler(PointerDownEvent event) {
    final row = (event.localPosition.dy / editorScale).floor();
    final column = (event.localPosition.dx / editorScale).floor();

    if (row >= 0 && row < mapSize && column >= 0 && column < mapSize) {
      map[row * mapSize + column] = event.buttons == 1 ? selectedMaterial : 0;

      setState(() {});
    }
  }

  Widget _materialPicker({
    required MaterialInformation material,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: material.color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: selectedMaterial == material.index
                      ? Colors.black
                      : Colors.transparent,
                ),
              ),
            ),
            const SizedBox(width: margin),
            Text(
              material.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedMaterial == material.index
                    ? Colors.green
                    : Colors.black,
              ),
            ),
          ],
        ),
      );
}

class MapEditorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawMap(canvas);
  }

  void _drawMap(Canvas canvas) {
    for (var row = 0; row < mapSize; row++) {
      for (var column = 0; column < mapSize; column++) {
        canvas
          ..drawRect(
            Rect.fromLTWH(
              column * editorScale,
              row * editorScale,
              editorScale,
              editorScale,
            ),
            Paint()
              ..color =
                  MaterialInformation.values[map[row * mapSize + column]].color,
          )
          ..drawRect(
            Rect.fromLTWH(
              column * editorScale,
              row * editorScale,
              editorScale,
              editorScale,
            ),
            Paint()
              ..color = Colors.black
              ..strokeWidth = 0.1
              ..style = PaintingStyle.stroke,
          );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
