// game/tilemap.dart
import 'package:flame/components.dart';
import 'package:gsoc_smart_health_reminder/game/tile_component.dart';
import 'tile_type.dart';

class TileMap extends Component with HasGameRef {
  final double tileSize;
  final int mapWidth;
  final int mapHeight;
  
  // 2D array to store our map data
  late List<List<Tile>> tiles;
  
  TileMap({
    required this.tileSize,
    required this.mapWidth,
    required this.mapHeight,
  });
  
  @override
  Future<void> onLoad() async {
    // Initialize the map with grass tiles
    tiles = List.generate(
      mapHeight,
      (y) => List.generate(
        mapWidth,
        (x) => Tile(
          position: Vector2(x * tileSize, y * tileSize),
          size: Vector2.all(tileSize),
          type: TileType.grass,
        ),
      ),
    );
    
    // Add all tiles to the game
    for (var row in tiles) {
      for (var tile in row) {
        await add(tile);
      }
    }
    
    return super.onLoad();
  }
  
  // Convert screen position to grid position
  Vector2 screenToGrid(Vector2 position) {
    return Vector2(
      (position.x / tileSize).floor().toDouble(),
      (position.y / tileSize).floor().toDouble(),
    );
  }
  
  // Place a tile at the specified grid position
  void placeTile(Vector2 gridPosition, TileType type) {
    final x = gridPosition.x.toInt();
    final y = gridPosition.y.toInt();
    
    // Check bounds
    if (x >= 0 && x < mapWidth && y >= 0 && y < mapHeight) {
      final tile = tiles[y][x];
      
      // Don't update if it's the same type
      if (tile.type != type) {
        tile.updateType(type);
      }
    }
  }
  
  // Reset the entire map to grass
  void resetToGrass() {
    for (var row in tiles) {
      for (var tile in row) {
        tile.updateType(TileType.grass);
      }
    }
  }
}