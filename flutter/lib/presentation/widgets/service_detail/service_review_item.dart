import 'package:flutter/material.dart';

class ServiceReviewItem extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;

  const ServiceReviewItem({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: Colors.teal, size: 12),
                ),
                const SizedBox(width: 6),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: index < rating ? Colors.amber : Colors.grey.shade300,
                    size: 16,
                  );
                }),
                const SizedBox(width: 4),
                Text(
                  '($rating/5)',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          comment,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
