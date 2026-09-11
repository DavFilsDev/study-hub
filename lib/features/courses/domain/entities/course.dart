import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String code;
  final String? description;

  const Course({
    required this.id,
    required this.title,
    required this.code,
    this.description,
  });

  @override
  List<Object?> get props => [id, title, code, description];
}
