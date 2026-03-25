import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'premium_provider.dart';

// コード生成に依存しないプロバイダー定義
final adNotifierProvider = ChangeNotifierProvider<AdNotifier>((ref) {
  return AdNotifier(ref);
});

class AdNotifier extends ChangeNotifier {
  final Ref ref;
  bool _showAds = true;

  AdNotifier(this.ref) {
    // プレミアム会員状態を監視
    _updateAdStatus();
    ref.listen(premiumNotifierProvider, (previous, next) {
      _updateAdStatus();
    });
  }

  bool get showAds => _showAds;

  void _updateAdStatus() {
    final isPremium = ref.read(premiumNotifierProvider).isPremium;
    _showAds = !isPremium;
    notifyListeners();
  }

  /// バナー広告のユニットIDを取得（本番ID未取得のため常にテスト用IDを使用）
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Androidテスト用ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // iOSテスト用ID
    }
    return '';
  }
}
