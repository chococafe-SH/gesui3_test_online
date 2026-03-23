import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'premium_provider.g.dart';

@riverpod
class PremiumNotifier extends _$PremiumNotifier {
  @override
  bool build() {
    // 初期値は無料会員（false）
    return false;
  }

  void setPremium(bool value) {
    state = value;
  }
}
