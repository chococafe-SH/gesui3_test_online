import 'dart:io';
import 'package:flutter/foundation.dart';

class AdConfig {
  // テスト用ユニットID
  static const String _androidBannerTestId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerTestId = 'ca-app-pub-3940256099942544/2934735716';

  // 本番用ユニットID（TODO: 本番ID取得後に設定）
  static const String _androidBannerProdId = '';
  static const String _iosBannerProdId = '';

  static String get bannerAdUnitId {
    // Webプラットフォームでは広告を表示しない（クラッシュ防止）
    if (kIsWeb) return '';

    // リリースビルドかどうかでIDを出し分ける
    const isRelease = kReleaseMode;

    if (Platform.isAndroid) {
      return isRelease && _androidBannerProdId.isNotEmpty
          ? _androidBannerProdId
          : _androidBannerTestId;
    } else if (Platform.isIOS) {
      return isRelease && _iosBannerProdId.isNotEmpty
          ? _iosBannerProdId
          : _iosBannerTestId;
    }
    return '';
  }
}
