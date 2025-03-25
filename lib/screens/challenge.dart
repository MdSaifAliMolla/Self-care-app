import 'package:flutter/material.dart';
import 'package:gsoc_smart_health_reminder/providers/challenge_provider.dart';
import 'package:gsoc_smart_health_reminder/providers/friend_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChallengePage extends StatefulWidget {
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final _titleController = TextEditingController();
  final _taskController = TextEditingController();
  final _endDateController = TextEditingController(); 
  List<String> _tasks = [];
  List<String> _selectedFriends = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Challenges'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Invitations'),
              Tab(text: 'Create'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildActiveChallengesTab(),
            _buildChallengeInvitationsTab(),
            _buildChallengeCreationTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCreationTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Challenge Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Add Task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_taskController.text.isNotEmpty) {
                      setState(() {
                        _tasks.add(_taskController.text);
                        _taskController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            // Tasks List
            Wrap(
              children: _tasks.map((task) => Chip(
                label: Text(task),
                onDeleted: () {
                  setState(() {
                    _tasks.remove(task);
                  });
                },
              )).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 30)),
                );

                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  DateTime finalEndDate = pickedTime != null
                      ? pickedDate.add(Duration(hours: pickedTime.hour, minutes: pickedTime.minute))
                      : pickedDate.add(Duration(days: 1));

                  _endDateController.text = finalEndDate.toIso8601String();
                }
              },
              child: Text('Select End Date'),
            ),
            // Select Friends to Invite
            ElevatedButton(
              onPressed: _showFriendSelectionDialog,
              child: Text('Select Friends to Invite'),
            ),
            ElevatedButton(
              onPressed: _createChallenge,
              child: Text('Create Challenge'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeInvitationsTab() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Provider.of<ChallengeProvider>(context).getChallengeInvitations(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isEmpty) {
          return Center(child: Text('No challenge invitations'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final invitation = snapshot.data![index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(invitation['creatorId'])
                  .get(),
              builder: (context, creatorSnapshot) {
                if (!creatorSnapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final creatorName = creatorSnapshot.data!['displayName'];

                return ListTile(
                  title: Text('Challenge: ${invitation['title']}'),
                  subtitle: Text('Invited by: $creatorName'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          Provider.of<ChallengeProvider>(context, listen: false)
                              .acceptChallengeInvitation(invitation['id']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          Provider.of<ChallengeProvider>(context, listen: false)
                              .rejectChallengeInvitation(invitation['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildActiveChallengesTab() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Provider.of<ChallengeProvider>(context).getActiveChallenges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isEmpty) {
          return Center(child: Text('No active challenges'));
        }

        final challenge = snapshot.data!.first; // Assuming one active challenge

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      challenge['title'],
                      //style: Theme.of(context).textTheme.headline5,
                    ),
                    const Spacer(),
                    if (challenge['creatorId'] == FirebaseAuth.instance.currentUser!.uid)
                      TextButton(
                        onPressed: () {
                          Provider.of<ChallengeProvider>(context, listen: false)
                              .deleteChallenge(challenge['id']);
                        },
                        child: Text('delete'),
                      ),
                  ],
                ),
                SizedBox(height: 16),
                // Tasks
                Text(
                  'Tasks',
                  //style: Theme.of(context).textTheme.headline6,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: (challenge['tasks'] as List).length,
                  itemBuilder: (context, index) {
                    final task = (challenge['tasks'] as List)[index];
                    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                    final isCompleted = (challenge['progress'][currentUserId]['completedTasks'] as List)
                        .contains(index.toString());

                    return CheckboxListTile(
                      title: Text(task),
                      value: isCompleted,
                      onChanged: (bool? value) {
                        Provider.of<ChallengeProvider>(context, listen: false)
                            .updateTaskCompletion(
                          challengeId: challenge['id'],
                          taskIndex: index.toString(),
                          isCompleted: value ?? false,
                        );
                      },
                    );
                  },
                ),
                // Participants Progress
                SizedBox(height: 16),
                Text(
                  'Participants Progress',
                  //style: Theme.of(context).textTheme.headline6,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: (challenge['participants'] as List).length,
                  itemBuilder: (context, index) {
                    final participantId = (challenge['participants'] as List)[index];
                    
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(participantId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        final participantName = userSnapshot.data!['displayName'];
                        final completedTasks = (challenge['progress'][participantId]['completedTasks'] as List).length;
                        final totalTasks = (challenge['tasks'] as List).length;

                        return ListTile(
                          title: Text(participantName),
                          trailing: Text('$completedTasks/$totalTasks'),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFriendSelectionDialog() {
    final friendProvider = Provider.of<FriendProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Friends to Invite'),
        content: FutureBuilder<List<Map<String, dynamic>>>(
          future: friendProvider.getFriendsList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            
            return StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: snapshot.data!.map((friend) {
                    return CheckboxListTile(
                      title: Text(friend['name']),
                      value: _selectedFriends.contains(friend['id']),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected ?? false) {
                            _selectedFriends.add(friend['id']);
                          } else {
                            _selectedFriends.remove(friend['id']);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void _createChallenge() {
    if (_titleController.text.isEmpty || _tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title and at least one task')),
      );
      return;
    }

    Provider.of<ChallengeProvider>(context, listen: false).createChallenge(
      title: _titleController.text,
      tasks: _tasks,
      invitedFriends: _selectedFriends,
      endDate: DateTime.parse(_endDateController.text),
    );

    // Reset form
    _titleController.clear();
    _tasks.clear();
    _selectedFriends.clear();
    setState(() {});
  }
}