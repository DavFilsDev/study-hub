import '../../../../core/error/failures.dart';
import '../entities/resource.dart';

abstract class ResourceRepository {
  Future<(List<Resource>?, Failure?)> getResourcesByCourse(String courseId);
}
