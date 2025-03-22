// game/tile.dart
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'tile_type.dart';

class Tile extends SpriteComponent with HasGameRef {
  TileType type;
  late Sprite grassSprite;
  
  Tile({
    required Vector2 position,
    required Vector2 size,
    required this.type,
  }) : super(
          position: position,
          size: size,
        );
  
  @override
  Future<void> onLoad() async {
    // Load the grass sprite as our base
    grassSprite = await gameRef.loadSprite('assets/images/grass.jpg');
    
    // Load the initial sprite for this tile
    sprite = await gameRef.loadSprite(type.spritePath);
    
    return super.onLoad();
  }
  
  Future<void> updateType(TileType newType) async {
    if (type == newType) return;
    
    type = newType;
    
    // For most decorative items, we want to show grass underneath
    if (type != TileType.grass && 
        (type.isDecoration || type == TileType.path || type == TileType.bridge)) {
      // First draw grass (handled in render)
      // Then load the decoration sprite on top
      sprite = await gameRef.loadSprite('grass.png');
    } else {
      // For terrain replacement tiles (water, structures), just replace the sprite
      sprite = await gameRef.loadSprite('grass.png');
    }
  }
  
  @override
  void render(Canvas canvas) {
    // For decorative items, render grass underneath first
    if (type != TileType.grass && 
        (type.isDecoration || type == TileType.path || type == TileType.bridge)) {
      grassSprite.render(
        canvas,
        position: Vector2.zero(),
        size: size,
      );
    }
    
    // Then render the main sprite
    super.render(canvas);
  }
}