import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color primaryDarkBlue = Color(0xFF0D47A1);
  static const Color secondaryGreen = Color(0xFF34A853);
  
  // Quiz specific colors
  static const Color correctGreen = Color(0xFF2E7D32);   // やや深い緑
  static const Color incorrectRed = Color(0xFFE53935);   // やや明るい赤
  static const Color correctBg = Color(0xFFE8F5E9);      // 薄い緑背景
  static const Color incorrectBg = Color(0xFFFFEBEE);    // 薄い赤背景
  
  static const Color selectedOption = Color(0xFFE3F2FD); // 選択中の選択肢背景
  static const Color streakOrange = Color(0xFFFF6D00);   // 連続記録
  static const Color xpPurple = Color(0xFF7C4DFF);       // 経験値・レベル
  static const Color timerAmber = Color(0xFFFF8F00);     // タイマー
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  
  // Accent Colors
  static const Color accentYellow = Color(0xFFFBBC05);   // ※白背景のテキスト不可
  static const Color accentYellowText = Color(0xFFF9A825); // テキスト用の暗い黄色
  static const Color errorRed = Color(0xFFD93025);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);
  
  // Neutral Colors
  static const Color border = Color(0xFFDADCE0);
  static const Color disabled = Color(0xFFE8EAED);

  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFE8EAED);
  static const Color textSecondaryDark = Color(0xFF9AA0A6);
  static const Color borderDark = Color(0xFF3C4043);
  
  static const Color disabledDark = Color(0xFF3C4043);
  static const Color primaryBlueDark = Color(0xFF8AB4F8);
  static const Color secondaryGreenDark = Color(0xFF81C995);
  static const Color errorRedDark = Color(0xFFF28B82);
  static const Color accentYellowDark = Color(0xFFFDD663);
}

@immutable
class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  // Quiz
  final Color correct;
  final Color incorrect;
  final Color correctBg;
  final Color incorrectBg;

  // Gamification
  final Color streak;
  final Color xp;

  // アプリ全体で使う色
  final Color primary;
  final Color primaryContainer;
  final Color secondary;
  final Color error;
  final Color accentYellow;
  final Color accentYellowText;

  // 背景・テキスト
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color disabled;

  // 選択肢
  final Color selectedOptionBg;
  final Color selectedOptionBorder;

  const AppColorsTheme({
    required this.correct,
    required this.incorrect,
    required this.correctBg,
    required this.incorrectBg,
    required this.streak,
    required this.xp,
    required this.primary,
    required this.primaryContainer,
    required this.secondary,
    required this.error,
    required this.accentYellow,
    required this.accentYellowText,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.disabled,
    required this.selectedOptionBg,
    required this.selectedOptionBorder,
  });

  static const light = AppColorsTheme(
    correct: AppColors.correctGreen,
    incorrect: AppColors.incorrectRed,
    correctBg: AppColors.correctBg,
    incorrectBg: AppColors.incorrectBg,
    streak: AppColors.streakOrange,
    xp: AppColors.xpPurple,
    primary: AppColors.primaryBlue,
    primaryContainer: Color(0xFFD2E3FC),
    secondary: AppColors.secondaryGreen,
    error: AppColors.errorRed,
    accentYellow: AppColors.accentYellow,
    accentYellowText: AppColors.accentYellowText,
    background: AppColors.background,
    surface: AppColors.surface,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    border: AppColors.border,
    disabled: AppColors.disabled,
    selectedOptionBg: AppColors.selectedOption,
    selectedOptionBorder: AppColors.primaryBlue,
  );

  static const dark = AppColorsTheme(
    correct: Color(0xFF81C995),
    incorrect: Color(0xFFF28B82),
    correctBg: Color(0xFF1B3A1F),
    incorrectBg: Color(0xFF3A1C1C),
    streak: Color(0xFFFFAB40),
    xp: Color(0xFFB388FF),
    primary: AppColors.primaryBlueDark,
    primaryContainer: Color(0xFF1A3A5C),
    secondary: AppColors.secondaryGreenDark,
    error: AppColors.errorRedDark,
    accentYellow: AppColors.accentYellowDark,
    accentYellowText: AppColors.accentYellowDark,
    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    textPrimary: AppColors.textPrimaryDark,
    textSecondary: AppColors.textSecondaryDark,
    border: AppColors.borderDark,
    disabled: AppColors.disabledDark,
    selectedOptionBg: Color(0xFF1A3A5C),
    selectedOptionBorder: AppColors.primaryBlueDark,
  );

  @override
  AppColorsTheme copyWith({
    Color? correct,
    Color? incorrect,
    Color? correctBg,
    Color? incorrectBg,
    Color? streak,
    Color? xp,
    Color? primary,
    Color? primaryContainer,
    Color? secondary,
    Color? error,
    Color? accentYellow,
    Color? accentYellowText,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? disabled,
    Color? selectedOptionBg,
    Color? selectedOptionBorder,
  }) {
    return AppColorsTheme(
      correct: correct ?? this.correct,
      incorrect: incorrect ?? this.incorrect,
      correctBg: correctBg ?? this.correctBg,
      incorrectBg: incorrectBg ?? this.incorrectBg,
      streak: streak ?? this.streak,
      xp: xp ?? this.xp,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      secondary: secondary ?? this.secondary,
      error: error ?? this.error,
      accentYellow: accentYellow ?? this.accentYellow,
      accentYellowText: accentYellowText ?? this.accentYellowText,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      disabled: disabled ?? this.disabled,
      selectedOptionBg: selectedOptionBg ?? this.selectedOptionBg,
      selectedOptionBorder: selectedOptionBorder ?? this.selectedOptionBorder,
    );
  }

  @override
  AppColorsTheme lerp(ThemeExtension<AppColorsTheme>? other, double t) {
    if (other is! AppColorsTheme) return this;
    return AppColorsTheme(
      correct: Color.lerp(correct, other.correct, t)!,
      incorrect: Color.lerp(incorrect, other.incorrect, t)!,
      correctBg: Color.lerp(correctBg, other.correctBg, t)!,
      incorrectBg: Color.lerp(incorrectBg, other.incorrectBg, t)!,
      streak: Color.lerp(streak, other.streak, t)!,
      xp: Color.lerp(xp, other.xp, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      accentYellow: Color.lerp(accentYellow, other.accentYellow, t)!,
      accentYellowText: Color.lerp(accentYellowText, other.accentYellowText, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      selectedOptionBg: Color.lerp(selectedOptionBg, other.selectedOptionBg, t)!,
      selectedOptionBorder: Color.lerp(selectedOptionBorder, other.selectedOptionBorder, t)!,
    );
  }
}

extension AppColorsThemeX on BuildContext {
  /// 現在のテーマに応じた AppColorsTheme を取得
  AppColorsTheme get colors =>
      Theme.of(this).extension<AppColorsTheme>() ?? AppColorsTheme.light;
}

