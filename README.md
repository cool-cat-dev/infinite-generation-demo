# Godot 4 Infinite World Generation

This repository contains the completed code for my Godot 4 Infinite World Generation tutorial. This system is very minimalist but could be expanded for larger-scale projects.

## Features

- Infinite procedural world generation
- Chunk-based loading and unloading
- Player-centered world creation
- Camera system with optional map view
- Simple resource distribution algorithm

## Getting Started

1. Clone or download this repository
2. Open the project in Godot 4.x
3. Explore the demo scene to see the infinite generation in action
4. Check out the code to understand how it works

## How to Use in Your Own Project

### Basic Implementation

1. Copy the `procedural_generation` scene to your project
2. Add your own tileset to generate with (my example is VERY simple)
3. Configure generation parameters in the 'procedural_generation.gd' script
4. Adjust the Camera2D settings for your desired view

### Extending Functionality

The system is very minimal, but could be extended with:
- Biome variety
- Different terrain types
- Advanced noise algorithms
- Structure placement

## Project Structure

- `scripts/Player.gd` - Player movement and world centering
- `scripts/Camera2D.gd` - Optional map camera functionality
- `scenes/procedural_generation.tscn` - Main world generation scene

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Thank You!

Thank you for downloading this infinite world generation system! I hope it helps out on your game dev journey.
If you have any questions or issues - create an issue in this repo or just comment on one of my videos.
