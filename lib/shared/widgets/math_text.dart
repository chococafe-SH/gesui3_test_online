import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// テキストとLaTeX数式（$ または $$ で囲まれた部分）が混在する文字列を描画するウィジェット
class MathText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const MathText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = style ?? Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    
    // 数式の文字色もテキストにあわせる
    final mathTextStyle = defaultStyle.copyWith(
      fontFamily: null, // 数式特有のフォントを使うため
    );

    final regex = RegExp(r'(\$\$.*?\$\$|\$.*?\$)', dotAll: true);
    final spans = <InlineSpan>[];
    
    int start = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      
      final matchedText = match.group(0)!;
      if (matchedText.startsWith('\$\$') && matchedText.length >= 4) {
        // ブロック数式
        final tex = matchedText.substring(2, matchedText.length - 2);
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Math.tex(
              tex,
              textStyle: mathTextStyle,
              mathStyle: MathStyle.display,
              onErrorFallback: (e) => Text(matchedText, style: defaultStyle.copyWith(color: Colors.red)),
            ),
          ),
        );
      } else if (matchedText.length >= 2) {
        // インライン数式
        final tex = matchedText.substring(1, matchedText.length - 1);
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Math.tex(
              tex,
              textStyle: mathTextStyle,
              mathStyle: MathStyle.text,
              onErrorFallback: (e) => Text(matchedText, style: defaultStyle.copyWith(color: Colors.red)),
            ),
          ),
        );
      }
      start = match.end;
    }
    
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(
        style: defaultStyle,
        children: spans,
      ),
    );
  }
}
