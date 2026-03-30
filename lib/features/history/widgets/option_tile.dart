import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/math_text.dart';

enum OptionState {
  unselected,      // 未選択（クイズプレイ中）
  selected,        // 選択中（フィードバック前）
  selectedCorrect, // 選択 + 正解
  selectedWrong,   // 選択 + 不正解
  correctAnswer,   // 正解の選択肢（未選択だった）
  normal;          // フィードバック時の他の選択肢

  static OptionState from({
    required int index,
    required int? selected,
    required int correct,
    required bool showingFeedback,
  }) {
    final isSelected = selected == index;
    final isCorrect = index == correct;

    if (!showingFeedback) {
      return isSelected ? OptionState.selected : OptionState.unselected;
    }
    if (isSelected && isCorrect) return OptionState.selectedCorrect;
    if (isSelected) return OptionState.selectedWrong;
    if (isCorrect) return OptionState.correctAnswer;
    return OptionState.normal;
  }
}

extension OptionStateStyle on OptionState {
  Color bgColor(BuildContext context) => switch (this) {
        OptionState.selected => context.colors.selectedOptionBg,
        OptionState.selectedCorrect => context.colors.correctBg,
        OptionState.selectedWrong => context.colors.incorrectBg,
        OptionState.correctAnswer => context.colors.correct.withValues(alpha: 0.1),
        _ => Colors.transparent,
      };

  Color textColor(BuildContext context) => switch (this) {
        OptionState.selectedCorrect => context.colors.correct,
        OptionState.selectedWrong => context.colors.incorrect,
        _ => context.colors.textPrimary,
      };

  Color borderColor(BuildContext context) => switch (this) {
        OptionState.selected => context.colors.selectedOptionBorder,
        OptionState.selectedCorrect => context.colors.correct,
        OptionState.selectedWrong => context.colors.incorrect,
        OptionState.correctAnswer => context.colors.correct.withValues(alpha: 0.5),
        _ => context.colors.border,
      };

  Color numberBgColor(BuildContext context) => switch (this) {
        OptionState.selected => context.colors.primary,
        OptionState.selectedCorrect => context.colors.correct,
        OptionState.selectedWrong => context.colors.incorrect,
        _ => context.colors.disabled,
      };

  Color numberTextColor(BuildContext context) => switch (this) {
        OptionState.selected ||
        OptionState.selectedCorrect ||
        OptionState.selectedWrong =>
          Colors.white,
        _ => context.colors.textPrimary,
      };

  FontWeight get fontWeight => switch (this) {
        OptionState.normal || OptionState.unselected => FontWeight.normal,
        _ => FontWeight.bold,
      };

  double get borderWidth => switch (this) {
        OptionState.normal || OptionState.unselected => 1.0,
        _ => 1.5,
      };

  Widget? suffixIcon(BuildContext context) => switch (this) {
        OptionState.selectedCorrect =>
          Icon(Icons.check_circle, color: context.colors.correct, size: 20),
        OptionState.selectedWrong =>
          Icon(Icons.cancel, color: context.colors.incorrect, size: 20),
        OptionState.correctAnswer =>
          Icon(Icons.check_circle_outline, color: context.colors.correct, size: 20),
        _ => null,
      };
}


class OptionTile extends StatelessWidget {
  final int index;
  final String text;
  final int? selectedOption;
  final int correctOptionIndex;
  final bool showingFeedback;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.index,
    required this.text,
    required this.selectedOption,
    required this.correctOptionIndex,
    this.showingFeedback = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final state = OptionState.from(
      index: index,
      selected: selectedOption,
      correct: correctOptionIndex,
      showingFeedback: showingFeedback,
    );

    return Semantics(
      label: _buildSemanticsLabel(state),
      container: true,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: state.bgColor(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: state.borderColor(context),
              width: state.borderWidth,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: state.numberBgColor(context),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: state.numberTextColor(context),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MathText(
                  text,
                  style: TextStyle(
                    color: state.textColor(context),
                    fontWeight: state.fontWeight,
                  ),
                ),
              ),
              if (state.suffixIcon(context) != null) state.suffixIcon(context)!,
            ],
          ),
        ),
      ),
    );

  }

  String _buildSemanticsLabel(OptionState state) {
    final base = '選択肢${index + 1}: $text';
    return switch (state) {
      OptionState.selected => '$base、選択済み',
      OptionState.selectedCorrect => '$base、正解',
      OptionState.selectedWrong => '$base、不正解',
      OptionState.correctAnswer => '$base、正解の選択肢',
      _ => base,
    };
  }
}
