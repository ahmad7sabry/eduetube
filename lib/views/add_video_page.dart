// File: lib/views/add_video_page.dart
import 'package:flutter/material.dart';
import 'package:eduetube/services/video_service.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({super.key});

  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final _formKey = GlobalKey<FormState>();
  final VideoService _videoService = VideoService();

  String title = '';
  String description = '';
  String youtubeId = '';
  String category = 'Education'; // Default category
  String thumbnailUrl = '';
  String instructor = '';
  double price = 0.0;
  List<String> tags = [];
  bool _isLoading = false;
  final TextEditingController _tagsController = TextEditingController();

  // Helper function to extract YouTube ID from URL
  String extractYouTubeId(String url) {
    RegExp regExp = RegExp(
      r'^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    Match? match = regExp.firstMatch(url);
    return (match != null && match.groupCount >= 7) ? match.group(7)! : '';
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        // If user entered a full URL, extract the ID
        if (youtubeId.contains('youtube.com') ||
            youtubeId.contains('youtu.be')) {
          youtubeId = extractYouTubeId(youtubeId);
        }

        // If no thumbnail provided, generate from YouTube
        if (thumbnailUrl.isEmpty) {
          thumbnailUrl =
              'https://img.youtube.com/vi/$youtubeId/maxresdefault.jpg';
        }

        // Process tags
        if (_tagsController.text.isNotEmpty) {
          tags =
              _tagsController.text.split(',').map((tag) => tag.trim()).toList();
        }

        await _videoService.addVideo(
          title: title,
          description: description,
          youtubeId: youtubeId,
          category: category,
          thumbnailUrl: thumbnailUrl,
          instructor: instructor,
          price: price,
          tags: tags,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video added successfully!')),
        );

        // Clear form
        _formKey.currentState!.reset();
        _tagsController.clear();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding video: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add YouTube Video'),
        backgroundColor: const Color(0xff335EF7),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => title = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'YouTube ID or URL',
                  border: OutlineInputBorder(),
                  hintText:
                      'e.g., https://www.youtube.com/watch?v=dQw4w9WgXcQ or dQw4w9WgXcQ',
                ),
                validator:
                    (value) =>
                        value!.isEmpty
                            ? 'Please enter a YouTube ID or URL'
                            : null,
                onSaved: (value) => youtubeId = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (value) => description = value!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: category,
                items:
                    [
                          'Education',
                          'Programming',
                          'Science',
                          'Math',
                          'Web Development',
                          'App Development',
                          'C Programming',
                          'Python',
                          'Other',
                        ]
                        .map(
                          (label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Instructor (Optional)',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => instructor = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Thumbnail URL (Optional)',
                  border: OutlineInputBorder(),
                  helperText: 'Leave blank to use YouTube default thumbnail',
                ),
                onSaved: (value) => thumbnailUrl = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price (Optional)',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                onSaved:
                    (value) =>
                        price = value!.isNotEmpty ? double.parse(value) : 0.0,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., flutter, tutorial, beginner',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff335EF7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Add Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tagsController.dispose();
    super.dispose();
  }
}
