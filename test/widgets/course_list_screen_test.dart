import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studyhub/features/auth/domain/usecases/logout_usecase.dart';
import 'package:studyhub/features/auth/presentation/providers/auth_providers.dart';
import 'package:studyhub/features/courses/domain/entities/course.dart';
import 'package:studyhub/features/courses/presentation/providers/course_providers.dart';
import 'package:studyhub/features/courses/presentation/screens/course_list_screen.dart';

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  const courses = [
    Course(id: '1', title: 'Algorithmique', code: 'ALG101'),
    Course(id: '2', title: 'Bases de données', code: 'BDD201'),
  ];

  Widget buildTestable() {
    return ProviderScope(
      overrides: [
        coursesResultProvider.overrideWith((ref) async => (courses, null)),
        logoutUseCaseProvider.overrideWithValue(MockLogoutUseCase()),
      ],
      child: const MaterialApp(home: CourseListScreen()),
    );
  }

  testWidgets('affiche la liste des cours retournés par le provider',
      (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    expect(find.text('Algorithmique'), findsOneWidget);
    expect(find.text('Bases de données'), findsOneWidget);
  });

  testWidgets('filtre la liste quand on tape dans la recherche',
      (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'ALG');
    await tester.pumpAndSettle();

    expect(find.text('Algorithmique'), findsOneWidget);
    expect(find.text('Bases de données'), findsNothing);
  });
}
