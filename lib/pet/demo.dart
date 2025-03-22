// import 'package:flutter/material.dart';

// // Main pet model
// class Pet {
//   int stage;
//   int mood;
//   DateTime lastInteraction;
//   String activeSkin;
  
//   Pet({
//     this.stage = 1,
//     this.mood = 100,
//     this.lastInteraction,
//     this.activeSkin = 'default',
//   }) {
//     lastInteraction ??= DateTime.now();
//   }
  
//   // Check if pet can be upgraded
//   bool canUpgrade(int coins, Map<int, int> upgradeCosts) {
//     return coins >= upgradeCosts[stage + 1];
//   }
  
//   // Upgrade pet to next stage
//   bool upgrade(int coins, Map<int, int> upgradeCosts) {
//     final nextStageCost = upgradeCosts[stage + 1];
//     if (coins >= nextStageCost) {
//       stage++;
//       return true;
//     }
//     return false;
//   }
  
//   // Convert to and from JSON
//   Map<String, dynamic> toJson() => {
//     'stage': stage,
//     'mood': mood,
//     'lastInteraction': lastInteraction.toIso8601String(),
//     'activeSkin': activeSkin,
//   };
  
//   factory Pet.fromJson(Map<String, dynamic> json) => Pet(
//     stage: json['stage'],
//     mood: json['mood'],
//     lastInteraction: DateTime.parse(json['lastInteraction']),
//     activeSkin: json['activeSkin'],
//   );
// }

// // User model with pet, coins, and inventory
// class User {
//   final String id;
//   int coins;
//   Pet pet;
//   List<String> ownedMicropets;
//   List<String> ownedBackgrounds;
//   String activeBackground;
//   List<String> activeMicropets;
  
//   User({
//     required this.id,
//     this.coins = 0,
//     Pet? pet,
//     this.ownedMicropets = const [],
//     this.ownedBackgrounds = const [],
//     this.activeBackground = 'default',
//     this.activeMicropets = const [],
//   }) {
//     this.pet = pet ?? Pet();
//   }
  
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'coins': coins,
//     'pet': pet.toJson(),
//     'ownedMicropets': ownedMicropets,
//     'ownedBackgrounds': ownedBackgrounds,
//     'activeBackground': activeBackground,
//     'activeMicropets': activeMicropets,
//   };
  
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json['id'],
//     coins: json['coins'],
//     pet: Pet.fromJson(json['pet']),
//     ownedMicropets: List<String>.from(json['ownedMicropets']),
//     ownedBackgrounds: List<String>.from(json['ownedBackgrounds']),
//     activeBackground: json['activeBackground'],
//     activeMicropets: List<String>.from(json['activeMicropets']),
//   );
// }

// // Store items
// class StoreItem {
//   final String id;
//   final String name;
//   final String description;
//   final int cost;
//   final int unlockStage;
//   final String previewAsset;
  
//   StoreItem({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.cost,
//     required this.unlockStage,
//     required this.previewAsset,
//   });
// }

// // Store model
// class PetStore {
//   final List<StoreItem> micropets;
//   final List<StoreItem> backgrounds;
//   final Map<int, int> petUpgradeCosts;
  
//   PetStore({
//     required this.micropets,
//     required this.backgrounds,
//     required this.petUpgradeCosts,
//   });
// }

// // User repository for saving user data
// class UserRepository {
//   final SharedPreferences prefs;
  
//   UserRepository(this.prefs);
  
//   Future<User?> getUser(String userId) async {
//     final userData = prefs.getString('user_$userId');
//     if (userData != null) {
//       return User.fromJson(jsonDecode(userData));
//     }
//     return null;
//   }
  
//   Future<void> saveUser(User user) async {
//     await prefs.setString('user_${user.id}', jsonEncode(user.toJson()));
//   }
  
//   Future<void> updateCoins(String userId, int amount) async {
//     final user = await getUser(userId);
//     if (user != null) {
//       user.coins += amount;
//       await saveUser(user);
//     }
//   }
  
//   Future<bool> upgradePet(String userId) async {
//     final user = await getUser(userId);
//     final store = getStore();
    
//     if (user != null) {
//       final upgraded = user.pet.upgrade(user.coins, store.petUpgradeCosts);
//       if (upgraded) {
//         user.coins -= store.petUpgradeCosts[user.pet.stage];
//         await saveUser(user);
//         return true;
//       }
//     }
//     return false;
//   }
  
//   Future<bool> purchaseItem(String userId, String itemType, String itemId) async {
//     final user = await getUser(userId);
//     final store = getStore();
    
//     if (user != null) {
//       StoreItem? item;
      
//       if (itemType == 'micropet') {
//         item = store.micropets.firstWhere((m) => m.id == itemId);
//         if (user.coins >= item.cost && user.pet.stage >= item.unlockStage) {
//           user.coins -= item.cost;
//           user.ownedMicropets.add(itemId);
//           await saveUser(user);
//           return true;
//         }
//       } else if (itemType == 'background') {
//         item = store.backgrounds.firstWhere((b) => b.id == itemId);
//         if (user.coins >= item.cost && user.pet.stage >= item.unlockStage) {
//           user.coins -= item.cost;
//           user.ownedBackgrounds.add(itemId);
//           await saveUser(user);
//           return true;
//         }
//       }
//     }
//     return false;
//   }
  
//   // Return a hardcoded store for this example
//   PetStore getStore() {
//     return PetStore(
//       micropets: [
//         StoreItem(
//           id: 'mp1',
//           name: 'Fluffy',
//           description: 'A fluffy companion for your pet',
//           cost: 100,
//           unlockStage: 2,
//           previewAsset: 'assets/micropets/fluffy.png',
//         ),
//         StoreItem(
//           id: 'mp2',
//           name: 'Spike',
//           description: 'A spiky little friend',
//           cost: 200,
//           unlockStage: 2,
//           previewAsset: 'assets/micropets/spike.png',
//         ),
//         // Add more micropets
//       ],
//       backgrounds: [
//         StoreItem(
//           id: 'bg1',
//           name: 'Forest',
//           description: 'A peaceful forest setting',
//           cost: 150,
//           unlockStage: 1,
//           previewAsset: 'assets/backgrounds/forest.png',
//         ),
//         StoreItem(
//           id: 'bg2',
//           name: 'Beach',
//           description: 'Sunny beach paradise',
//           cost: 300,
//           unlockStage: 3,
//           previewAsset: 'assets/backgrounds/beach.png',
//         ),
//         // Add more backgrounds
//       ],
//       petUpgradeCosts: {
//         2: 100,   // Cost to upgrade from stage 1 to 2
//         3: 300,   // Cost to upgrade from stage 2 to 3
//         4: 700,   // Cost to upgrade from stage 3 to 4
//         5: 1500,  // Cost to upgrade from stage 4 to 5
//       },
//     );
//   }
// }

// // Animation controller for pet
// class PetAnimationController {
//   final String basePath;
//   final int stage;
//   final Map<String, List<String>> animations;
//   String currentAnimation;
//   int currentFrame = 0;
//   Timer? animationTimer;
  
//   PetAnimationController({
//     required this.basePath,
//     required this.stage,
//     required this.animations,
//     this.currentAnimation = 'idle',
//   });
  
//   String get currentFramePath {
//     final frames = animations[currentAnimation] ?? animations['idle']!;
//     return '$basePath/stage$stage/$currentAnimation/${frames[currentFrame]}';
//   }
  
//   void startAnimation() {
//     animationTimer?.cancel();
//     animationTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
//       currentFrame = (currentFrame + 1) % (animations[currentAnimation]?.length ?? 1);
//     });
//   }
  
//   void stopAnimation() {
//     animationTimer?.cancel();
//     animationTimer = null;
//   }
  
//   void playAnimation(String animationName) {
//     if (animations.containsKey(animationName)) {
//       currentAnimation = animationName;
//       currentFrame = 0;
//     }
//   }
  
//   void dispose() {
//     stopAnimation();
//   }
// }

// // Pet widget
// class PetWidget extends StatefulWidget {
//   final Pet pet;
//   final VoidCallback? onTap;
  
//   const PetWidget({
//     Key? key,
//     required this.pet,
//     this.onTap,
//   }) : super(key: key);
  
//   @override
//   _PetWidgetState createState() => _PetWidgetState();
// }

// class _PetWidgetState extends State<PetWidget> {
//   late PetAnimationController controller;
  
//   @override
//   void initState() {
//     super.initState();
//     controller = PetAnimationController(
//       basePath: 'assets/pet',
//       stage: widget.pet.stage,
//       animations: {
//         'idle': ['frame1.png', 'frame2.png', 'frame3.png', 'frame4.png'],
//         'happy': ['happy1.png', 'happy2.png', 'happy3.png', 'happy4.png'],
//         'upgrade': ['upgrade1.png', 'upgrade2.png', 'upgrade3.png', 'upgrade4.png'],
//       },
//     );
//     controller.startAnimation();
//   }
  
//   @override
//   void didUpdateWidget(PetWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.pet.stage != widget.pet.stage) {
//       controller = PetAnimationController(
//         basePath: 'assets/pet',
//         stage: widget.pet.stage,
//         animations: controller.animations,
//         currentAnimation: 'upgrade',
//       );
//       controller.startAnimation();
      
//       // Switch back to idle after upgrade animation completes
//       Future.delayed(Duration(seconds: 2), () {
//         if (mounted) {
//           setState(() {
//             controller.playAnimation('idle');
//           });
//         }
//       });
//     }
//   }
  
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         widget.onTap?.call();
//         setState(() {
//           controller.playAnimation('happy');
//         });
//         Future.delayed(Duration(seconds: 1), () {
//           if (mounted) {
//             setState(() {
//               controller.playAnimation('idle');
//             });
//           }
//         });
//       },
//       child: Image.asset(
//         controller.currentFramePath,
//         width: 200,
//         height: 200,
//       ),
//     );
//   }
// }

// // Main pet screen
// class PetScreen extends StatefulWidget {
//   @override
//   _PetScreenState createState() => _PetScreenState();
// }

// class _PetScreenState extends State<PetScreen> with TickerProviderStateMixin {
//   late User user;
//   late UserRepository repository;
//   late PetStore store;
  
//   // Controllers for micropet animations
//   final Map<String, AnimationController> micropetControllers = {};
  
//   @override
//   void initState() {
//     super.initState();
//     // Initialize with dummy data
//     user = User(id: 'user123', coins: 500);
//     repository = UserRepository(SharedPreferences.getInstance() as SharedPreferences);
//     store = repository.getStore();
    
//     _loadUser();
//     _setupMicropetAnimations();
//   }
  
//   Future<void> _loadUser() async {
//     final loadedUser = await repository.getUser('user123');
//     if (loadedUser != null) {
//       setState(() {
//         user = loadedUser;
//       });
//     } else {
//       await repository.saveUser(user);
//     }
//   }
  
//   void _setupMicropetAnimations() {
//     // Create animation controllers for active micropets
//     for (final micropetId in user.activeMicropets) {
//       micropetControllers[micropetId] = AnimationController(
//         vsync: this,
//         duration: Duration(milliseconds: 800),
//       )..repeat(reverse: true);
//     }
//   }
  
//   Future<void> _upgradePet() async {
//     final upgraded = await repository.upgradePet(user.id);
//     if (upgraded) {
//       setState(() {
//         _loadUser();
//       });
//       // Show success animation or notification
//     } else {
//       // Show not enough coins message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Not enough coins to upgrade your pet!')),
//       );
//     }
//   }
  
//   @override
//   void dispose() {
//     for (final controller in micropetControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Pet'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Icon(Icons.monetization_on, color: Colors.amber),
//                 SizedBox(width: 4),
//                 Text('${user.coins}', style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Background
//           Positioned.fill(
//             child: Image.asset(
//               'assets/backgrounds/${user.activeBackground}.png',
//               fit: BoxFit.cover,
//             ),
//           ),
          
//           // Main pet
//           Center(
//             child: PetWidget(
//               pet: user.pet,
//               onTap: () {
//                 // Interaction with pet increases mood
//                 setState(() {
//                   user.pet.mood = min(100, user.pet.mood + 5);
//                   user.pet.lastInteraction = DateTime.now();
//                 });
//                 repository.saveUser(user);
//               },
//             ),
//           ),
          
//           // Micropets
//           ...user.activeMicropets.map((micropetId) {
//             final micropet = store.micropets.firstWhere((mp) => mp.id == micropetId);
//             final animation = micropetControllers[micropetId];
            
//             return Positioned(
//               left: 50.0 + (user.activeMicropets.indexOf(micropetId) * 100),
//               bottom: 50,
//               child: AnimatedBuilder(
//                 animation: animation!,
//                 builder: (context, child) {
//                   return Transform.translate(
//                     offset: Offset(0, animation.value * 10),
//                     child: Image.asset(
//                       micropet.previewAsset,
//                       width: 80,
//                       height: 80,
//                     ),
//                   );
//                 },
//               ),
//             );
//           }).toList(),
          
//           // Pet info panel
//           Positioned(
//             top: 20,
//             left: 20,
//             child: Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.8),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Level ${user.pet.stage}', style: TextStyle(fontWeight: FontWeight.bold)),
//                   SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(Icons.favorite, color: Colors.red, size: 16),
//                       SizedBox(width: 4),
//                       Text('Mood: ${user.pet.mood}%'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//           // Upgrade button
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: ElevatedButton.icon(
//               icon: Icon(Icons.arrow_upward),
//               label: Text('Upgrade (${store.petUpgradeCosts[user.pet.stage + 1] ?? 'Max'})'),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.green,
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               ),
//               onPressed: user.pet.stage < 5 ? _upgradePet : null,
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBar.item(icon: Icon(Icons.pets), label: 'Pet'),
//           BottomNavigationBar.item(icon: Icon(Icons.shopping_cart), label: 'Store'),
//           BottomNavigationBar.item(icon: Icon(Icons.check_box), label: 'Tasks'),
//         ],
//         onTap: (index) {
//           // Navigate to corresponding screen
//           if (index == 1) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => StoreScreen(userId: user.id)),
//             );
//           } else if (index == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => TasksScreen(userId: user.id)),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// // Store screen
// class StoreScreen extends StatefulWidget {
//   final String userId;
  
//   const StoreScreen({Key? key, required this.userId}) : super(key: key);
  
//   @override
//   _StoreScreenState createState() => _StoreScreenState();
// }

// class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late UserRepository repository;
//   late User user;
//   late PetStore store;
//   bool isLoading = true;
  
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     repository = UserRepository(SharedPreferences.getInstance() as SharedPreferences);
//     _loadData();
//   }
  
//   Future<void> _loadData() async {
//     final loadedUser = await repository.getUser(widget.userId);
//     setState(() {
//       user = loadedUser ?? User(id: widget.userId);
//       store = repository.getStore();
//       isLoading = false;
//     });
//   }
  
//   Future<void> _purchaseItem(String itemType, StoreItem item) async {
//     final purchased = await repository.purchaseItem(widget.userId, itemType, item.id);
//     if (purchased) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('${item.name} purchased successfully!')),
//       );
//       _loadData();
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Cannot purchase ${item.name}. Check your coins or pet level.')),
//       );
//     }
//   }
  
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(title: Text('Store')),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pet Store'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(text: 'Micropets'),
//             Tab(text: 'Backgrounds'),
//           ],
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Icon(Icons.monetization_on, color: Colors.amber),
//                 SizedBox(width: 4),
//                 Text('${user.coins}', style: TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // Micropets tab
//           GridView.builder(
//             padding: EdgeInsets.all(16),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.75,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//             ),
//             itemCount: store.micropets.length,
//             itemBuilder: (context, index) {
//               final micropet = store.micropets[index];
//               final isOwned = user.ownedMicropets.contains(micropet.id);
//               final isUnlocked = user.pet.stage >= micropet.unlockStage;
              
//               return Card(
//                 clipBehavior: Clip.antiAlias,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Expanded(
//                       child: Stack(
//                         children: [
//                           Image.asset(
//                             micropet.previewAsset,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           ),
//                           if (!isUnlocked)
//                             Positioned.fill(
//                               child: Container(
//                                 color: Colors.black.withOpacity(0.7),
//                                 child: Center(
//                                   child: Text(
//                                     'Unlock at\nLevel ${micropet.unlockStage}',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             micropet.name,
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(micropet.description, style: TextStyle(fontSize: 12)),
//                           SizedBox(height: 8),
//                           if (isOwned)
//                             ElevatedButton(
//                               onPressed: () {
//                                 // Toggle micropet active status
//                                 setState(() {
//                                   if (user.activeMicropets.contains(micropet.id)) {
//                                     user.activeMicropets.remove(micropet.id);
//                                   } else {
//                                     user.activeMicropets.add(micropet.id);
//                                   }
//                                 });
//                                 repository.saveUser(user);
//                               },
//                               child: Text(
//                                 user.activeMicropets.contains(micropet.id) ? 'Deactivate' : 'Activate'
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 primary: user.activeMicropets.contains(micropet.id) 
//                                     ? Colors.red 
//                                     : Colors.green,
//                               ),
//                             )
//                           else
//                             ElevatedButton.icon(
//                               icon: Icon(Icons.shopping_cart),
//                               label: Text('${micropet.cost}'),
//                               onPressed: isUnlocked ? () => _purchaseItem('micropet', micropet) : null,
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
          
//           // Backgrounds tab
//           GridView.builder(
//             padding: EdgeInsets.all(16),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.75,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//             ),
//             itemCount: store.backgrounds.length,
//             itemBuilder: (context, index) {
//               final background = store.backgrounds[index];
//               final isOwned = user.ownedBackgrounds.contains(background.id);
//               final isUnlocked = user.pet.stage >= background.unlockStage;
//               final isActive = user.activeBackground == background.id;
              
//               return Card(
//                 clipBehavior: Clip.antiAlias,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Expanded(
//                       child: Stack(
//                         children: [
//                           Image.asset(
//                             background.previewAsset,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           ),
//                           if (!isUnlocked)
//                             Positioned.fill(
//                               child: Container(
//                                 color: Colors.black.withOpacity(0.7),
//                                 child: Center(
//                                   child: Text(
//                                     'Unlock at\nLevel ${background.unlockStage}',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           if (isActive)
//                             Positioned(
//                               top: 8,
//                               right: 8,
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   color: Colors.green,
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Text(
//                                   'Active',
//                                   style: TextStyle(color: Colors.white, fontSize: 12),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             background.name,
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(background.description, style: TextStyle(fontSize: 12)),
//                           SizedBox(height: 8),
//                           if (isOwned)
//                             ElevatedButton(
//                               onPressed: isActive ? null : () {
//                                 setState(() {
//                                   user.activeBackground = background.id;
//                                 });
//                                 repository.saveUser(user);
//                               },
//                               child: Text(isActive ? 'Active' : 'Activate'),
//                               style: ElevatedButton.styleFrom(
//                                 primary: Colors.blue,
//                               ),
//                             )
//                           else
//                             ElevatedButton.icon(
//                               icon: Icon(Icons.shopping_cart),
//                               label: Text('${background.cost}'),
//                               onPressed: isUnlocked ? () => _purchaseItem('background', background) : null,
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }