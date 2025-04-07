import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/youtube_channel.dart';
import '../services/youtube_service.dart';
import '../config/youtube_config.dart';

class YouTubeChannelSearchScreen extends StatefulWidget {
  const YouTubeChannelSearchScreen({super.key});

  @override
  State<YouTubeChannelSearchScreen> createState() =>
      _YouTubeChannelSearchScreenState();
}

class _YouTubeChannelSearchScreenState
    extends State<YouTubeChannelSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final YouTubeService _youtubeService = YouTubeService(YouTubeConfig.apiKey);
  bool _isLoading = false;
  String? _error;
  List<YouTubeChannel> _channels = [];

  Future<void> _searchChannels() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final channels = await _youtubeService.searchChannels(
        query: _searchController.text.trim(),
        maxResults: 10,
      );
      setState(() {
        _channels = channels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to search channels. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search YouTube Channels')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search channels...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _searchChannels(),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _searchChannels,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _channels.length,
                itemBuilder: (context, index) {
                  final channel = _channels[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: CachedNetworkImageProvider(
                        channel.thumbnailUrl,
                      ),
                    ),
                    title: Text(
                      channel.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      channel.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // Handle channel selection
                      Navigator.pop(context, channel);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
