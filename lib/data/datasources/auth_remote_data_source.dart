import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(String email, String password, String name);
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<UserModel> updateProfile({required String uid, required String displayName, required String phoneNumber});
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return await _getUserFromFirestore(user.uid) ??
        UserModel(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
          phoneNumber: user.phoneNumber,
        );
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      String emailToUse = email.trim();
      if (!emailToUse.contains('@')) {
        // Treat as username or full name
        final querySnap = await _firestore
            .collection('users')
            .where('displayName', isEqualTo: emailToUse)
            .get();
            
        if (querySnap.docs.isNotEmpty) {
          final data = querySnap.docs.first.data();
          final userEmail = data['email'] as String?;
          if (userEmail != null && userEmail.isNotEmpty) {
            emailToUse = userEmail;
          }
        } else {
          // Try case-insensitive lookup
          final allUsersSnap = await _firestore.collection('users').get();
          if (allUsersSnap.docs.isNotEmpty) {
            try {
              final matchingDoc = allUsersSnap.docs.firstWhere(
                (doc) {
                  final name = (doc.data()['displayName'] as String? ?? '').toLowerCase();
                  return name == emailToUse.toLowerCase();
                },
              );
              final userEmail = matchingDoc.data()['email'] as String?;
              if (userEmail != null && userEmail.isNotEmpty) {
                emailToUse = userEmail;
              }
            } catch (_) {
              // Fallback
              emailToUse = '$emailToUse@shopease.com';
            }
          } else {
            emailToUse = '$emailToUse@shopease.com';
          }
        }
      }

      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: emailToUse,
        password: password,
      );
      final user = credential.user!;
      final userModel = await _getUserFromFirestore(user.uid);
      if (userModel != null) return userModel;

      return UserModel(
        id: user.uid,
        email: user.email ?? emailToUse,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<UserModel> signUpWithEmail(
      String email, String password, String name) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      
      await user.updateDisplayName(name);

      final userModel = UserModel(
        id: user.uid,
        email: user.email ?? email,
        displayName: name,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );

      await _saveUserToFirestore(userModel);
      return userModel;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn.instance.authenticate();
      if (googleUser == null) {
        throw Exception('Google sign in aborted');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: null,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user!;

      UserModel? userModel = await _getUserFromFirestore(user.uid);
      
      if (userModel == null) {
        userModel = UserModel(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
          phoneNumber: user.phoneNumber,
        );
        await _saveUserToFirestore(userModel);
      }
      return userModel;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserModel> updateProfile({
    required String uid,
    required String displayName,
    required String phoneNumber,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set(
        {'displayName': displayName, 'phoneNumber': phoneNumber},
        SetOptions(merge: true),
      );
      // Also update Firebase Auth display name
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
      final updated = await _getUserFromFirestore(uid);
      return updated!;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<UserModel?> _getUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
    } catch (e) {
      // Ignore or log error
    }
    return null;
  }

  Future<void> _saveUserToFirestore(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }
}
