import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/game/game.dart';
import 'package:gsoc_smart_health_reminder/game/game_provider.dart';
import 'package:gsoc_smart_health_reminder/game/tile_selector.dart';
import 'package:gsoc_smart_health_reminder/game/tile_type.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);
  
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Make this nullable to safely handle initialization
  TilemapGame? _game;
  
  @override
  void initState() {
    super.initState();
    // Initialize the game safely
    try {
      _game = TilemapGame();
    } catch (e) {
      debugPrint('Error initializing game: $e');
      // We'll handle this gracefully in the build method
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Safely access the game provider
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Tilemap Builder'),
        actions: [
          // Toggle eraser button
          Consumer<GameProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: Icon(
                  provider.isErasing ? Icons.edit : Icons.auto_fix_high,
                  color: provider.isErasing ? Colors.red : null,
                ),
                tooltip: provider.isErasing ? 'Switch to Draw' : 'Switch to Eraser',
                onPressed: () {
                  provider.toggleEraser();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(provider.isErasing ? 'Eraser activated' : 'Drawing mode activated'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Map',
            onPressed: _game == null ? null : () {
              _game!.saveMap();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Map saved!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Map',
            onPressed: _game == null ? null : () {
              _game!.resetMap();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Map reset to grass')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _game == null
                ? const Center(
                    child: Text(
                      'Unable to initialize game. Please restart the app.',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : GameWidget(
                    game: _game!,
                    loadingBuilder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorBuilder: (context, error) {
                      return Center(
                        child: Text(
                          'Error loading game: $error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    },
                  ),
          ),
          // Tool selection bar
          Container(
            height: 50,
            color: Colors.grey[800],
            child: Consumer<GameProvider>(
              builder: (context, provider, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Eraser toggle button
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.auto_fix_high,
                        color: provider.isErasing ? Colors.red : Colors.white,
                      ),
                      label: Text(
                        'Eraser',
                        style: TextStyle(
                          color: provider.isErasing ? Colors.red : Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: provider.isErasing ? Colors.white : Colors.grey[700],
                      ),
                      onPressed: () => provider.toggleEraser(),
                    ),
                    // Quick access buttons section is removed since it was commented out
                  ],
                );
              },
            ),
          ),
          // Tile selector panel
          Container(
            height: 120,
            color: Colors.black87,
            child: const TileSelector(),
          ),
        ],
      ),
    );
  }
  
  // Keep the method in case you want to use it later
  Widget _buildQuickTileButton(TileType tileType, GameProvider provider) {
    final isSelected = provider.selectedTileType == tileType && !provider.isErasing;
    
    return GestureDetector(
      onTap: () {
        provider.selectTileType(tileType);
        if(provider.isErasing) provider.toggleEraser();
      },
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Image.asset(
          'assets/${tileType.spritePath}',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey,
              child: const Icon(Icons.broken_image, size: 20),
            );
          },
        ),
      ),
    );
  }
}