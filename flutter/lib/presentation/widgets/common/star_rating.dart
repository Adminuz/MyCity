import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  final Color? color;
  final Color? emptyColor;
  final bool showRatingText;

  const StarRating({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = 16,
    this.color,
    this.emptyColor,
    this.showRatingText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(starCount, (index) {
          double fillAmount = (rating - index).clamp(0.0, 1.0);

          return Stack(
            children: [
              Icon(
                Icons.star_border,
                size: size,
                color: emptyColor ?? Colors.grey.shade300,
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: fillAmount,
                  child: Icon(
                    Icons.star,
                    size: size,
                    color: color ?? Colors.amber,
                  ),
                ),
              ),
            ],
          );
        }),
        if (showRatingText) ...[
          const SizedBox(width: 6),
          Text(
            '${rating.toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: size * 0.75,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
