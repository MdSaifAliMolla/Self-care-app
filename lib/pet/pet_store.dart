import 'package:gsoc_smart_health_reminder/pet/shop_item.dart';

class PetStore {
  final List<StoreItem> micropets;
  final List<StoreItem> backgrounds;
  final Map<int, int> petUpgradeCosts;
  
  PetStore({
    required this.micropets,
    required this.backgrounds,
    required this.petUpgradeCosts,
  });
}
