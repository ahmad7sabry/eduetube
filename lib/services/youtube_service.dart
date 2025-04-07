import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/youtube_channel.dart';

class YouTubeService {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  final String _apiKey; // You'll need to add your YouTube Data API key

  YouTubeService(this._apiKey);

  Future<List<YouTubeVideo>> getPlaylistVideos({
    required String playlistId,
    String? pageToken,
    int maxResults = 50,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/playlistItems?part=snippet&playlistId=$playlistId&maxResults=$maxResults&key=$_apiKey${pageToken != null ? '&pageToken=$pageToken' : ''}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> items = data['items'];

      return items.map((item) {
        final snippet = item['snippet'];
        return YouTubeVideo(
          id: snippet['resourceId']['videoId'],
          title: snippet['title'],
          description: snippet['description'],
          thumbnailUrl: snippet['thumbnails']['medium']['url'],
          publishedAt: DateTime.parse(snippet['publishedAt']),
        );
      }).toList();
    } else {
      throw Exception('Failed to load playlist videos');
    }
  }

  Future<List<YouTubeVideo>> getChannelVideos({
    required String channelId,
    String? pageToken,
    int maxResults = 50,
  }) async {
    // First get the channel's uploads playlist ID
    final channelResponse = await http.get(
      Uri.parse(
        '$_baseUrl/channels?part=contentDetails&id=$channelId&key=$_apiKey',
      ),
    );

    if (channelResponse.statusCode == 200) {
      final data = json.decode(channelResponse.body);
      final String uploadsPlaylistId =
          data['items'][0]['contentDetails']['relatedPlaylists']['uploads'];
      return getPlaylistVideos(
        playlistId: uploadsPlaylistId,
        pageToken: pageToken,
        maxResults: maxResults,
      );
    } else {
      throw Exception('Failed to load channel videos');
    }
  }

  Future<List<YouTubeChannel>> searchChannels({
    required String query,
    String? pageToken,
    int maxResults = 10,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/search?part=snippet&type=channel&q=$query&maxResults=$maxResults&key=$_apiKey${pageToken != null ? '&pageToken=$pageToken' : ''}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> items = data['items'];

      // Get channel IDs for detailed information
      final channelIds = items.map((item) => item['id']['channelId']).join(',');

      // Get detailed channel information including statistics
      final detailsResponse = await http.get(
        Uri.parse(
          '$_baseUrl/channels?part=snippet,statistics&id=$channelIds&key=$_apiKey',
        ),
      );

      if (detailsResponse.statusCode == 200) {
        final detailsData = json.decode(detailsResponse.body);
        final List<dynamic> detailedItems = detailsData['items'];

        return detailedItems
            .map((item) => YouTubeChannel.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load channel details');
      }
    } else {
      throw Exception('Failed to search channels');
    }
  }
}

class YouTubeVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final DateTime publishedAt;

  YouTubeVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.publishedAt,
  });
}
