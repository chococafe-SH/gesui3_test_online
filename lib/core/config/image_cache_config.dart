import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// クイズ画像専用のキャッシュマネージャー設定
class QuestionImageCacheManager {
  static const key = 'questionImageCache';

  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 14), // 2週間保持
      maxNrOfCacheObjects: 200,             // 最大200ファイル
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );

  /// キャッシュのクリア（設定画面等から呼び出し想定）
  static Future<void> clear() async {
    await instance.emptyCache();
  }
}
