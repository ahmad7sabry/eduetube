import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edutube/models/app_state.dart';
import 'package:edutube/pages/course_detail_page.dart';
import 'package:edutube/widgets/course_list_tile.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final myCourses = appState.myCourses;

        if (myCourses.isEmpty) {
          return const Center(
            child: Text('You have not added any courses yet.'),
          );
        }

        return ListView.builder(
          itemCount: myCourses.length,
          itemBuilder: (context, index) {
            final course = myCourses[index];
            return CourseListTile(
              course: course,
              showProgress: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailPage(courseId: course.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
