import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/medication.dart';
import '../data/repositories/medication_repository.dart';

final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  return MedicationRepository();
});

/// Holds the current search query string.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Fires a Firestore search whenever [searchQueryProvider] changes.
final medicationSearchProvider = FutureProvider.autoDispose
    .family<List<Medication>, String>((ref, query) async {
  final repo = ref.watch(medicationRepositoryProvider);
  return repo.search(query);
});

/// Fetches a single medication by ID.
final medicationDetailProvider = FutureProvider.autoDispose
    .family<Medication?, String>((ref, id) async {
  final repo = ref.watch(medicationRepositoryProvider);
  return repo.getById(id);
});
