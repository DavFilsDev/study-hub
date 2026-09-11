import 'package:equatable/equatable.dart';

class Resource extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String type; // pdf, link, video, doc
  final String url;

  const Resource({
    required this.id,
    required this.courseId,
    required this.title,
    required this.type,
    required this.url,
  });

  @override
  List<Object?> get props => [id, courseId, title, type, url];
}
