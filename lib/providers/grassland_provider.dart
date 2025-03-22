import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GrasslandProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _items = [];
  late Box _box;

  GrasslandProvider() {
    _loadItems();
  }

  List<Map<String, dynamic>> get items => _items;

  Future<void> _loadItems() async {
    _box = await Hive.openBox('assets');
    _items = List<Map<String, dynamic>>.from(_box.get('items', defaultValue: []));
    notifyListeners();
  }

  void addItem(String assetPath, double x, double y) {
    final newItem = {"assetPath": assetPath, "x": x, "y": y};
    _items.add(newItem);
    _box.put('items', _items); 
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    _box.delete('items');
    notifyListeners();
  }
}
