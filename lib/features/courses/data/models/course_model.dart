import 'package:hive/hive.dart';
import '../../domain/entities/course.dart';

part 'course_model.g.dart';

@HiveType(typeId: 0)
class CourseModel extends Course {
  @HiveField(0)
  final String hiveId;
  @HiveField(1)
  final String hiveTitle;
  @HiveField(2)
  final String hiveCode;
  @HiveField(3)
  final String? hiveDescription;

  const CourseModel({
    required this.hiveId,
    required this.hiveTitle,
    required this.hiveCode,
    this.hiveDescription,
  }) : super(
            id: hiveId,
            title: hiveTitle,
            code: hiveCode,
            description: hiveDescription);

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        hiveId: json['id'] as String,
        hiveTitle: json['title'] as String,
        hiveCode: json['code'] as String,
        hiveDescription: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': hiveId,
        'title': hiveTitle,
        'code': hiveCode,
        'description': hiveDescription,
      };
}
