import 'package:flutter/material.dart';
import 'package:edutube/models/course.dart';

class CourseListTile extends StatelessWidget {
  final Course course;
  final bool showProgress;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CourseListTile({
    super.key,
    required this.course,
    this.showProgress = false,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          course.thumbnailUrl,
          width: 80,
          height: 45,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80,
              height: 45,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            );
          },
        ),
      ),
      title: Text(
        course.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('By ${course.author}', style: const TextStyle(fontSize: 12)),
          if (showProgress) ...[
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: course.progress,
              minHeight: 4,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red[700]!),
            ),
            const SizedBox(height: 2),
            Text(
              '${(course.progress * 100).toStringAsFixed(0)}% complete',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
