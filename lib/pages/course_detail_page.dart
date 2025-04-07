import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edutube/models/app_state.dart';
import 'package:edutube/pages/video_player_page.dart';
import 'package:edutube/widgets/video_list_tile.dart';
import 'package:edutube/services/youtube_service.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseId;

  const CourseDetailPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final course = appState.courses.firstWhere((c) => c.id == courseId);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    course.thumbnailUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'By ${course.author}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Text(course.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                const Text(
                  'Videos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: course.videos.length,
                    itemBuilder: (context, index) {
                      final video = course.videos[index];
                      return VideoListTile(
                        video: video,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => VideoPlayerPage(
                                    video: YouTubeVideo(
                                      id: video.youtubeId,
                                      title: video.title,
                                      description: video.description,
                                      thumbnailUrl:
                                          '', // We don't have thumbnail in the current Video model
                                      publishedAt:
                                          DateTime.now(), // We don't have published date in the current Video model
                                    ),
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
