// widgets/tile_selector.dart
import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/game/game_provider.dart';
import 'package:provider/provider.dart';
import '../game/tile_type.dart';

class TileSelector extends StatelessWidget {
  const TileSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Selected: ${gameProvider.isErasing ? "Eraser" : gameProvider.selectedTileType.displayName.toUpperCase()}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Eraser Tool
              _buildTileOption(
                context,
                icon: Icons.delete,
                isSelected: gameProvider.isErasing,
                onTap: () => gameProvider.toggleEraser(),
              ),
              // Divider
              Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.white24,
              ),
              // Actual tiles
              ...TileType.values.where((type) => type != TileType.grass).map((type) {
                return _buildTileOption(
                  context,
                  tileType: type,
                  isSelected: !gameProvider.isErasing && gameProvider.selectedTileType == type,
                  onTap: () => gameProvider.selectTileType(type),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTileOption(
    BuildContext context, {
    TileType? tileType,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white24 : Colors.black45,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, color: Colors.white, size: 36)
            else if (tileType != null)
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset(
                  'assets/images/grass.jpg',
                  width: 40,
                  height: 40,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              tileType?.displayName.toUpperCase() ?? 'ERASER',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}