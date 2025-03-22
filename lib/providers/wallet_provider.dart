import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/models/music._model.dart';
import 'package:hive/hive.dart';

class WalletProvider with ChangeNotifier {
  int _coins = Hive.box('coinBox').get('coins', defaultValue: 0);
  final Box _purchasedSoundsBox = Hive.box('purchasedSoundsBox');

  int get coins => _coins;

  bool isSoundPurchased(String soundTitle) {
    return _purchasedSoundsBox.values.contains(soundTitle);
  }


  bool canPurchase(int soundCost) {
    return _coins >= soundCost;
  }

  void purchaseSound(MeditationSound sound) {
    if (canPurchase(sound.cost)) {
      _coins -= sound.cost;
      Hive.box('coinBox').put('coins', _coins);
      _purchasedSoundsBox.put(sound.id, sound.title);
      notifyListeners();
    }
  }
}
