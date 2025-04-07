import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:edutube/models/course.dart';
import 'package:edutube/utils/storage_helper.dart';
import 'package:edutube/config/api_config.dart';

class CourseService {
  static final http.Client _client = http.Client();

  // Fetch all available courses
  static Future<List<Course>> fetchCourses() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.courses}'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> coursesJson = json.decode(response.body);
        final courses =
            coursesJson.map((json) => Course.fromJson(json)).toList();

        // Cache the courses locally
        await StorageHelper.saveMyCourses(courses);
        return courses;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please check your API key.');
      } else if (response.statusCode == 404) {
        throw Exception('Courses endpoint not found.');
      } else {
        throw Exception(
          'Failed to load courses. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching courses: $e');
      // On network/parsing error, try to load from cache
      return await StorageHelper.loadMyCourses();
    }
  }

  // Fetch a single course by ID
  static Future<Course?> fetchCourseById(String courseId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.courses}/$courseId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Course.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Course not found');
      } else {
        throw Exception(
          'Failed to load course. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching course details: $e');
      // Try to find course in local storage
      final localCourses = await StorageHelper.loadMyCourses();
      return localCourses.firstWhere(
        (course) => course.id == courseId,
        orElse: () => throw Exception('Course not found locally'),
      );
    }
  }

  // Update course progress
  static Future<bool> updateCourseProgress(
    String courseId,
    double progress,
  ) async {
    try {
      final response = await _client.patch(
        Uri.parse(
          '${ApiConfig.baseUrl}${ApiConfig.courses}/$courseId/progress',
        ),
        headers: {...ApiConfig.headers, 'Content-Type': 'application/json'},
        body: json.encode({'progress': progress}),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Course not found');
      } else {
        throw Exception(
          'Failed to update progress. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error updating course progress: $e');
      return false;
    }
  }

  // Mark video as watched
  static Future<bool> markVideoAsWatched(
    String courseId,
    String videoId,
  ) async {
    try {
      final response = await _client.patch(
        Uri.parse(
          '${ApiConfig.baseUrl}${ApiConfig.courses}/$courseId/videos/$videoId/watched',
        ),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('Course or video not found');
      } else {
        throw Exception(
          'Failed to mark video as watched. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error marking video as watched: $e');
      return false;
    }
  }

  // Dispose http client when no longer needed
  static void dispose() {
    _client.close();
  }
}
