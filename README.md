# Flutter 3D Raycasting Engine

This project implements a 3D raycasting engine in Flutter, allowing you to simulate a 3D environment using 2D graphics and basic raycasting techniques. The engine renders a first-person perspective view similar to classic games like Wolfenstein 3D.

## Features

- **Raycasting Rendering:** Simulates 3D graphics using 2D projections and raycasting, based on DDA(Digital Differential Analyzer) algorithm.
- **Player Movement:** Move the player using W, A, S, D keys.
- **Map Editing:** Includes a map editor to create custom maps interactively.
- **Mini Map:** Toggleable minimap for navigation.
- **Texture Rendering:** Toggle to enable/disable texture rendering on walls.
- **Shadow Casting:** Renders shadows based on the distance from the player.

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/hamed-rezaee/flutter_3d_raycast_engine.git
```

2. Navigate to the project directory:

```bash
cd flutter_3d_raycasting
```

3. Run the project:

```bash
flutter run
```

## Controls

- **Move Forward:** W
- **Move Backward:** S
- **Strafe Left:** A
- **Strafe Right:** D
- **Rotate Left:** Q
- **Rotate Right:** E
- **Toggle Minimap:** 1
- **Toggle Textures:** 2

## Map Editor

The map editor allows you to create custom maps interactively.

## Demo

![Demo](flutter_3d_raycast_engine.gif)

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgements

Wolfenstein 3D was developed by id Software and released in 1992. This project is inspired by the original game and implements a simplified version of the raycasting engine used in Wolfenstein 3D.
