import 'package:hive/hive.dart';
import '../../domain/entities/resource.dart';

part 'resource_model.g.dart';

@HiveType(typeId: 1)
class ResourceModel extends Resource {
  @HiveField(0)
  final String hiveId;
  @HiveField(1)
  final String hiveCourseId;
  @HiveField(2)
  final String hiveTitle;
  @HiveField(3)
  final String hiveType;
  @HiveField(4)
  final String hiveUrl;

  const ResourceModel({
    required this.hiveId,
    required this.hiveCourseId,
    required this.hiveTitle,
    required this.hiveType,
    required this.hiveUrl,
  }) : super(
            id: hiveId,
            courseId: hiveCourseId,
            title: hiveTitle,
            type: hiveType,
            url: hiveUrl);

  factory ResourceModel.fromJson(Map<String, dynamic> json) => ResourceModel(
        hiveId: json['id'] as String,
        hiveCourseId: json['course_id'] as String,
        hiveTitle: json['title'] as String,
        hiveType: json['type'] as String,
        hiveUrl: json['url'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': hiveId,
        'course_id': hiveCourseId,
        'title': hiveTitle,
        'type': hiveType,
        'url': hiveUrl,
      };
}
