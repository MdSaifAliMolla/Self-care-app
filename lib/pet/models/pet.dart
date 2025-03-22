class Pet {
  int stage;
  int mood;
  DateTime lastInteraction;
  String activeSkin;

  Pet({
    this.stage = 1,
    this.mood = 100,
    DateTime? lastInteraction,
    this.activeSkin = 'default',
  }) : lastInteraction = lastInteraction ?? DateTime.now();
  
  bool canUpgrade(int coins, Map<int, int> upgradeCosts) {
    return coins >= upgradeCosts[stage + 1]!;
  }
  
  bool upgrade(int coins, Map<int, int> upgradeCosts) {
    final nextStageCost = upgradeCosts[stage + 1]!;
    if (coins >= nextStageCost) {
      stage++;
      return true;
    }
    return false;
  }
  
  Map<String, dynamic> toJson() => {
    'stage': stage,
    'mood': mood,
    'lastInteraction': lastInteraction.toIso8601String(),
    'activeSkin': activeSkin,
  };
  
  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
    stage: json['stage'],
    mood: json['mood'],
    lastInteraction: DateTime.parse(json['lastInteraction']),
    activeSkin: json['activeSkin'],
  );
}
