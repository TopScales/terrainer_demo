# Terrainer Demo

Use this project to test the Godot **[Terrainer](https://github.com/TopScales/terrainer) plugin**. Terrainer is an efficient terrain generator and editor that uses the power of GPU to render large maps.

## How to use

- Clone the project and open it with the Godot Editor (version 4.5 needed).
- Open the `res://scenes/terrain/terrain.tscn` scene.
- Execute the game (<kbd>F5</kbd>) to navigate the scene and be able to change the settings.

**NOTE:** Only Windows binaries are provided, but binaries for other platforms [can be generated](#building-binaries).

### Controls

When executing the demo, the camera can be moved with <kbd>W</kbd> <kbd>A</kbd> <kbd>S</kbd> <kbd>D</kbd> keys. Use <kbd>Space</kbd> to raise the camera and <kbd>Shift</kbd> to lower it. The speed of the camera can be increased by pressing <kbd>Ctrl</kbd>.

### Settings

In the top-right corner of the screen, the `Settings` button can be found. Toggle the button to show/hide the Settings options.
- **Chunk Size**. The number of quads per side to use in a chunk.
- **Detailed Chunk Radius**. The radius (relative to the chunk size) considered to generate LOD0 sections.
- **Camera Far Distance**. The rendering distance of the camera.
- **Show Debug Boxes**. Show bounding boxes of each rendered section.

## Building binaries

Only Windows binaries are provided for now, but binaries for other platforms can be compiled.

- Clone this repo.
- Update the submodules `git submodule update --init --recursive`.
- Go to `libs/gdextension/terrainer` directory.
- Compile for the target platform. Make sure to specify the C++ bindings folder and the destination path: `scons platform=<platform> BIN_OUTPUT=../.. GODOT_BINDINGS=../godot-cpp`.
- To make the terrain generation work inside the editor, the library needs to be compiled with the `target=editor` option.