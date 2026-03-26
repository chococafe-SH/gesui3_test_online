import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../../core/config/image_cache_config.dart';

/// 問題文や解説文に付随する画像を表示するコンポーネント
/// 
/// 第2次精査版: エッジケース（空URL）、全画面エラー対応、UX（成功時のみ拡大可能）を強化。
class QuestionImage extends StatefulWidget {
  final String imageUrl;
  final double maxHeight;
  final String semanticLabel;
  final int? cacheWidth;
  final int? cacheHeight;

  const QuestionImage({
    super.key,
    required this.imageUrl,
    this.maxHeight = 200,
    this.semanticLabel = '問題に関連する画像',
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  State<QuestionImage> createState() => _QuestionImageState();
}

class _QuestionImageState extends State<QuestionImage> {
  Key _imageKey = UniqueKey();
  bool _isLoaded = false;

  void _retry() {
    CachedNetworkImage.evictFromCache(widget.imageUrl);
    setState(() {
      _imageKey = UniqueKey();
      _isLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. 空URLのガード
    if (widget.imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Semantics(
        label: '${widget.semanticLabel}${_isLoaded ? '（タップで拡大）' : ''}',
        image: true,
        child: GestureDetector(
          // 2. 読み込み成功時のみタップ可能にする
          onTap: _isLoaded ? () => _showFullScreen(context) : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: widget.maxHeight),
              child: CachedNetworkImage(
                key: _imageKey,
                imageUrl: widget.imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                memCacheWidth: screenWidth.toInt(),
                maxWidthDiskCache: 1080,
                maxHeightDiskCache: 1080,
                fadeInDuration: const Duration(milliseconds: 200),
                cacheManager: QuestionImageCacheManager.instance,
                // 3. 成功時のみ拡大アイコンを表示
                imageBuilder: (context, imageProvider) {
                  // build中のsetStateを避けるため次フレームで実行
                  if (!_isLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _isLoaded = true);
                    });
                  }
                  
                  return Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Image(
                        image: imageProvider,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.zoom_in,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  );
                },
                placeholder: (context, url) => _buildPlaceholder(),
                errorWidget: (context, url, error) => _buildError(error),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: context.colors.disabled,
      highlightColor: const Color(0x80FFFFFF),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colors.disabled,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildError(dynamic error) {
    final errorType = _classifyError(error);
    
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.disabled,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(errorType.icon, color: context.colors.textSecondary, size: 28),
          const SizedBox(height: 4),
          Text(
            errorType.message,
            style: TextStyle(
              fontSize: 11,
              color: context.colors.textSecondary,
            ),
          ),
          if (errorType.canRetry) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 28,
              child: TextButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh, size: 14),
                label: const Text('再試行', style: TextStyle(fontSize: 11)),
                style: TextButton.styleFrom(
                  foregroundColor: context.colors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static _ErrorType _classifyError(dynamic error) {
    final message = error.toString().toLowerCase();
    if (message.contains('socketexception') || message.contains('handshakeexception')) {
      return _ErrorType.network;
    }
    if (message.contains('404') || message.contains('not found')) {
      return _ErrorType.notFound;
    }
    if (message.contains('403') || message.contains('forbidden')) {
      return _ErrorType.forbidden;
    }
    return _ErrorType.unknown;
  }

  void _showFullScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: const Color(0xE6000000),
        pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 5.0,
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.contain,
                      cacheManager: QuestionImageCacheManager.instance,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.broken_image, color: Colors.white54, size: 48),
                            SizedBox(height: 8),
                            Text(
                              '画像を表示できません',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _ErrorType {
  network('接続エラー', Icons.wifi_off, true),
  notFound('画像が見つかりません', Icons.broken_image, false),
  forbidden('アクセス権限制限', Icons.lock_outline, false),
  unknown('読み込み失敗', Icons.error_outline, true);

  final String message;
  final IconData icon;
  final bool canRetry;

  const _ErrorType(this.message, this.icon, this.canRetry);
}
