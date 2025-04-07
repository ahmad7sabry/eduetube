import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edutube/models/course.dart';
import 'package:edutube/models/learning_path.dart';

class StorageHelper {
  static const String _myCoursesKey = 'my_courses';
  static const String _learningPathsKey = 'learning_paths';
  static const String _recentSearchesKey = 'recent_searches';

  // Save My Courses
  static Future<void> saveMyCourses(List<Course> courses) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(
      courses
          .map(
            (course) => {
              'id': course.id,
              'title': course.title,
              'description': course.description,
              'author': course.author,
              'thumbnailUrl': course.thumbnailUrl,
              'categories': course.categories,
              'progress': course.progress,
              'videos':
                  course.videos
                      .map(
                        (video) => {
                          'id': video.id,
                          'title': video.title,
                          'description': video.description,
                          'youtubeId': video.youtubeId,
                          'watched': video.watched,
                        },
                      )
                      .toList(),
            },
          )
          .toList(),
    );
    await prefs.setString(_myCoursesKey, jsonData);
  }

  // Load My Courses
  static Future<List<Course>> loadMyCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_myCoursesKey);
      if (jsonData == null) return [];
      final List<dynamic> decodedData = jsonDecode(jsonData);
      return decodedData
          .map(
            (item) => Course(
              id: item['id'],
              title: item['title'],
              description: item['description'],
              author: item['author'],
              thumbnailUrl: item['thumbnailUrl'],
              categories: List<String>.from(item['categories']),
              progress: item['progress'],
              videos:
                  (item['videos'] as List)
                      .map(
                        (v) => Video(
                          id: v['id'],
                          title: v['title'],
                          description: v['description'],
                          youtubeId: v['youtubeId'],
                          watched: v['watched'],
                        ),
                      )
                      .toList(),
            ),
          )
          .toList();
    } catch (e) {
      print('Error loading my courses: $e');
      return [];
    }
  }

  // Save Learning Paths
  static Future<void> saveLearningPaths(List<LearningPath> paths) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(
      paths
          .map(
            (path) => {
              'id': path.id,
              'title': path.title,
              'description': path.description,
              'createdAt': path.createdAt.toIso8601String(),
              'courses':
                  path.courses
                      .map(
                        (course) => {
                          'id': course.id,
                          'title': course.title,
                          'description': course.description,
                          'author': course.author,
                          'thumbnailUrl': course.thumbnailUrl,
                          'categories': course.categories,
                          'progress': course.progress,
                          'videos':
                              course.videos
                                  .map(
                                    (video) => {
                                      'id': video.id,
                                      'title': video.title,
                                      'description': video.description,
                                      'youtubeId': video.youtubeId,
                                      'watched': video.watched,
                                    },
                                  )
                                  .toList(),
                        },
                      )
                      .toList(),
            },
          )
          .toList(),
    );
    await prefs.setString(_learningPathsKey, jsonData);
  }

  // Load Learning Paths
  static Future<List<LearningPath>> loadLearningPaths() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_learningPathsKey);
      if (jsonData == null) return [];
      final List<dynamic> decodedData = jsonDecode(jsonData);
      return decodedData
          .map(
            (item) => LearningPath(
              id: item['id'],
              title: item['title'],
              description: item['description'],
              createdAt: DateTime.parse(item['createdAt']),
              courses:
                  (item['courses'] as List)
                      .map(
                        (c) => Course(
                          id: c['id'],
                          title: c['title'],
                          description: c['description'],
                          author: c['author'],
                          thumbnailUrl: c['thumbnailUrl'],
                          categories: List<String>.from(c['categories']),
                          progress: c['progress'],
                          videos:
                              (c['videos'] as List)
                                  .map(
                                    (v) => Video(
                                      id: v['id'],
                                      title: v['title'],
                                      description: v['description'],
                                      youtubeId: v['youtubeId'],
                                      watched: v['watched'],
                                    ),
                                  )
                                  .toList(),
                        ),
                      )
                      .toList(),
            ),
          )
          .toList();
    } catch (e) {
      print('Error loading learning paths: $e');
      return [];
    }
  }

  // Save Recent Searches
  static Future<void> saveRecentSearches(List<String> searches) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchesKey, searches);
  }

  // Load Recent Searches
  static Future<List<String>> loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_recentSearchesKey) ?? [];
    } catch (e) {
      print('Error loading recent searches: $e');
      return [];
    }
  }
}
