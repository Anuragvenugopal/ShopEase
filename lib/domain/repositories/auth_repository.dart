import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(String email, String password, String name);
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<UserEntity> updateProfile({required String uid, required String displayName, required String phoneNumber});
}
