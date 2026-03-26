import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

/// クイズ退出確認ダイアログを表示する
Future<bool> showQuizExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('クイズを終了しますか？'),
      content: const Text('ここまでの回答結果を保存して終了します。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('保存して終了'),
        ),
      ],
    ),
  );
  return result ?? false;
}
