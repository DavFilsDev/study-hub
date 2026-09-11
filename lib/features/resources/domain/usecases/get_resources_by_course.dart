import '../../../../core/error/failures.dart';
import '../entities/resource.dart';
import '../repositories/resource_repository.dart';

class GetResourcesByCourse {
  final ResourceRepository repository;
  GetResourcesByCourse(this.repository);

  Future<(List<Resource>?, Failure?)> call(String courseId) =>
      repository.getResourcesByCourse(courseId);
}
