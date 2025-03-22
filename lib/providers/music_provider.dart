import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/models/music._model.dart';

class MeditationSoundProvider with ChangeNotifier {
  final List<MeditationSound> _sounds = [
    MeditationSound(
      id: 'am_1',
      title: 'Rainy day in Town',
      assetPath: 'assets/sound/rainy-day-in-town.mp3',
      cost: 0,
      category: 'Ambient',
    ),
    MeditationSound(
      id: 'in_1',
      title: 'Sitar',
      assetPath: 'assets/sound/sitar.mp3',
      cost: 3,
      category: 'Instrumental',
    ),
  ];

  List<MeditationSound> get sounds => _sounds;

  List<MeditationSound> getSoundsByCategory(String category) {
    return _sounds.where((sound) => sound.category == category).toList();
  }
}