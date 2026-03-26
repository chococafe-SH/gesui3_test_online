import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'history_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/models/quiz_record.dart';
import 'widgets/history_filter_bar.dart';
import 'widgets/history_list_item.dart';
import 'widgets/history_empty_view.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _selectedCategory = 'すべて';
  SortOrder _selectedSortOrder = SortOrder.newestFirst;

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(quizHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('学習履歴'),
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.textPrimary,
        elevation: 0,
      ),
      body: historyState.when(
        data: (history) => history.isEmpty
            ? const HistoryEmptyView()
            : _buildContent(history),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('読み込みエラー: $err')),
      ),
    );
  }

  Widget _buildContent(List<QuizRecord> history) {
    final categories = [
      'すべて',
      ...history.map((e) => e.category.isEmpty ? '未分類' : e.category).toSet()
    ];

    final filteredList = _filterAndSortHistory(history);

    return Column(
      children: [
        HistoryFilterBar(
          categories: categories,
          selectedCategory: _selectedCategory,
          selectedSortOrder: _selectedSortOrder,
          onCategoryChanged: (val) {
            if (val != null) setState(() => _selectedCategory = val);
          },
          onSortChanged: (val) {
            if (val != null) setState(() => _selectedSortOrder = val);
          },
        ),
        Expanded(
          child: filteredList.isEmpty
              ? const Center(child: Text('該当する履歴がありません'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    return HistoryListItem(record: filteredList[index]);
                  },
                ),
        ),
      ],
    );
  }

  List<QuizRecord> _filterAndSortHistory(List<QuizRecord> records) {
    final filtered = records.where((item) {
      if (_selectedCategory == 'すべて') return true;
      final cat = item.category.isEmpty ? '未分類' : item.category;
      return cat == _selectedCategory;
    }).toList();

    filtered.sort((a, b) {
      switch (_selectedSortOrder) {
        case SortOrder.highestScore:
          final scoreCompare = b.correctRate.compareTo(a.correctRate);
          if (scoreCompare != 0) return scoreCompare;
          return b.answeredAt.compareTo(a.answeredAt);
        case SortOrder.oldestFirst:
          return a.answeredAt.compareTo(b.answeredAt);
        case SortOrder.newestFirst:
          return b.answeredAt.compareTo(a.answeredAt);
      }
    });

    return filtered;
  }
}
