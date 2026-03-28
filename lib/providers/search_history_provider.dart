import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/search_history.dart';
import '../data/repositories/search_history_repository.dart';
import 'auth_provider.dart';

final searchHistoryRepositoryProvider = Provider<SearchHistoryRepository>((ref) {
  return SearchHistoryRepository();
});

/// Loads search history for the currently authenticated user.
final searchHistoryProvider =
    FutureProvider.autoDispose<List<SearchHistoryItem>>((ref) async {
  final repo = ref.watch(searchHistoryRepositoryProvider);
  final authRepo = ref.watch(authRepositoryProvider);
  final userId = authRepo.currentUser?.uid;
  if (userId == null) return [];
  return repo.getHistory(userId);
});

class SearchHistoryNotifier extends StateNotifier<AsyncValue<List<SearchHistoryItem>>> {
  final SearchHistoryRepository _repo;
  final String? _userId;

  SearchHistoryNotifier(this._repo, this._userId)
      : super(const AsyncValue.loading()) {
    if (_userId != null) _load();
  }

  Future<void> _load() async {
    try {
      final items = await _repo.getHistory(_userId!);
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addSearch(String query, {String? medicationId}) async {
    if (_userId == null || query.trim().isEmpty) return;
    await _repo.addSearch(
      userId: _userId,
      query: query.trim(),
      medicationId: medicationId,
    );
    await _load();
  }

  Future<void> deleteItem(String itemId) async {
    await _repo.deleteItem(itemId);
    await _load();
  }

  Future<void> clearAll() async {
    if (_userId == null) return;
    await _repo.clearHistory(_userId);
    state = const AsyncValue.data([]);
  }
}

final searchHistoryNotifierProvider =
    StateNotifierProvider<SearchHistoryNotifier, AsyncValue<List<SearchHistoryItem>>>(
  (ref) {
    final repo = ref.watch(searchHistoryRepositoryProvider);
    final userId = ref.watch(authRepositoryProvider).currentUser?.uid;
    return SearchHistoryNotifier(repo, userId);
  },
);
