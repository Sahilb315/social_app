import 'package:flutter/material.dart';

class HashtagView extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextOverflow textOverflow;
  final double textSize;
  const HashtagView({
    super.key,
    required this.text,
    required this.maxLines,
    required this.textOverflow,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> textSpans = [];
    text.split(' ').forEach(
      (element) {
        if (element.startsWith('#')) {
          textSpans.add(
            TextSpan(
              text: "$element ",
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (element.startsWith("www.") ||
            element.startsWith("https://")) {
          textSpans.add(
            TextSpan(
              text: "$element ",
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
          );
        } else {
          textSpans.add(
            TextSpan(
              text: "$element ",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          );
        }
      },
    );

    return RichText(
      text: TextSpan(
        children: textSpans,
        style: TextStyle(
          fontSize: textSize,
        ),
      ),
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }
}
