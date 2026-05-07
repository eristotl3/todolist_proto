import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/auth_repository.dart';
import '../../domain/user_profile.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<UserProfile?> build() async {
    final repo = ref.watch(authRepositoryProvider);
    // Skip initialSession (fires immediately on subscribe) and signedIn
    // (handled directly by signIn() to avoid a race where build() and signIn()
    // both fetch the profile concurrently and the later one overwrites the state).
    final sub = repo.authStateChanges.listen((event) {
      if (event.event != AuthChangeEvent.initialSession &&
          event.event != AuthChangeEvent.signedIn) {
        ref.invalidateSelf();
      }
    });
    ref.onDispose(sub.cancel);
    return await repo.getCurrentProfile();
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signUp(
            email: email,
            password: password,
            fullName: fullName,
            role: role,
          ),
    );
  }

  Future<void> signOut() async {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } catch (_) {
      // Supabase signOut can fail on network errors; still clear local state
      // so the router redirects to the login screen.
    }
    state = const AsyncData(null);
  }
}
