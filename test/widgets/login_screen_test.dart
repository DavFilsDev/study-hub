import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyhub/features/auth/domain/usecases/login_usecase.dart';
import 'package:studyhub/features/auth/presentation/providers/auth_providers.dart';
import 'package:studyhub/features/auth/presentation/screens/login_screen.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase mockLogin;

  setUp(() => mockLogin = MockLoginUseCase());

  Widget buildTestable() {
    return ProviderScope(
      overrides: [loginUseCaseProvider.overrideWithValue(mockLogin)],
      child: const MaterialApp(home: LoginScreen()),
    );
  }

  testWidgets('affiche les champs email, mot de passe et le bouton connexion',
      (tester) async {
    await tester.pumpWidget(buildTestable());

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('affiche un message d\'erreur quand le login échoue',
      (tester) async {
    when(() => mockLogin(any(), any()))
        .thenThrow(Exception('invalid credentials'));

    await tester.pumpWidget(buildTestable());
    await tester.enterText(find.byType(TextField).first, 'test@studyhub.com');
    await tester.enterText(find.byType(TextField).last, 'wrongpass');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Email ou mot de passe incorrect.'), findsOneWidget);
  });
}
