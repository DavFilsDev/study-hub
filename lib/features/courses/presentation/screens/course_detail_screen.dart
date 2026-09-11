import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/course_providers.dart';
import '../../../resources/presentation/providers/resource_providers.dart';
import '../../../../core/widgets/error_view.dart';

class CourseDetailScreen extends ConsumerWidget {
  final String courseId;
  const CourseDetailScreen({super.key, required this.courseId});

  IconData _iconForType(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'video':
        return Icons.play_circle;
      case 'link':
        return Icons.link;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseDetailProvider(courseId));
    final resourcesAsync = ref.watch(resourcesResultProvider(courseId));
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Détail du cours')),
      body: courseAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorView(
          message: 'Une erreur est survenue.',
          onRetry: () => ref.invalidate(courseDetailProvider(courseId)),
        ),
        data: (result) {
          final (course, failure) = result;
          if (course == null) {
            return ErrorView(
              message: failure?.message ?? 'Cours introuvable',
              onRetry: () => ref.invalidate(courseDetailProvider(courseId)),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.title,
                        style: Theme.of(context).textTheme.headlineSmall),
                    Text(course.code,
                        style: Theme.of(context).textTheme.bodyMedium),
                    if (course.description != null) ...[
                      const SizedBox(height: 8),
                      Text(course.description!),
                    ],
                    const SizedBox(height: 16),
                    Text('Ressources',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              Expanded(
                child: resourcesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => ErrorView(
                    message: 'Une erreur est survenue.',
                    onRetry: () =>
                        ref.invalidate(resourcesResultProvider(courseId)),
                  ),
                  data: (res) {
                    final (resources, failure) = res;
                    if (resources == null || resources.isEmpty) {
                      if (failure != null) {
                        return ErrorView(
                          message: failure.message,
                          onRetry: () =>
                              ref.invalidate(resourcesResultProvider(courseId)),
                        );
                      }
                      return const Center(child: Text('Aucune ressource'));
                    }
                    return ListView.builder(
                      itemCount: resources.length,
                      itemBuilder: (context, index) {
                        final resource = resources[index];
                        final isFav = favorites.contains(resource.id);
                        return ListTile(
                          leading: Icon(_iconForType(resource.type)),
                          title: Text(resource.title),
                          subtitle: Text(resource.type),
                          trailing: IconButton(
                            icon: Icon(isFav ? Icons.star : Icons.star_border,
                                color: isFav ? Colors.amber : null),
                            onPressed: () => ref
                                .read(favoritesProvider.notifier)
                                .toggle(resource.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
