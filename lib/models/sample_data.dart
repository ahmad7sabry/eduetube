import 'package:edutube/models/course.dart';

class SampleData {
  static List<Course> generateSampleCourses() {
    return [
      const Course(
        id: 'c1',
        title: 'Flutter for Beginners',
        author: 'Tech Academy',
        description:
            'Learn Flutter from scratch and build your first mobile app. This comprehensive course covers everything from basic widgets to advanced state management.',
        thumbnailUrl: 'https://example.com/flutter.jpg',
        categories: ['Mobile Development', 'Flutter', 'Dart'],
        videos: [
          Video(
            id: 'v1',
            title: 'Introduction to Flutter',
            description: 'Overview of Flutter framework and tools',
            youtubeId: 'dQw4w9WgXcQ',
          ),
          Video(
            id: 'v2',
            title: 'Setting Up Your Environment',
            description: 'Installing Flutter SDK and required tools',
            youtubeId: 'dQw4w9WgXcQ',
          ),
          Video(
            id: 'v3',
            title: 'Basic Widgets',
            description: 'Understanding core widgets in Flutter',
            youtubeId: 'dQw4w9WgXcQ',
          ),
        ],
      ),
      const Course(
        id: 'c2',
        title: 'Advanced JavaScript',
        author: 'JS Ninja',
        description:
            'Master modern JavaScript features and patterns. This course is perfect for developers looking to level up their JS skills.',
        thumbnailUrl: 'https://example.com/javascript.jpg',
        categories: ['Web Development', 'JavaScript', 'ES6'],
        videos: [
          Video(
            id: 'v4',
            title: 'ES6 Features',
            description: 'Modern JavaScript syntax and features',
            youtubeId: 'dQw4w9WgXcQ',
          ),
          Video(
            id: 'v5',
            title: 'Async Programming',
            description: 'Promises, async/await, and event loop',
            youtubeId: 'dQw4w9WgXcQ',
          ),
        ],
      ),
      const Course(
        id: 'c3',
        title: 'Python Data Science',
        author: 'Data Wizards',
        description:
            'Learn how to analyze and visualize data using Python. Perfect for aspiring data scientists and analysts.',
        thumbnailUrl: 'https://example.com/python.jpg',
        categories: ['Data Science', 'Python', 'Machine Learning'],
        videos: [
          Video(
            id: 'v6',
            title: 'Python Basics for Data Science',
            description: 'Essential Python concepts for data analysis',
            youtubeId: 'dQw4w9WgXcQ',
          ),
          Video(
            id: 'v7',
            title: 'Pandas Fundamentals',
            description: 'Working with data frames in Pandas',
            youtubeId: 'dQw4w9WgXcQ',
          ),
        ],
      ),
    ];
  }
}
