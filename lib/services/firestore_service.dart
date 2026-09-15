import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/asset_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<AssetModel>> getAssets() {
    return _firestore.collection('assets').snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return AssetModel.fromMap(
              doc.data(),
              doc.id,
            );
          },
        ).toList();
      },
    );
  }

  Future<void> createUserProfile({
    required User user,
    required String name,
  }) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
