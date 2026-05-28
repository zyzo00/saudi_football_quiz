import 'package:cloud_firestore/cloud_firestore.dart';

/// A premium, highly decoupled Service Layer for Cloud Firestore integration.
/// Handles all CRUD operations for the Saudi Football Quiz, including reading
/// daily challenges and leaderboards, and recording user results.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // =========================================================================
  // 1. READ OPERATIONS
  // =========================================================================

  /// Reads the daily challenge for a specific date.
  /// Document path: `daily_challenges/{date}`
  ///
  /// Returns a Map containing the challenge details (title, target players, etc.)
  /// or null if the challenge is not found.
  Future<Map<String, dynamic>?> getDailyChallenge(String date) async {
    try {
      final doc = await _db.collection('daily_challenges').doc(date).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      // In a real app, integrate a proper logging framework here
      print('Error reading daily challenge for $date: $e');
      return null;
    }
  }

  /// Displays the real-time rankings for a specific date.
  /// Document path reads from: `leaderboard/{date}`
  ///
  /// Note: To support standard Firestore scalability (overcoming the 1MB document limit),
  /// rankings are stored in a subcollection under the date document:
  /// Path: `leaderboard/{date}/users`
  ///
  /// Returns a Stream of user rank lists, sorted by points descending, then by time ascending.
  Stream<List<Map<String, dynamic>>> getLeaderboardStream(String date) {
    try {
      return _db
          .collection('leaderboard')
          .doc(date)
          .collection('users')
          .orderBy('points', descending: true)
          .orderBy('time_used', descending: false)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              // Ensure the document ID is preserved as the 'id' field
              data['id'] = doc.id;
              return data;
            }).toList();
          });
    } catch (e) {
      print('Error streaming leaderboard for $date: $e');
      return const Stream.empty();
    }
  }

  // =========================================================================
  // 2. WRITE OPERATIONS
  // =========================================================================

  /// Records the user's game results.
  /// Writes to: `results/{date}/users/{userId}` (subcollection structure)
  /// Or `results/{date}` as a document with nested maps if preferred.
  ///
  /// Saves score, time used, win status, and metadata.
  Future<void> saveUserResult({
    required String date,
    required String userId,
    required String userName,
    required int score,
    required int timeUsed,
    required bool isWin,
  }) async {
    try {
      await _db
          .collection('results')
          .doc(date)
          .collection('users')
          .doc(userId)
          .set({
            'userId': userId,
            'userName': userName,
            'score': score,
            'timeUsed': timeUsed,
            'isWin': isWin,
            'timestamp': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user result for $userId on $date: $e');
      rethrow; // Propagate the error so the caller can handle failures
    }
  }

  /// Updates the global leaderboard rankings for a specific date.
  /// Writes to: `leaderboard/{date}/users/{userId}` (subcollection structure)
  ///
  /// Triggers automatically after saving user results to keep rankings fresh.
  Future<void> updateLeaderboard({
    required String date,
    required String userId,
    required String userName,
    required int points,
    required int timeUsed,
    String? avatarUrl,
  }) async {
    try {
      // Calculate formatted time e.g., '1:34' for displaying on screen
      final minutes = (timeUsed ~/ 60).toString();
      final seconds = (timeUsed % 60).toString().padLeft(2, '0');
      final formattedTime = '$minutes:$seconds';

      await _db
          .collection('leaderboard')
          .doc(date)
          .collection('users')
          .doc(userId)
          .set({
            'name': userName,
            'points': points,
            'time': formattedTime,
            'time_used': timeUsed, // Raw seconds to easily sort in queries
            'avatar': avatarUrl,
            'timestamp': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating leaderboard ranking for $userId on $date: $e');
      rethrow;
    }
  }
}
