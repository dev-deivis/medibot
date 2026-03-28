import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistoryItem {
  final String id;
  final String userId;
  final String query;
  final DateTime searchedAt;
  final String? medicationId;

  const SearchHistoryItem({
    required this.id,
    required this.userId,
    required this.query,
    required this.searchedAt,
    this.medicationId,
  });

  factory SearchHistoryItem.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return SearchHistoryItem(
      id: doc.id,
      userId: map['userId'] as String? ?? '',
      query: map['query'] as String? ?? '',
      searchedAt: (map['searchedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      medicationId: map['medicationId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'query': query,
      'searchedAt': Timestamp.fromDate(searchedAt),
      'medicationId': medicationId,
    };
  }
}
