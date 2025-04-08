// File: lib/services/video_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'videos';

  // Add a new YouTube video to the database
  Future<void> addVideo({
    required String title,
    required String description,
    required String youtubeId,
    required String category,
    required String thumbnailUrl,
    String? instructor,
    double? price,
    List<String>? tags,
  }) async {
    try {
      await _firestore.collection(collectionName).add({
        'title': title,
        'description': description,
        'youtubeId': youtubeId,
        'category': category,
        'thumbnailUrl': thumbnailUrl,
        'instructor': instructor ?? 'Unknown',
        'price': price ?? 0.0,
        'tags': tags ?? [],
        'dateAdded': FieldValue.serverTimestamp(),
        'viewCount': 0,
      });
    } catch (e) {
      print('Error adding video: $e');
      rethrow;
    }
  }

  // Get all videos
  Stream<QuerySnapshot> getVideos() {
    return _firestore
        .collection(collectionName)
        .orderBy('dateAdded', descending: true)
        .snapshots();
  }

  // Get videos by category
  Stream<QuerySnapshot> getVideosByCategory(String category) {
    return _firestore
        .collection(collectionName)
        .where('category', isEqualTo: category)
        .orderBy('dateAdded', descending: true)
        .snapshots();
  }

  // Get featured videos
  Stream<QuerySnapshot> getFeaturedVideos() {
    return _firestore
        .collection(collectionName)
        .orderBy('viewCount', descending: true)
        .limit(5)
        .snapshots();
  }

  // Get a single video by ID
  Future<DocumentSnapshot> getVideoById(String videoId) {
    return _firestore.collection(collectionName).doc(videoId).get();
  }

  // Update a video
  Future<void> updateVideo(String videoId, Map<String, dynamic> data) {
    return _firestore.collection(collectionName).doc(videoId).update(data);
  }

  // Delete a video
  Future<void> deleteVideo(String videoId) {
    return _firestore.collection(collectionName).doc(videoId).delete();
  }

  // Increment view count
  Future<void> incrementViewCount(String videoId) {
    return _firestore.collection(collectionName).doc(videoId).update({
      'viewCount': FieldValue.increment(1),
    });
  }

  // Search videos
  Future<QuerySnapshot> searchVideos(String query) {
    // This is a simple search based on title containing the query
    // For more advanced search, consider using Firebase Extensions or Algolia
    return _firestore
        .collection(collectionName)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
  }
}
