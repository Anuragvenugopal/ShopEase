import 'package:injectable/injectable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await _remoteDataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    return await _remoteDataSource.signInWithEmail(email, password);
  }

  @override
  Future<UserEntity> signUpWithEmail(
      String email, String password, String name) async {
    return await _remoteDataSource.signUpWithEmail(email, password, name);
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    return await _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    return await _remoteDataSource.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    return await _remoteDataSource.resetPassword(email);
  }

  @override
  Future<UserEntity> updateProfile({
    required String uid,
    required String displayName,
    required String phoneNumber,
  }) async {
    return await _remoteDataSource.updateProfile(
      uid: uid,
      displayName: displayName,
      phoneNumber: phoneNumber,
    );
  }
}
