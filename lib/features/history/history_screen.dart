import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'history_provider.dart';
import '../../shared/theme/app_colors.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String _selectedCategory = 'すべて';
  String _sortOrder = '日付の新しい順';

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(quizHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('学習履歴'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: historyState.when(
        data: (history) {
          if (history.isEmpty) {
            return const Center(
              child: Text('履歴がまだありません。\nクイズに挑戦してみましょう！',
                  textAlign: TextAlign.center),
            );
          }

          final categories = ['すべて', ...history.map((e) => e['category'] as String? ?? '未分類').toSet().toList()];

          List<Map<String, dynamic>> filteredList = history.where((item) {
            if (_selectedCategory == 'すべて') return true;
            return (item['category'] ?? '未分類') == _selectedCategory;
          }).toList();

          filteredList.sort((a, b) {
            final aCorrect = a['correctCount'] as int? ?? 0;
            final aTotal = a['totalQuestions'] as int? ?? 1;
            final bCorrect = b['correctCount'] as int? ?? 0;
            final bTotal = b['totalQuestions'] as int? ?? 1;
            final aScore = aTotal > 0 ? aCorrect / aTotal : 0;
            final bScore = bTotal > 0 ? bCorrect / bTotal : 0;
            
            final aDate = (a['playedAt'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDate = (b['playedAt'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);

            if (_sortOrder == 'スコアの高い順') {
              final scoreCompare = bScore.compareTo(aScore);
              if (scoreCompare != 0) return scoreCompare;
              return bDate.compareTo(aDate);
            } else if (_sortOrder == '日付の古い順') {
              return aDate.compareTo(bDate);
            } else {
              return bDate.compareTo(aDate);
            }
          });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: categories.contains(_selectedCategory) ? _selectedCategory : 'すべて',
                        decoration: const InputDecoration(
                          labelText: 'カテゴリ',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                        items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCategory = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _sortOrder,
                        decoration: const InputDecoration(
                          labelText: '並び替え',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: '日付の新しい順', child: Text('日付の新着順')),
                          DropdownMenuItem(value: '日付の古い順', child: Text('日付の古い順')),
                          DropdownMenuItem(value: 'スコアの高い順', child: Text('高いスコア順')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _sortOrder = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredList.isEmpty
                    ? const Center(child: Text('該当する履歴がありません'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final record = filteredList[index];
                          final playedAt = record['playedAt'] as Timestamp?;
                          final dateStr = playedAt != null
                              ? DateFormat('yyyy/MM/dd HH:mm').format(playedAt.toDate())
                              : '不明';
                          final correct = record['correctCount'] as int? ?? 0;
                          final total = record['totalQuestions'] as int? ?? 0;
                          final score = total > 0 ? (correct / total * 100).toStringAsFixed(0) : '0';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HistoryDetailScreen(record: record),
                                  ),
                                );
                              },
                              title: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      record['category'] ?? '未分類',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (record['category'] == '模擬試験') ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text('模試', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ]
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('実施日: $dateStr'),
                                  Text('正解数: $correct / $total'),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryGreen.withAlpha(26), // 0.1 * 255
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$score%',
                                  style: const TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('読み込みエラー: $err')),
      ),
    );
  }
}
