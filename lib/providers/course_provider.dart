import 'package:flutter/foundation.dart';
import 'package:edutube/models/course.dart';
import 'package:edutube/services/course_service.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all courses
  Future<void> fetchCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await CourseService.fetchCourses();
    } catch (e) {
      _error = 'Failed to load courses: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get course by ID
  Future<Course?> getCourseById(String id) async {
    try {
      // First check if the course is already loaded
      Course? course = _courses.firstWhere((c) => c.id == id);
      return course;
    } catch (e) {
      // If not found locally, fetch from API
      return await CourseService.fetchCourseById(id);
    }
  }

  // Update course progress
  Future<void> updateCourseProgress(String courseId, double progress) async {
    try {
      final success = await CourseService.updateCourseProgress(
        courseId,
        progress,
      );

      if (success) {
        final index = _courses.indexWhere((c) => c.id == courseId);
        if (index != -1) {
          _courses[index] = _courses[index].copyWith(progress: progress);
          notifyListeners();
        }
      }
    } catch (e) {
      _error = 'Failed to update course progress: $e';
      notifyListeners();
    }
  }

  // Mark video as watched
  Future<void> markVideoAsWatched(String courseId, String videoId) async {
    try {
      final success = await CourseService.markVideoAsWatched(courseId, videoId);

      if (success) {
        final courseIndex = _courses.indexWhere((c) => c.id == courseId);
        if (courseIndex != -1) {
          final course = _courses[courseIndex];
          final updatedVideos =
              course.videos.map((video) {
                if (video.id == videoId) {
                  return video.copyWith(watched: true);
                }
                return video;
              }).toList();

          _courses[courseIndex] = course.copyWith(videos: updatedVideos);

          // Update progress
          final watchedCount = updatedVideos.where((v) => v.watched).length;
          final newProgress = (watchedCount / updatedVideos.length) * 100;
          _courses[courseIndex] = _courses[courseIndex].copyWith(
            progress: newProgress,
          );

          notifyListeners();
        }
      }
    } catch (e) {
      _error = 'Failed to mark video as watched: $e';
      notifyListeners();
    }
  }
}
