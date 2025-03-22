// providers/game_provider.dart
import 'package:flutter/material.dart';
import '../game/tile_type.dart';

class GameProvider extends ChangeNotifier {
  TileType _selectedTileType = TileType.tree;
  bool _isErasing = false;
  
  TileType get selectedTileType => _selectedTileType;
  bool get isErasing => _isErasing;
  
  void selectTileType(TileType type) {
    _selectedTileType = type;
    _isErasing = false;
    notifyListeners();
  }
  
  void toggleEraser() {
    _isErasing = !_isErasing;
    notifyListeners();
  }
}