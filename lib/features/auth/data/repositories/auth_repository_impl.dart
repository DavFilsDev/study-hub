import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;
  AuthRepositoryImpl(this._client);

  AppUser _mapUser(User user) => AppUser(id: user.id, email: user.email ?? '');

  @override
  Future<AppUser> login(String email, String password) async {
    final res =
        await _client.auth.signInWithPassword(email: email, password: password);
    if (res.user == null) throw Exception('Identifiants invalides');
    return _mapUser(res.user!);
  }

  @override
  Future<AppUser> register(String email, String password) async {
    final res = await _client.auth.signUp(email: email, password: password);
    if (res.user == null) throw Exception('Inscription échouée');
    return _mapUser(res.user!);
  }

  @override
  Future<void> logout() => _client.auth.signOut();

  @override
  AppUser? get currentUser {
    final user = _client.auth.currentUser;
    return user == null ? null : _mapUser(user);
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      return user == null ? null : _mapUser(user);
    });
  }
}
