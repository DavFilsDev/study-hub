import 'package:hive_flutter/hive_flutter.dart';
import '../../features/courses/data/models/course_model.dart';
import '../../features/resources/data/models/resource_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CourseModelAdapter());
  Hive.registerAdapter(ResourceModelAdapter());
}
