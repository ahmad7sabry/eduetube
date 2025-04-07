import 'package:flutter/foundation.dart';
import '../services/youtube_service.dart';

class YouTubeProvider with ChangeNotifier {
  final YouTubeService _youtubeService;
  List<YouTubeVideo> _videos = [];
  bool _isLoading = false;
  String? _error;
  String? _nextPageToken;

  YouTubeProvider(this._youtubeService);

  List<YouTubeVideo> get videos => _videos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _nextPageToken != null;

  Future<void> loadChannelVideos(String channelId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _videos = await _youtubeService.getChannelVideos(channelId: channelId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPlaylistVideos(String playlistId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _videos = await _youtubeService.getPlaylistVideos(playlistId: playlistId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore(String id, {bool isChannel = true}) async {
    if (_isLoading || !hasMore) return;

    try {
      _isLoading = true;
      notifyListeners();

      final newVideos =
          isChannel
              ? await _youtubeService.getChannelVideos(
                channelId: id,
                pageToken: _nextPageToken,
              )
              : await _youtubeService.getPlaylistVideos(
                playlistId: id,
                pageToken: _nextPageToken,
              );

      _videos.addAll(newVideos);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
