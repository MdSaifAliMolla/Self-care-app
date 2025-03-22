import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/models/music._model.dart';
import 'package:gsoc_smart_health_reminder/providers/music_player_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/music_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/wallet_provider.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MeditationSoundStore extends StatefulWidget {
  @override
  _MeditationSoundStoreState createState() => _MeditationSoundStoreState();
}

class _MeditationSoundStoreState extends State<MeditationSoundStore> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<MeditationSoundProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);

    final displaySounds = _selectedCategory == 'All'
        ? soundProvider.sounds
        : soundProvider.getSoundsByCategory(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: Text('Music Store'),
        actions: [
          Chip(
            label: Text('${Hive.box('coinBox').get('coins', defaultValue: 0)} 🪙'),
            backgroundColor: Colors.amber[100],
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...['All', 'Ambient','Instrumental'].map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          // Sound List
          Expanded(
            child: ListView.builder(
              itemCount: displaySounds.length,
              itemBuilder: (context, index) {
                final sound = displaySounds[index];

                return ListTile(
                  title: Text(sound.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer<WalletProvider>(
                        builder: (context, walletProvider, child) {
                          final isPurchased =
                              walletProvider.isSoundPurchased(sound.title);
                          if (!isPurchased) {
                            return Text('${sound.cost} 🪙');
                          } else {
                            return Consumer<MusicPlayerProvider>(
                              builder: (context, musicPlayerProvider, child) {
                                final isCurrentSound =
                                    musicPlayerProvider.currentSound?.id == sound.id;
                                return IconButton(
                                  icon: Icon(
                                    isCurrentSound && musicPlayerProvider.isPlaying
                                        ? Icons.pause_circle_outline
                                        : Icons.play_circle_outline,
                                  ),
                                  onPressed: () {
                                    if (isCurrentSound && musicPlayerProvider.isPlaying) {
                                      musicPlayerProvider.pauseSound();
                                    } else {
                                      musicPlayerProvider.playSound(sound);
                                    }
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: walletProvider.isSoundPurchased(sound.title)
                      ? null
                      : () => _showPurchaseDialog(context, sound),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, MeditationSound sound) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase Sound'),
        content: Text(
            'Do you want to purchase "${sound.title}" for ${sound.cost} coins?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (walletProvider.canPurchase(sound.cost)) {
                walletProvider.purchaseSound(sound);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sound purchased successfully!')),
                );
              } else {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Not enough coins!')),
                );
              }
            },
            child: Text('Purchase'),
          ),
        ],
      ),
    );
  }
}
