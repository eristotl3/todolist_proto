import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/user_profile.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository();

class AuthRepository {
  final _client = Supabase.instance.client;

  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'role': role.name},
      );
      if (response.user == null) {
        throw const AppException('Sign-up failed: no user returned');
      }
      return await _fetchProfile(response.user!.id);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Sign-up failed', cause: e);
    }
  }

  Future<UserProfile> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const AppException('Sign-in failed: no user returned');
      }
      return await _fetchProfile(response.user!.id);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException('Sign-in failed', cause: e);
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<UserProfile?> getCurrentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return await _fetchProfile(user.id);
  }

  Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  Future<UserProfile> _fetchProfile(String userId) async {
    final data = await _client
        .from(AppConstants.profilesTable)
        .select()
        .eq('id', userId)
        .single();
    return UserProfile.fromJson(data);
  }
}
