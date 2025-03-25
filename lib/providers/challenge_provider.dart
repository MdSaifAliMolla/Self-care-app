import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ChallengeProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => _auth.currentUser!.uid;

  // Create a new Challenge and send invitations
  Future<void> createChallenge({
    required String title,
    required List<String> tasks,
    required List<String> invitedFriends,
    required endDate,
  }) async {
    try {
      // Create the challenge with initial creator as the only participant
      DocumentReference challengeRef = await _firestore.collection('challenges').add({
        'creatorId': userId,
        'title': title,
        'tasks': tasks,
        'participants': [userId],
        'invitations': invitedFriends,
        'startDate': FieldValue.serverTimestamp(),
        'endDate': endDate, // You can modify this as needed
        'status': 'active',
        'progress': {
          userId: {
            'completedTasks': [],
            'status': 'pending'
          }
        },
        'createdAt': FieldValue.serverTimestamp(),
      });

      notifyListeners();
    } catch (e) {
      print('Error creating challenge: $e');
    }
  }

  Future<bool> deleteChallenge(String challengeId) async {
    try {
      DocumentSnapshot challengeSnapshot = await _firestore
          .collection('challenges')
          .doc(challengeId)
          .get();

      if (challengeSnapshot.get('creatorId') != userId) {
        print('Only the challenge creator can delete the challenge');
        return false;
      }

      await _firestore.collection('challenges').doc(challengeId).delete();
      
      notifyListeners();
      return true;
    } catch (e) {
      print('Error deleting challenge: $e');
      return false;
    }
  }

  Future<void> removeExpiredChallenges() async {
    try {
      final now = DateTime.now();

      QuerySnapshot expiredChallenges = await _firestore
          .collection('challenges')
          .where('endDate', isLessThan: Timestamp.fromDate(now))
          .where('status', isEqualTo: 'active')
          .get();

      WriteBatch batch = _firestore.batch();

      for (var doc in expiredChallenges.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      notifyListeners();
    } catch (e) {
      print('Error removing expired challenges: $e');
    }
  }

  // Accept Challenge Invitation
  Future<void> acceptChallengeInvitation(String challengeId) async {
    DocumentReference challengeRef = _firestore.collection('challenges').doc(challengeId);
    
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot challengeSnapshot = await transaction.get(challengeRef);
      
      // Remove user from invitations
      List<dynamic> invitations = challengeSnapshot.get('invitations') ?? [];
      invitations.remove(userId);
      
      // Add user to participants
      List<dynamic> participants = challengeSnapshot.get('participants') ?? [];
      if (!participants.contains(userId)) {
        participants.add(userId);
      }
      
      // Initialize progress for the user
      Map<String, dynamic> progress = Map<String, dynamic>.from(
        challengeSnapshot.get('progress') ?? {}
      );
      
      progress[userId] = {
        'completedTasks': [],
        'status': 'pending'
      };
      
      // Update the challenge
      transaction.update(challengeRef, {
        'invitations': invitations,
        'participants': participants,
        'progress': progress
      });
    });
    
    notifyListeners();
  }

  // Reject Challenge Invitation
  Future<void> rejectChallengeInvitation(String challengeId) async {
    await _firestore.collection('challenges').doc(challengeId).update({
      'invitations': FieldValue.arrayRemove([userId])
    });
    
    notifyListeners();
  }

  // Stream of Challenge Invitations
  Stream<List<Map<String, dynamic>>> getChallengeInvitations() {
    return _firestore
        .collection('challenges')
        .where('invitations', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'id': doc.id,
                ...doc.data()
              };
            }).toList());
  }

  // Stream of Active Challenges (where user is a participant)
  Stream<List<Map<String, dynamic>>> getActiveChallenges() {
    return _firestore
        .collection('challenges')
        .where('participants', arrayContains: userId)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'id': doc.id,
                ...doc.data()
              };
            }).toList());
  }

  Future<void> updateTaskCompletion({
    required String challengeId,
    required String taskIndex,
    required bool isCompleted,
  }) async {
    DocumentReference challengeRef = _firestore.collection('challenges').doc(challengeId);
    
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot challengeSnapshot = await transaction.get(challengeRef);
      
      Map<String, dynamic> progress = Map<String, dynamic>.from(
        challengeSnapshot.get('progress') ?? {}
      );
      
      List<dynamic> completedTasks = progress[userId]['completedTasks'] ?? [];
      
      if (isCompleted && !completedTasks.contains(taskIndex)) {
        completedTasks.add(taskIndex);
      } else if (!isCompleted) {
        completedTasks.remove(taskIndex);
      }
      
      progress[userId]['completedTasks'] = completedTasks;
      
      // Check if all tasks are completed
      List<dynamic> challengeTasks = challengeSnapshot.get('tasks');
      if (completedTasks.length == challengeTasks.length) {
        progress[userId]['status'] = 'completed';
        
        // Add 10 coins to Hive box
        final coinsBox = await Hive.openBox('coins');
        int currentCoins = coinsBox.get(userId, defaultValue: 0);
        await coinsBox.put(userId, currentCoins + 10);
      }
      
      transaction.update(challengeRef, {'progress': progress});
    });
    
    notifyListeners();
  }

}