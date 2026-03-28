import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/app_theme.dart';
import '../../../providers/medication_provider.dart';
import '../../../providers/search_history_provider.dart';
import '../../../data/models/medication.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    setState(() => _query = value.trim());
  }

  void _selectHistoryQuery(String query) {
    _controller.text = query;
    setState(() => _query = query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textSlate900),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Buscar Medicamento',
          style: TextStyle(
            color: AppTheme.textSlate900,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Ej: Paracetamol, Ibuprofeno...',
                hintStyle: const TextStyle(color: AppTheme.textSlate400),
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primary),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: AppTheme.textSlate400),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppTheme.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),

          Expanded(
            child: _query.isEmpty
                ? _buildRecentSearches()
                : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    final historyState = ref.watch(searchHistoryNotifierProvider);

    return historyState.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      error: (_, __) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_rounded, size: 64, color: AppTheme.textSlate400),
                SizedBox(height: 12),
                Text(
                  'Escribe el nombre de un medicamento',
                  style: TextStyle(color: AppTheme.textSlate500, fontSize: 15),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Búsquedas recientes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSlate900,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      ref.read(searchHistoryNotifierProvider.notifier).clearAll(),
                  child: const Text('Limpiar', style: TextStyle(color: AppTheme.primary)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...items.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history_rounded, color: AppTheme.textSlate400),
                title: Text(item.query, style: const TextStyle(color: AppTheme.textSlate900)),
                trailing: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.textSlate400),
                  onPressed: () => ref
                      .read(searchHistoryNotifierProvider.notifier)
                      .deleteItem(item.id),
                ),
                onTap: () => _selectHistoryQuery(item.query),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResults() {
    final results = ref.watch(medicationSearchProvider(_query));

    return results.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      error: (e, _) => Center(
        child: Text('Error al buscar: $e', style: const TextStyle(color: AppTheme.textSlate500)),
      ),
      data: (medications) {
        if (medications.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.medication_outlined, size: 64, color: AppTheme.textSlate400),
                const SizedBox(height: 12),
                Text(
                  'No se encontró "$_query"',
                  style: const TextStyle(
                    color: AppTheme.textSlate900,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Intenta con otro nombre o la marca comercial',
                  style: TextStyle(color: AppTheme.textSlate500, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: medications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _MedicationTile(medication: medications[index]),
        );
      },
    );
  }
}

class _MedicationTile extends ConsumerWidget {
  final Medication medication;

  const _MedicationTile({required this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(searchHistoryNotifierProvider.notifier).addSearch(
              medication.name,
              medicationId: medication.id,
            );
        // TODO: Navigate to results/details screen
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.medication_rounded, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppTheme.textSlate900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${medication.genericName} · ${medication.dosage} · ${medication.form}',
                    style: const TextStyle(fontSize: 13, color: AppTheme.textSlate500),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textSlate400),
          ],
        ),
      ),
    );
  }
}
