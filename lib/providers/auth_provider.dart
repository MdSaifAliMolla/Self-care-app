import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Box _authBox = Hive.box('authBox');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthProvider() {
    _loadUserFromCache();
    _syncStreak();
  }

  User? _currentUser;

  User? get currentUser => _currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  void _loadUserFromCache() {
    if (_authBox.containsKey('uid')) {
      _currentUser = UserData(
        uid: _authBox.get('uid'),
        email: _authBox.get('email'),
        displayName: _authBox.get('displayName'),
        photoURL: _authBox.get('photoURL'),
      ).toFirebaseUser();
      notifyListeners();
    }
  }

  /// Sign in with Google and cache user data
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      _currentUser = userCredential.user;

      if (_currentUser != null) {
        _cacheUserData(_currentUser!);
        await _saveUserToFirestore(_currentUser!);
        notifyListeners();
      }

      return userCredential;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  /// Cache user data in Hive
  void _cacheUserData(User user) {
    _authBox.put('uid', user.uid);
    _authBox.put('email', user.email);
    _authBox.put('displayName', user.displayName);
    _authBox.put('photoURL', user.photoURL);
  }

   Future<void> _saveUserToFirestore(User user) async {
    final userRef = _firestore.collection('users').doc(user.uid);

    final userData = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? 'User',
      'photoURL': user.photoURL ?? '',
      'streak': 0,
      'lastLogin': FieldValue.serverTimestamp(),
    };

    await userRef.set(userData, SetOptions(merge: true)); // Merge to avoid overwriting
  }

  Future<void> _syncStreak() async {
    if (_currentUser == null) return;
    
    final userRef = _firestore.collection('users').doc(_currentUser!.uid);
    final doc = await userRef.get();

    int firestoreStreak = doc.exists ? (doc.data()?['streak'] ?? 0) : 0;
    int localStreak = Hive.box('dailyStreakBox').get('streak', defaultValue: 0);

    if (localStreak > firestoreStreak) {
      await userRef.update({'streak': localStreak});
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _authBox.clear();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
  

}

/// Helper class to convert Hive data to Firebase User-like object
class UserData {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  UserData({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

  /// Converts stored user data to a Firebase User-like object
  User? toFirebaseUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
