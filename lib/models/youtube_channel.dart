class YouTubeChannel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String customUrl;
  final String subscriberCount;

  YouTubeChannel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.customUrl,
    this.subscriberCount = '0',
  });

  factory YouTubeChannel.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    final thumbnails = snippet['thumbnails'];
    final statistics = json['statistics'];

    return YouTubeChannel(
      id: json['id']['channelId'] ?? json['id'],
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnailUrl: thumbnails['default']['url'] ?? '',
      customUrl: snippet['customUrl'] ?? '',
      subscriberCount: statistics?['subscriberCount'] ?? '0',
    );
  }
}
