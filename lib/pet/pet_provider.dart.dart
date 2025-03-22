import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/pet/models/user.dart';
import 'package:gsoc_smart_health_reminder/pet/pet_store.dart';
import 'package:gsoc_smart_health_reminder/pet/shop_item.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  late User _user;
  User get user => _user;

  // Define a hardcoded store
  final PetStore _store = PetStore(
    micropets: [
      StoreItem(
        id: 'mp1',
        name: 'Fluffy',
        description: 'A fluffy companion for your pet',
        cost: 100,
        unlockStage: 2,
        previewAsset: 'assets/micropets/fly.gif',
      ),
      StoreItem(
        id: 'mp2',
        name: 'Spike',
        description: 'A spiky little friend',
        cost: 200,
        unlockStage: 2,
        previewAsset: 'assets/micropets/Dog Parachute.gif',
      ),
    ],
    backgrounds: [
      StoreItem(
        id: 'bg1',
        name: 'Forest',
        description: 'A peaceful forest setting',
        cost: 150,
        unlockStage: 1,
        previewAsset: 'assets/backgrounds/grass.jpg',
      ),
      StoreItem(
        id: 'bg2',
        name: 'Beach',
        description: 'Sunny beach paradise',
        cost: 300,
        unlockStage: 3,
        previewAsset: 'assets/backgrounds/grass.jpg',
      ),
    ],
    petUpgradeCosts: {
      2: 100,
      3: 300,
      4: 700,
      5: 1500,
    },
  );

  // Expose the store via a getter
  PetStore get store => _store;

  UserProvider() {
    _loadUser();
  }
  final Box _userBox = Hive.box('userBox');
   Future<void> _loadUser() async {
    final userData = _userBox.get('user_user123');
    if (userData != null) {
      _user = User.fromJson(jsonDecode(userData));
    } else {
      _user = User(id: 'user123', coins: 500);
      await saveUser();
    }
    notifyListeners();
  }

  Future<void> saveUser() async {
    await _userBox.put('user_${_user.id}', jsonEncode(_user.toJson()));
  }


  Future<void> updateCoins(int amount) async {
    _user.coins += amount;
    await saveUser();
    notifyListeners();
  }

  Future<bool> upgradePet() async {
    final upgraded = _user.pet.upgrade(_user.coins, _store.petUpgradeCosts);
    if (upgraded) {
      _user.coins -= _store.petUpgradeCosts[_user.pet.stage]!;
      await saveUser();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> purchaseItem(String itemType, StoreItem item) async {
    if (itemType == 'micropet') {
      if (_user.coins >= item.cost && _user.pet.stage >= item.unlockStage) {
        _user.coins -= item.cost;
        _user.ownedMicropets.add(item.id);
        await saveUser();
        notifyListeners();
        return true;
      }
    } else if (itemType == 'background') {
      if (_user.coins >= item.cost && _user.pet.stage >= item.unlockStage) {
        _user.coins -= item.cost;
        _user.ownedBackgrounds.add(item.id);
        await saveUser();
        notifyListeners();
        return true;
      }
    }
    return false;
  }
}
