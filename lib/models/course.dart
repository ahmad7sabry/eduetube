class Course {
  final String id;
  final String title;
  final String description;
  final String author;
  final String thumbnailUrl;
  final List<String> categories;
  final List<Video> videos;
  final double progress;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.thumbnailUrl,
    required this.categories,
    required this.videos,
    this.progress = 0.0,
  });

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? author,
    String? thumbnailUrl,
    List<String>? categories,
    List<Video>? videos,
    double? progress,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      categories: categories ?? this.categories,
      videos: videos ?? this.videos,
      progress: progress ?? this.progress,
    );
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    try {
      return Course(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        author: json['author'] as String? ?? '',
        thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
        categories:
            (json['categories'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        videos:
            (json['videos'] as List<dynamic>?)
                ?.map((e) => Video.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      print('Error parsing course data: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'id': id,
        'title': title,
        'description': description,
        'author': author,
        'thumbnailUrl': thumbnailUrl,
        'categories': categories,
        'videos': videos.map((v) => v.toJson()).toList(),
        'progress': progress,
      };
    } catch (e) {
      print('Error converting course to JSON: $e');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'Course{id: $id, title: $title}';
  }
}

class Video {
  final String id;
  final String title;
  final String description;
  final String youtubeId;
  final bool watched;

  const Video({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeId,
    this.watched = false,
  });

  Video copyWith({
    String? id,
    String? title,
    String? description,
    String? youtubeId,
    bool? watched,
  }) {
    return Video(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      youtubeId: youtubeId ?? this.youtubeId,
      watched: watched ?? this.watched,
    );
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    try {
      return Video(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        youtubeId: json['youtubeId'] as String? ?? '',
        watched: json['watched'] as bool? ?? false,
      );
    } catch (e) {
      print('Error parsing video data: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'id': id,
        'title': title,
        'description': description,
        'youtubeId': youtubeId,
        'watched': watched,
      };
    } catch (e) {
      print('Error converting video to JSON: $e');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'Video{id: $id, title: $title}';
  }
}
