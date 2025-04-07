import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edutube/models/app_state.dart';
import 'package:edutube/widgets/learning_path_card.dart';

class LearningPathsPage extends StatelessWidget {
  const LearningPathsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final learningPaths = appState.learningPaths;

        if (learningPaths.isEmpty) {
          return const Center(child: Text('No learning paths available.'));
        }

        return ListView.builder(
          itemCount: learningPaths.length,
          itemBuilder: (context, index) {
            final learningPath = learningPaths[index];
            return LearningPathCard(
              learningPath: learningPath,
              onTap: () {
                // Implement navigation to learning path details
              },
            );
          },
        );
      },
    );
  }
}
