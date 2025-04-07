import 'package:flutter/material.dart';
import 'package:edutube/models/course.dart';

class VideoListTile extends StatelessWidget {
  final Video video;
  final VoidCallback? onTap;

  const VideoListTile({super.key, required this.video, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      leading: Container(
        width: 80,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          video.watched ? Icons.check_circle : Icons.play_circle_filled,
          color: video.watched ? Colors.green : Colors.grey[700],
        ),
      ),
      title: Text(
        video.title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          decoration: video.watched ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(
        video.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }
}
