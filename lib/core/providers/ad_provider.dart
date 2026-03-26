import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ad_config.dart';
import 'premium_provider.dart';

@immutable
class AdState {
  final bool showAds;
  final String bannerAdUnitId;

  const AdState({
    this.showAds = true,
    this.bannerAdUnitId = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdState &&
          showAds == other.showAds &&
          bannerAdUnitId == other.bannerAdUnitId;

  @override
  int get hashCode => Object.hash(showAds, bannerAdUnitId);

  AdState copyWith({
    bool? showAds,
    String? bannerAdUnitId,
  }) {
    return AdState(
      showAds: showAds ?? this.showAds,
      bannerAdUnitId: bannerAdUnitId ?? this.bannerAdUnitId,
    );
  }
}

class AdNotifier extends Notifier<AdState> {
  @override
  AdState build() {
    // プレミアム状態をリアクティブに監視
    // PremiumNotifierがChangeNotifierProviderでも watch により変更時に build が再実行される
    final isPremium = ref.watch(premiumNotifierProvider).isPremium;

    return AdState(
      showAds: !isPremium,
      bannerAdUnitId: AdConfig.bannerAdUnitId,
    );
  }
}

final adNotifierProvider = NotifierProvider<AdNotifier, AdState>(() {
  return AdNotifier();
});
