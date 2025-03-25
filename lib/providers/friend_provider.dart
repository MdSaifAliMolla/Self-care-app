import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get userId => _auth.currentUser!.uid;
  
  /// Search users by name
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final result = await _firestore
        .collection('users')
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    
    return result.docs.map((doc) => {
      'id': doc.id,
      'name': doc['displayName'],
    }).toList();
  }

  /// Send Friend Request
  Future<void> sendFriendRequest(String friendId) async {
    await _firestore.collection('users').doc(userId).update({
      'friendRequests.sent': FieldValue.arrayUnion([{
        'id': friendId,
        'name': (await _firestore.collection('users').doc(friendId).get()).data()?['displayName'],
    }])
    });
    await _firestore.collection('users').doc(friendId).update({
      'friendRequests.received': FieldValue.arrayUnion([{
        'id': userId,
        'name': _auth.currentUser!.displayName.toString(),
    }])
    });

    //notify friends about the request

    notifyListeners();
  }

  /// Accept Friend Request
  Future<void> acceptFriendRequest(String friendId) async {
    await _firestore.collection('users').doc(userId).update({
      'friends': FieldValue.arrayUnion([friendId]),
      'friendRequests.received': FieldValue.arrayRemove([
        {
          'id': friendId,
          'name': (await _firestore.collection('users').doc(friendId).get()).data()?['displayName'],
        }
      ])
    });

    await _firestore.collection('users').doc(friendId).update({
      'friends': FieldValue.arrayUnion([userId]),
      'friendRequests.sent': FieldValue.arrayRemove([
        {
          'id': userId,
          'name': _auth.currentUser!.displayName.toString(),
        }
      ])
    });
    //notify friends about the request

    notifyListeners();
  }

  /// Reject Friend Request
  Future<void> rejectFriendRequest(String friendId) async {
    await _firestore.collection('users').doc(userId).update({
      'friendRequests.received': FieldValue.arrayRemove([
        {
          'id': friendId,
          'name': (await _firestore.collection('users').doc(friendId).get()).data()?['displayName'],
        }
      ])
    });

    await _firestore.collection('users').doc(friendId).update({
      'friendRequests.sent': FieldValue.arrayRemove([
        {
          'id': userId,
          'name': _auth.currentUser!.displayName.toString(),
        }
      ])
    });
    //notify friends about the request

    notifyListeners();
  }

  /// delete friend request
  Future<void> deleteFriendRequest(String friendId) async {
    await _firestore.collection('users').doc(userId).update({
      'friendRequests.sent': FieldValue.arrayRemove([
        {
          'id': friendId,
          'name': (await _firestore.collection('users').doc(friendId).get()).data()?['displayName'],
        }
      ])
    });

    await _firestore.collection('users').doc(friendId).update({
      'friendRequests.received': FieldValue.arrayRemove([
        {
          'id': userId,
          'name': _auth.currentUser!.displayName.toString(),
        }
      ])
    });

    notifyListeners();}

  /// Fetch Pending Friend Requests
  Stream<List<Map<String,dynamic>>> getReceivedRequests() {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      return List<Map<String,dynamic>>.from(doc.data()?['friendRequests']['received'] ?? []);
    });
  }

  ///Fetch sent requests
  Stream<List<Map<String,dynamic>>> getSentRequests() {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      return List<Map<String,dynamic>>.from(doc.data()?['friendRequests']['sent'] ?? []);
    });
  }

  Future<List<Map<String, dynamic>>> getFriendsList() async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    
    List<dynamic> friendIds = userDoc.get('friends') ?? [];
    
    if (friendIds.isEmpty) {
      return [];
    }
    List<Map<String, dynamic>> friends = [];
    
    for (String friendId in friendIds) {
      try {
        DocumentSnapshot friendDoc = await _firestore.collection('users').doc(friendId).get();

        friends.add({
          'id': friendId,
          'name': friendDoc.get('displayName') ?? 'Unknown',
        });
      } catch (e) {
        print('Error fetching friend details: $e');
      }
    }
    
    return friends;
  }
}
