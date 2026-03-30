import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 問題文や解説文に付随する内蔵画像を表示するコンポーネント
class QuestionImage extends StatelessWidget {
  final String imageUrl; // 内蔵画像のパス (例: assets/images/sample.png)
  final double maxHeight;
  final String semanticLabel;

  const QuestionImage({
    super.key,
    required this.imageUrl,
    this.maxHeight = 200,
    this.semanticLabel = '問題に関連する画像',
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Semantics(
        label: '$semanticLabel（タップで拡大）',
        image: true,
        child: GestureDetector(
          onTap: () => _showFullScreen(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Image.asset(
                    imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => _buildError(context),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
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
          Icon(Icons.broken_image, color: context.colors.textSecondary, size: 28),
          const SizedBox(height: 4),
          Text(
            '画像が見つかりません',
            style: TextStyle(
              fontSize: 11,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
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
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Center(
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
