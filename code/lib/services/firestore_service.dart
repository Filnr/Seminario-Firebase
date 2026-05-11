import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required User user,
    required String name,
  }) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'name': name,
        'email': user.email,
        'photoUrl': user.photoURL,
        'role': 'user',
        'createdAt': Timestamp.now(),
      });
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserProfileStream(
    String uid,
  ) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(
    String uid,
  ) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> updateUserName({
    required String uid,
    required String newName,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'name': newName,
    });
  }
}