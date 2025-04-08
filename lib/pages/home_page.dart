import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key}); // ✅ const constructor

  final List<Map<String, String>> courses = const [
    {
      'title': 'Flutter for Beginners',
      'description': 'Learn the basics of Flutter.',
      'thumbnail': 'https://img.youtube.com/vi/1ukSR1GRtMU/0.jpg',
    },
    {
      'title': 'Advanced Dart',
      'description': 'Master Dart programming.',
      'thumbnail': 'https://img.youtube.com/vi/AqCMFXEmf3w/0.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Eduetube',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  course['thumbnail']!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                course['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(course['description']!),
              trailing: const Icon(
                Icons.play_circle_fill,
                color: Colors.deepPurple,
              ),
              onTap: () {
                // TODO: Navigate to video list or course detail page
              },
            ),
          );
        },
      ),
    );
  }
}
