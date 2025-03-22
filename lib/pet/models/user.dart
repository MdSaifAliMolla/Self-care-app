import 'pet.dart';

class User {
  final String id;
  int coins;
  Pet pet;
  List<String> ownedMicropets;
  List<String> ownedBackgrounds;
  String activeBackground;
  List<String> activeMicropets;
  
  User({
    required this.id,
    this.coins = 0,
    Pet? pet,
    this.ownedMicropets = const [],
    this.ownedBackgrounds = const [],
    this.activeBackground = 'default',
    this.activeMicropets = const [],
  }) : pet = pet ?? Pet();
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coins': coins,
      'pet': pet.toJson(),
      'ownedMicropets': ownedMicropets,
      'ownedBackgrounds': ownedBackgrounds,
      'activeBackground': activeBackground,
      'activeMicropets': activeMicropets,
    };
  }
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      coins: json['coins'] as int,
      pet: Pet.fromJson(json['pet'] as Map<String, dynamic>),
      ownedMicropets: List<String>.from(json['ownedMicropets'] as List),
      ownedBackgrounds: List<String>.from(json['ownedBackgrounds'] as List),
      activeBackground: json['activeBackground'] as String,
      activeMicropets: List<String>.from(json['activeMicropets'] as List),
    );
  }
}
