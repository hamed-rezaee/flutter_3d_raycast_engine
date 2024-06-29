import 'package:flutter/material.dart';
import 'package:flutter_3d_raycast_engine/asset.dart';
import 'package:flutter_3d_raycast_engine/configurations.dart';
import 'package:flutter_3d_raycast_engine/helpers.dart';

const Size size = Size(editorScale * mapSize, editorScale * mapSize);

class MapEditor extends StatefulWidget {
  const MapEditor({super.key});

  @override
  State<MapEditor> createState() => _MapEditorState();
}

class _MapEditorState extends State<MapEditor> {
  int? selectedMaterial = materials.last.index;
  int? selectedSprite;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildInformationSection(),
          _buildEditor(),
        ],
      );

  List<Widget> _buildInformationSection() => [
        const Text(
          'Help',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: margin),
        const Divider(),
        const SizedBox(height: margin),
        const Text(
          '\t- Press W, A, S, D, Q, E to move the player\n\t- Press 1 to toggle Minimap\n\t- Press 2 to toggle texture',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: margin),
        const Divider(),
        const SizedBox(height: margin),
        const Text(
          'Map Editor',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: margin),
        const Text(
          '\t- Select a material, left click to draw and right click to erase',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: margin),
      ];

  Widget _buildEditor() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Listener(
            onPointerMove: _onPointerMoveHandler,
            onPointerDown: _onPointerDownHandler,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomPaint(painter: MapEditorPainter(), size: size),
                    const SizedBox(width: margin * 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final material in materials)
                          _materialPicker(
                            material: material,
                            onTap: () {
                              selectedSprite = null;
                              selectedMaterial = material.index;

                              setState(() {});
                            },
                          ),
                      ],
                    ),
                    const SizedBox(width: margin * 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final sprite in sprites)
                          _spritePicker(
                            sprite: sprite,
                            onTap: () {
                              selectedMaterial = null;
                              selectedSprite = sprite.index;

                              setState(() {});
                            },
                          ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () => saveMap(map),
                    ),
                    IconButton(
                      onPressed: () async {
                        map
                          ..clear()
                          ..addAll(await loadMap());
                        setState(() {});
                      },
                      icon: const Icon(Icons.restore),
                    ),
                    IconButton(
                      onPressed: () {
                        map
                          ..clear()
                          ..addAll(generateMap());

                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  void _onPointerMoveHandler(PointerEvent event) {
    final row = (event.localPosition.dy / editorScale).floor();
    final column = (event.localPosition.dx / editorScale).floor();

    if (row >= 0 && row < mapSize && column >= 0 && column < mapSize) {
      if (selectedMaterial != null) {
        map[row * mapSize + column].materialIndex =
            event.buttons == 1 ? selectedMaterial! : 0;
      }

      if (selectedSprite != null) {
        map[row * mapSize + column].spriteIndex =
            event.buttons == 1 ? selectedSprite! : 0;
      }

      setState(() {});
    }
  }

  void _onPointerDownHandler(PointerDownEvent event) {
    final row = (event.localPosition.dy / editorScale).floor();
    final column = (event.localPosition.dx / editorScale).floor();

    if (row >= 0 && row < mapSize && column >= 0 && column < mapSize) {
      if (selectedMaterial != null) {
        map[row * mapSize + column].materialIndex =
            event.buttons == 1 ? selectedMaterial! : 0;
      }

      if (selectedSprite != null) {
        map[row * mapSize + column].spriteIndex =
            event.buttons == 1 ? selectedSprite! : 0;
      }

      setState(() {});
    }
  }

  Widget _materialPicker({
    required Asset material,
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
  Widget _spritePicker({required Asset sprite, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: sprite.color,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: selectedMaterial == sprite.index
                      ? Colors.black
                      : Colors.transparent,
                ),
              ),
            ),
            const SizedBox(width: margin),
            Text(
              sprite.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedSprite == sprite.index
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
                  materials[map[row * mapSize + column].materialIndex].color,
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
