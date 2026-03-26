import 'dart:math' as math;

/// レベル・経験値システムを管理するユーティリティクラス
class LevelSystem {
  static const int xpPerLevel = 100;

  /// 次のレベル昇格に必要なXP（そのレベルで稼ぐべき量）を計算
  /// Level 1 -> 100 XP (Total 100 for Level 2)
  /// Level 2 -> 200 XP (Total 300 for Level 3)
  static int xpForNextLevel(int currentLevel) {
    return currentLevel * xpPerLevel;
  }

  /// 指定レベルに到達するために必要な累計XPを計算
  /// Level 1 -> 0
  /// Level 2 -> 100
  /// Level 3 -> 300
  static int totalXpForLevel(int level) {
    if (level <= 1) return 0;
    // 等差数列の和: 100 * (1 + 2 + ... + (level-1))
    // = 100 * (level-1) * level / 2 = 50 * (level-1) * level
    return 50 * (level - 1) * level;
  }

  /// 合計XPから現在のレベルを計算 (O(1))
  static int calculateLevel(int totalXp) {
    if (totalXp < xpPerLevel) return 1;
    
    // totalXp = 50 * (L-1) * L を L について解く
    // L^2 - L - totalXp/50 = 0
    // L = (1 + sqrt(1 + 4 * totalXp/50)) / 2
    final level = (1 + math.sqrt(1 + 0.08 * totalXp)) / 2;
    return level.floor().clamp(1, 999); // 上限は適宜
  }
}
