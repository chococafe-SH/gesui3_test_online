import 'package:flutter/material.dart';

enum SortOrder {
  newestFirst('日付の新しい順'),
  oldestFirst('日付の古い順'),
  highestScore('スコアの高い順');

  final String label;
  const SortOrder(this.label);
}

class HistoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final SortOrder selectedSortOrder;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<SortOrder?> onSortChanged;

  const HistoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.selectedSortOrder,
    required this.onCategoryChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<String>(
              initialValue: categories.contains(selectedCategory) ? selectedCategory : 'すべて',
              decoration: const InputDecoration(
                labelText: 'カテゴリ',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(),
              ),
              items: categories
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: onCategoryChanged,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<SortOrder>(
              initialValue: selectedSortOrder,
              decoration: const InputDecoration(
                labelText: '並び替え',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(),
              ),
              items: SortOrder.values
                  .map((order) => DropdownMenuItem(
                        value: order,
                        child: Text(order.label, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: onSortChanged,
            ),
          ),
        ],
      ),
    );
  }
}
