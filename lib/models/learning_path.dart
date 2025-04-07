import 'package:edutube/models/course.dart';

class LearningPath {
  final String id;
  final String title;
  final String description;
  final List<Course> courses;
  final DateTime createdAt;

  const LearningPath({
    required this.id,
    required this.title,
    required this.description,
    required this.courses,
    required this.createdAt,
  });

  LearningPath copyWith({
    String? id,
    String? title,
    String? description,
    List<Course>? courses,
    DateTime? createdAt,
  }) {
    return LearningPath(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      courses: courses ?? this.courses,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Calculate overall progress based on courses progress
  double get progress {
    if (courses.isEmpty) return 0.0;
    final totalProgress = courses.fold(
      0.0,
      (sum, course) => sum + course.progress,
    );
    return totalProgress / courses.length;
  }
}
