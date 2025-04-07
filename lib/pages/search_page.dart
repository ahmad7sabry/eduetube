import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edutube/models/app_state.dart';
import 'package:edutube/models/course.dart';
import 'package:edutube/pages/course_detail_page.dart';
import 'package:edutube/widgets/course_list_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Course> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final appState = Provider.of<AppState>(context, listen: false);
    final results =
        appState.courses
            .where(
              (course) =>
                  course.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    setState(() {
      _searchResults = results;
    });

    appState.addRecentSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Courses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _performSearch(_searchController.text);
                  },
                ),
              ),
              onSubmitted: (query) {
                _performSearch(query);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final course = _searchResults[index];
                  return CourseListTile(
                    course: course,
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
              ),
            ),
            const SizedBox(height: 16),
            Consumer<AppState>(
              builder: (context, appState, child) {
                final recentSearches = appState.recentSearches;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (recentSearches.isNotEmpty) ...[
                      const Text(
                        'Recent Searches',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            recentSearches
                                .map(
                                  (search) => Chip(
                                    label: Text(search),
                                    onDeleted: () {
                                      appState.removeRecentSearch(search);
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
