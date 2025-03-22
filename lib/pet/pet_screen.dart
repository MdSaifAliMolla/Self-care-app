// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:gsoc_smart_health_reminder/pet/user_provider.dart.dart';
// import 'package:provider/provider.dart';
// import 'package:gsoc_smart_health_reminder/pet/pet_widget.dart';
// import 'package:gsoc_smart_health_reminder/pet/store_screen.dart';

// class PetScreen extends StatelessWidget {
//   const PetScreen({Key? key}) : super(key: key);

//   Future<void> _upgradePet(BuildContext context) async {
//     // Call the provider's upgrade method
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final success = await userProvider.upgradePet();
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Pet upgraded!')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Not enough coins to upgrade your pet!')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Listen to the provider for user updates
//     final userProvider = Provider.of<UserProvider>(context);
//     final user = userProvider.user;
//     final store = userProvider.store;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Pet'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 const Icon(Icons.monetization_on, color: Colors.amber),
//                 const SizedBox(width: 4),
//                 Text('${user.coins}',
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/backgrounds/grass.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Main pet widget in the center
//           Center(
//             child: PetWidget(
//               pet: user.pet,
//               onTap: () {
//                 // Increase pet mood (capped at 100) and update last interaction
//                // userProvider.increaseMood();
//               },
//             ),
//           ),
//           // Pet info panel at the top left
//           Positioned(
//             top: 20,
//             left: 20,
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.8),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Level ${user.pet.stage}',
//                       style: const TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(Icons.favorite, color: Colors.red, size: 16),
//                       const SizedBox(width: 4),
//                       Text('Mood: ${user.pet.mood}%'),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Upgrade button at the bottom right
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: ElevatedButton.icon(
//               icon: const Icon(Icons.arrow_upward),
//               label: Text(
//                 'Upgrade (${store.petUpgradeCosts[user.pet.stage + 1] ?? 'Max'})',
//               ),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.green,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 16, vertical: 12),
//               ),
//               onPressed:
//                   user.pet.stage < 5 ? () => _upgradePet(context) : null,
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pet'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart), label: 'Store'),
//           BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Tasks'),
//         ],
//         onTap: (index) {
//           if (index == 1) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => StoreScreen(),
//               ),
//             );
//           } else if (index == 2) {
//             // Navigate to tasks screen if available.
//           }
//         },
//       ),
//     );
//   }
// }
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/pet/pet_provider.dart.dart';
import 'package:gsoc_smart_health_reminder/providers/daily_streak_provider.dart';
import 'package:provider/provider.dart';
import 'package:gsoc_smart_health_reminder/pet/pet_widget.dart';
import 'package:gsoc_smart_health_reminder/pet/store_screen.dart';


class PetScreen extends StatefulWidget {
  const PetScreen({Key? key}) : super(key: key);

  @override
  _PetScreenState createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  // Local state for active micropets positions, keyed by micropet id.
  Map<String, Offset> micropetPositions = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (micropetPositions.isEmpty && user.activeMicropets.isNotEmpty) {
      for (int i = 0; i < user.activeMicropets.length; i++) {
        
        micropetPositions[user.activeMicropets[i]] =
            Offset(50 + i * 100.0, 50);
      }
    }
  }

  void _updateMicropetPosition(String id, Offset newOffset) {
    setState(() {
      micropetPositions[id] = newOffset;
    });
    // Optionally: persist these positions via your provider.
  }
  int _mood=100;

  Future<void> _upgradePet(BuildContext context) async {
    final userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.upgradePet();
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet upgraded!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Not enough coins to upgrade your pet!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to user changes via the provider.
    final userProvider = Provider.of<UserProvider>(context);
    final prov = Provider.of<DailyStreakProvider>(context);
    final user = userProvider.user;
    final store = userProvider.store;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('My Pet'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('🪙'),
                const SizedBox(width: 4),
                Text('${user.coins}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image fills the screen.
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/grass.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Main pet widget centered.
          Center(
            child: PetWidget(
              pet: user.pet,
              onTap: () {
                // Optionally, add interaction logic (e.g., increase mood)
              },
            ),
          ),
          // Pet info panel in the top-left corner.
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Level ${user.pet.stage}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text('Mood: ${(prov.getProgress()*100).toInt()}%'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Upgrade button in the bottom-right corner.
          Positioned(
            bottom: 20,
            right: 200,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_upward),
              label: Text(
                'Upgrade (${store.petUpgradeCosts[user.pet.stage + 1] ?? 'Max'})',
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
              onPressed: user.pet.stage < 5
                  ? () => _upgradePet(context)
                  : null,
            ),
          ),
          // Active micropets overlay
          ...micropetPositions.entries.map((entry) {
            final micropetId = entry.key;
            final offset = entry.value;
            // Retrieve micropet details from the store using its ID.
            final storeItem = store.micropets.firstWhere(
              (mp) => mp.id == micropetId,
              orElse: () => store.micropets.first,
            );
            return Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Draggable<String>(
                data: micropetId,
                feedback: Opacity(
                  opacity: 0.7,
                  child: Image.asset(
                    storeItem.previewAsset,
                    width: 150,
                    height: 150,
                  ),
                ),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  final RenderBox box =
                      context.findRenderObject() as RenderBox;
                  final localPosition = box.globalToLocal(details.offset);
                  _updateMicropetPosition(micropetId, localPosition);
                },
                child: Image.asset(
                  storeItem.previewAsset,
                  width: 150,
                  height: 150,
                ),
              ),
            );
          }).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.store),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StoreScreen())),
      ),
    );
  }
}
