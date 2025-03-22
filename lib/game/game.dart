import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/game/game_provider.dart';
import 'package:gsoc_smart_health_reminder/game/tilemap_component.dart';
import 'package:provider/provider.dart';

import 'tile_type.dart';

class TilemapGame extends FlameGame with TapCallbacks, DragCallbacks {
  static const int mapWidth = 30;
  static const int mapHeight = 20;
  static const double tileSize = 32.0;
  
  late TileMap tileMap;
  late GameProvider gameProvider;
  Vector2? lastDragPosition;
  late CameraComponent cameraComponent;
  
  @override
  Future<void> onLoad() async {
    // Load all sprites
    await images.loadAll([
      for (var type in TileType.values) type.spritePath,
    ]);
    
    // Initialize the game provider from the BuildContext
    gameProvider = Provider.of<GameProvider>(buildContext!, listen: false);
    
    // Create camera with limits
    cameraComponent = CameraComponent.withFixedResolution(
      width: mapWidth * tileSize,
      height: mapHeight * tileSize,
    );
    
    // Add the camera component to the game
    add(cameraComponent);
    
    // Set up the tilemap
    tileMap = TileMap(
      tileSize: tileSize,
      mapWidth: mapWidth, 
      mapHeight: mapHeight,
    );
    
    // Add the tilemap to the world
    world.add(tileMap);
    
    return super.onLoad();
  }
  
  @override
  void onTapDown(TapDownEvent event) {
    final touchPosition = event.canvasPosition;
    final gridPosition = tileMap.screenToGrid(touchPosition);
    
    placeTileAtPosition(gridPosition);
    
    super.onTapDown(event);
  }
  
  @override
  void onDragStart(DragStartEvent event) {
    final touchPosition = event.canvasPosition;
    lastDragPosition = tileMap.screenToGrid(touchPosition);
    
    placeTileAtPosition(lastDragPosition!);
    
    super.onDragStart(event);
  }
  
  @override
  void onDragUpdate(DragUpdateEvent event) {
    final touchPosition = event.canvasPosition;
    final gridPosition = tileMap.screenToGrid(touchPosition);
    
    // Only place a tile if we've moved to a new grid position
    if (gridPosition != lastDragPosition) {
      placeTileAtPosition(gridPosition);
      lastDragPosition = gridPosition;
    }
    
    super.onDragUpdate(event);
  }
  
  void placeTileAtPosition(Vector2 gridPosition) {
    if (gameProvider.isErasing) {
      // When erasing, always revert to grass
      tileMap.placeTile(gridPosition, TileType.grass);
    } else {
      // When placing, use the selected tile type
      tileMap.placeTile(gridPosition, gameProvider.selectedTileType);
    }
  }
  
  void saveMap() {
    // In a real app, you'd implement saving to a file or database
    print('Map saved to memory!');
  }
  
  void resetMap() {
    tileMap.resetToGrass();
  }
}