// game/tile_type.dart
enum TileType {
  grass,   // Base tile
  tree,    // Decorative
  flower,  // Decorative
  rock,    // Obstacle
  water,   // Special terrain
  path,    // Walkable path
  bridge,  // Water crossing
  house,   // Building
  fence,   // Boundary
  crops,   // Farm element
  bush,    // Small obstacle
}

extension TileTypeExtension on TileType {
  String get spritePath {
    switch (this) {
      case TileType.grass:
        return 'grass.jpg';
      case TileType.tree:
        return 'grass.jpg';
      case TileType.flower:
        return 'grass.jpg';
      case TileType.rock:
        return 'grass.jpg';
      case TileType.water:
        return 'grass.jpg';
      case TileType.path:
        return 'grass.jpg';
      case TileType.bridge:
        return 'grass.jpg';
      case TileType.house:
        return 'grass.jpg';
      case TileType.fence:
        return 'grass.jpg';
      case TileType.crops:
        return 'grass.jpg';
      case TileType.bush:
        return 'grass.jpg';
    }
  }
  
  String get displayName {
    return toString().split('.').last;
  }
  
  bool get isStructure {
    return this == TileType.house || 
           this == TileType.bridge || 
           this == TileType.fence;
  }
  
  bool get isDecoration {
    return this == TileType.tree || 
           this == TileType.flower || 
           this == TileType.bush || 
           this == TileType.rock;
  }
  
  bool get isPassable {
    return this == TileType.grass || 
           this == TileType.path || 
           this == TileType.flower || 
           this == TileType.bridge || 
           this == TileType.crops;
  }
}