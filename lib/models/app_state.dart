import 'package:flutter/foundation.dart';
import 'package:edutube/models/course.dart';
import 'package:edutube/models/learning_path.dart';
import 'package:edutube/utils/storage_helper.dart';
import 'package:edutube/services/course_service.dart';

class AppState extends ChangeNotifier {
  // ... (rest of your AppState class)
  List<Course> _courses = [];
  List<Course> _myCourses = [];
  List<LearningPath> _learningPaths = [];
  List<String> _recentSearches = [];

  List<Course> get courses => _courses;
  List<Course> get myCourses => _myCourses;
  List<LearningPath> get learningPaths => _learningPaths;
  List<String> get recentSearches => _recentSearches;

  AppState() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      _courses = await CourseService.fetchCourses();
    } catch (e) {
      print('Error loading courses: $e');
      _courses = [];
    }

    _myCourses = await StorageHelper.loadMyCourses();
    _learningPaths = await StorageHelper.loadLearningPaths();
    _recentSearches = await StorageHelper.loadRecentSearches();

    notifyListeners();
  }

  Future<void> loadData() async {
    _myCourses = await StorageHelper.loadMyCourses();
    _learningPaths = await StorageHelper.loadLearningPaths();
    _recentSearches = await StorageHelper.loadRecentSearches();
    notifyListeners();
  }

  void addCourseToMyCourses(Course course) {
    if (!_myCourses.any((c) => c.id == course.id)) {
      _myCourses.add(course);
      StorageHelper.saveMyCourses(_myCourses);
      notifyListeners();
    }
  }

  void removeCourseFromMyCourses(String courseId) {
    _myCourses.removeWhere((course) => course.id == courseId);
    StorageHelper.saveMyCourses(_myCourses);
    notifyListeners();
  }

  Future<void> markVideoAsWatched(String courseId, String videoId) async {
    try {
      final success = await CourseService.markVideoAsWatched(courseId, videoId);
      if (success) {
        final courseIndex = _myCourses.indexWhere((c) => c.id == courseId);
        if (courseIndex != -1) {
          final videoIndex = _myCourses[courseIndex].videos.indexWhere(
            (v) => v.id == videoId,
          );
          if (videoIndex != -1) {
            _myCourses[courseIndex].videos[videoIndex] = _myCourses[courseIndex]
                .videos[videoIndex]
                .copyWith(watched: true);

            // Update progress
            final watchedCount =
                _myCourses[courseIndex].videos.where((v) => v.watched).length;
            final newProgress =
                (watchedCount / _myCourses[courseIndex].videos.length) * 100;
            _myCourses[courseIndex] = _myCourses[courseIndex].copyWith(
              progress: newProgress,
            );

            await StorageHelper.saveMyCourses(_myCourses);
            notifyListeners();
          }
        }
      }
    } catch (e) {
      print('Error marking video as watched: $e');
    }
  }

  void addLearningPath(LearningPath learningPath) {
    _learningPaths.add(learningPath);
    StorageHelper.saveLearningPaths(_learningPaths);
    notifyListeners();
  }

  void removeLearningPath(String pathId) {
    _learningPaths.removeWhere((path) => path.id == pathId);
    StorageHelper.saveLearningPaths(_learningPaths);
    notifyListeners();
  }

  void addRecentSearch(String query) {
    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
      StorageHelper.saveRecentSearches(_recentSearches);
      notifyListeners();
    }
  }

  void removeRecentSearch(String query) {
    _recentSearches.remove(query);
    StorageHelper.saveRecentSearches(_recentSearches);
    notifyListeners();
  }
}
