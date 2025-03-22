import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch the current user's document data.
  Future<Map<String, dynamic>?> fetchCurrentUser() async {
    String uid = _auth.currentUser?.uid ?? '';
    if (uid.isEmpty) return null;

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
    return userDoc.exists ? userDoc.data() as Map<String, dynamic> : null;
  }

  Stream<List<Map<String, dynamic>>> fetchLeaderboard() {
    return _firestore
        .collection('users')
        .orderBy('streak', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

Future<List<Map<String, dynamic>>> fetchFriendsLeaderboard(String currentUid) async {
  // Fetch current user data.
  DocumentSnapshot currentUserDoc =
      await _firestore.collection('users').doc(currentUid).get();
  if (!currentUserDoc.exists) return [];
  Map<String, dynamic> currentUserData =
      currentUserDoc.data() as Map<String, dynamic>;

  // Get the list of friends from the current user's document.
  List<dynamic> friends = currentUserData['friends'] ?? [];

  // Function to query a chunk of friends using the document IDs.
  Future<List<Map<String, dynamic>>> queryChunk(List<dynamic> chunk) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: chunk)
        .orderBy('streak', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        'uid': doc.id, // Include the document id.
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

  // Fetch friends data in chunks.
  List<Map<String, dynamic>> results = [];
  if (friends.isNotEmpty) {
    if (friends.length > 10) {
      for (var i = 0; i < friends.length; i += 10) {
        var chunk = friends.sublist(
          i,
          (i + 10) > friends.length ? friends.length : (i + 10),
        );
        var chunkResults = await queryChunk(chunk);
        results.addAll(chunkResults);
      }
    } else {
      results = await queryChunk(friends);
    }
  }

  // Add the current user to the leaderboard.
  results.add({
    'uid': currentUid,
    ...currentUserData,
  });

  // Sort all results by 'streak' descending.
  results.sort((a, b) => (b['streak'] ?? 0).compareTo(a['streak'] ?? 0));
  return results;
}



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchCurrentUser(),
      builder: (context, currentUserSnapshot) {
        if (currentUserSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text("Leaderboard")),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        var currentUser = currentUserSnapshot.data;
        if (currentUser == null) {
          return Scaffold(
            appBar: AppBar(title: Text("Leaderboard")),
            body: Center(child: Text("User not found")),
          );
        }

        // Create a DefaultTabController with two tabs.
        return DefaultTabController(
          length: 2,
          initialIndex: 0, // Default to the Friends tab.
          child: Scaffold(
            appBar: AppBar(
              title: Text("Leaderboard"),
              bottom: TabBar(
                tabs: [
                  Tab(text: "Friends"),
                  Tab(text: "All Users"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // Friends Leaderboard Tab
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchFriendsLeaderboard(currentUser['uid']),
                  builder: (context, friendsSnapshot) {
                    if (friendsSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    List<Map<String, dynamic>> friendsLeaderboard = friendsSnapshot.data ?? [];
                    if (friendsLeaderboard.isEmpty) {
                      return Center(child: Text("No friends found or no ranking available"));
                    }
                    return ListView.builder(
                      itemCount: friendsLeaderboard.length,
                      itemBuilder: (context, index) {
                        var friend = friendsLeaderboard[index];
                        bool isCurrentUser = friend['uid'] == currentUser['uid'];
                        return Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.blue[100] : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text('${index + 1}. '),
                              CircleAvatar(
                                backgroundImage: NetworkImage(friend['photoURL'] ?? ''),
                              ),
                              SizedBox(width: 10),
                              Expanded(child: Text(friend['displayName'] ?? '')),
                              Text('${friend['streak'] ?? 0}'),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                // All Users Leaderboard Tab
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: fetchLeaderboard(),
                  builder: (context, leaderboardSnapshot) {
                    if (leaderboardSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    List<Map<String, dynamic>> leaderboard = leaderboardSnapshot.data ?? [];
                    
                    return ListView.builder(
                      itemCount: leaderboard.length,
                      itemBuilder: (context, index) {
                        var user = leaderboard[index];
                        bool isCurrentUser = user['uid'] == currentUser['uid'];
                        return Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isCurrentUser ? Colors.blue[100] : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text('${index + 1}. '),
                              CircleAvatar(
                                backgroundImage: NetworkImage(user['photoURL'] ?? ''),
                              ),
                              SizedBox(width: 10),
                              Expanded(child: Text(user['displayName'] ?? '')),
                              Text('${user['streak'] ?? 0}'),
                            ],
                          ),
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
}
