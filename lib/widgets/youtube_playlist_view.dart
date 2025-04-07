import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../providers/youtube_provider.dart';
import '../services/youtube_service.dart';

class YouTubePlaylistView extends StatelessWidget {
  final String playlistId;
  final bool isChannel;
  final String title;

  const YouTubePlaylistView({
    super.key,
    required this.playlistId,
    this.isChannel = false,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        Expanded(
          child: Consumer<YouTubeProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.videos.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null && provider.videos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading videos',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(provider.error ?? ''),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (isChannel) {
                            provider.loadChannelVideos(playlistId);
                          } else {
                            provider.loadPlaylistVideos(playlistId);
                          }
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  if (isChannel) {
                    await provider.loadChannelVideos(playlistId);
                  } else {
                    await provider.loadPlaylistVideos(playlistId);
                  }
                },
                child: ListView.builder(
                  itemCount:
                      provider.videos.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= provider.videos.length) {
                      provider.loadMore(playlistId, isChannel: isChannel);
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final video = provider.videos[index];
                    return VideoListItem(video: video);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class VideoListItem extends StatelessWidget {
  final YouTubeVideo video;

  const VideoListItem({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          // Navigate to video player page
          Navigator.pushNamed(context, '/video-player', arguments: video);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(video.thumbnailUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeago.format(video.publishedAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
