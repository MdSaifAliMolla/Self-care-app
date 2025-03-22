import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/pet/pet_store.dart';
import 'package:gsoc_smart_health_reminder/pet/shop_item.dart';
import 'package:gsoc_smart_health_reminder/pet/pet_provider.dart.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PetStore store;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final userProvider =
        Provider.of<UserProvider>(context, listen: false);
    store = userProvider.store;
  }

  Future<void> _purchaseItem(String itemType, StoreItem item) async {
    final userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.purchaseItem(itemType, item);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.name} purchased successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Cannot purchase ${item.name}. Check your coins or pet level.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to user changes.
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Store'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Micropets'),
            Tab(text: 'Backgrounds'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${user.coins}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Micropets tab
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: store.micropets.length,
            itemBuilder: (context, index) {
              final micropet = store.micropets[index];
              final isOwned = user.ownedMicropets.contains(micropet.id);
              final isUnlocked = user.pet.stage >= micropet.unlockStage;

              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Image.asset(
                            micropet.previewAsset,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          if (!isUnlocked)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.7),
                                child: Center(
                                  child: Text(
                                    'Unlock at\nLevel ${micropet.unlockStage}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            micropet.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          Text(micropet.description,
                              style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 8),
                          if (isOwned)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (user.activeMicropets
                                      .contains(micropet.id)) {
                                    user.activeMicropets
                                        .remove(micropet.id);
                                  } else {
                                    user.activeMicropets
                                        .add(micropet.id);
                                  }
                                });
                                userProvider.saveUser();
                              },
                              child: Text(user.activeMicropets
                                      .contains(micropet.id)
                                  ? 'Deactivate'
                                  : 'Activate'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: user.activeMicropets
                                        .contains(micropet.id)
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            )
                          else
                            ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_cart),
                              label: Text('${micropet.cost}'),
                              onPressed: isUnlocked
                                  ? () =>
                                      _purchaseItem('micropet', micropet)
                                  : null,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Backgrounds tab
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: store.backgrounds.length,
            itemBuilder: (context, index) {
              final background = store.backgrounds[index];
              final isOwned =
                  user.ownedBackgrounds.contains(background.id);
              final isUnlocked =
                  user.pet.stage >= background.unlockStage;
              final isActive =
                  user.activeBackground == background.id;

              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Image.asset(
                            background.previewAsset,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          if (!isUnlocked)
                            Positioned.fill(
                              child: Container(
                                color:
                                    Colors.black.withOpacity(0.7),
                                child: Center(
                                  child: Text(
                                    'Unlock at\nLevel ${background.unlockStage}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          if (isActive)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Active',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            background.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          Text(background.description,
                              style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 8),
                          if (isOwned)
                            ElevatedButton(
                              onPressed: isActive
                                  ? null
                                  : () {
                                      setState(() {
                                        user.activeBackground =
                                            background.id;
                                      });
                                      userProvider.saveUser();
                                    },
                              child: Text(
                                  isActive ? 'Active' : 'Activate'),
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.blue),
                            )
                          else
                            ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_cart),
                              label: Text('${background.cost}'),
                              onPressed: isUnlocked
                                  ? () => _purchaseItem(
                                      'background', background)
                                  : null,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
