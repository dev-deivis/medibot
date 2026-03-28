import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medication.dart';

class MedicationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _medications => _db.collection('medications');

  /// Search medications by name, genericName, or brand (case-insensitive prefix).
  /// Firestore doesn't support full-text search natively, so we use range queries
  /// on the lowercased name field.
  Future<List<Medication>> search(String query) async {
    if (query.trim().isEmpty) return [];

    final lower = query.trim().toLowerCase();
    final upper = '${lower}z'; // prefix range trick

    // Query by lowercase name stored in 'nameLower' field
    final snapshot = await _medications
        .where('nameLower', isGreaterThanOrEqualTo: lower)
        .where('nameLower', isLessThan: upper)
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => Medication.fromFirestore(doc))
        .toList();
  }

  /// Fetch a single medication by ID.
  Future<Medication?> getById(String id) async {
    final doc = await _medications.doc(id).get();
    if (!doc.exists) return null;
    return Medication.fromFirestore(doc);
  }
}
