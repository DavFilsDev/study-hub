import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_providers.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import 'course_detail_screen.dart';

class CourseListScreen extends ConsumerWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesResultProvider);
    final filteredCourses = ref.watch(filteredCoursesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cours'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(logoutUseCaseProvider)();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (ref.watch(isOfflineProvider))
            Container(
              width: double.infinity,
              color: Colors.orange.shade700,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: const Text(
                'Mode hors ligne — données en cache',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Rechercher un cours (titre ou code)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) =>
                  ref.read(courseSearchQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: coursesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Erreur: $err')),
              data: (result) {
                final (_, failure) = result;
                if (failure != null && filteredCourses.isEmpty) {
                  return Center(child: Text(failure.message));
                }
                if (filteredCourses.isEmpty) {
                  return const Center(child: Text('Aucun cours trouvé'));
                }
                return ListView.builder(
                  itemCount: filteredCourses.length,
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    return ListTile(
                      title: Text(course.title),
                      subtitle: Text(course.code),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                CourseDetailScreen(courseId: course.id)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
