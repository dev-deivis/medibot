import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/search_history.dart';

class SearchHistoryRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _history => _db.collection('searchHistory');

  /// Save a new search query for the given user.
  Future<void> addSearch({
    required String userId,
    required String query,
    String? medicationId,
  }) async {
    await _history.add(SearchHistoryItem(
      id: '',
      userId: userId,
      query: query,
      searchedAt: DateTime.now(),
      medicationId: medicationId,
    ).toMap());
  }

  /// Get the last [limit] searches for the given user, newest first.
  Future<List<SearchHistoryItem>> getHistory(String userId, {int limit = 20}) async {
    final snapshot = await _history
        .where('userId', isEqualTo: userId)
        .orderBy('searchedAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => SearchHistoryItem.fromFirestore(doc))
        .toList();
  }

  /// Delete a specific history item.
  Future<void> deleteItem(String itemId) async {
    await _history.doc(itemId).delete();
  }

  /// Delete all history for a user.
  Future<void> clearHistory(String userId) async {
    final snapshot = await _history
        .where('userId', isEqualTo: userId)
        .get();

    final batch = _db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
