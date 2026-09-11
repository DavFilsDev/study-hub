import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studyhub/features/auth/data/repositories/auth_repository_impl.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  late MockSupabaseClient client;
  late MockGoTrueClient auth;
  late AuthRepositoryImpl repository;

  setUp(() {
    client = MockSupabaseClient();
    auth = MockGoTrueClient();
    when(() => client.auth).thenReturn(auth);
    repository = AuthRepositoryImpl(client);
  });

  test('login retourne un AppUser quand signInWithPassword réussit', () async {
    final user = MockUser();
    when(() => user.id).thenReturn('u1');
    when(() => user.email).thenReturn('test@studyhub.com');
    final response = MockAuthResponse();
    when(() => response.user).thenReturn(user);

    when(() => auth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => response);

    final result = await repository.login('test@studyhub.com', 'password123');

    expect(result.id, 'u1');
    expect(result.email, 'test@studyhub.com');
  });

  test('login lance une exception quand user est null (identifiants invalides)',
      () async {
    final response = MockAuthResponse();
    when(() => response.user).thenReturn(null);
    when(() => auth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => response);

    expect(
        () => repository.login('bad@studyhub.com', 'wrong'), throwsException);
  });

  test('logout appelle signOut sur le client Supabase', () async {
    when(() => auth.signOut()).thenAnswer((_) async {});

    await repository.logout();

    verify(() => auth.signOut()).called(1);
  });
}
