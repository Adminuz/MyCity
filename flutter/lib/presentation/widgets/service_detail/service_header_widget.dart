import 'package:flutter/material.dart';

class ServiceHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceHeaderWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    print('ServiceHeaderWidget: отображаем рейтинг ${service['rating']}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Название и рейтинг
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                service['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withValues(alpha: 0.1),
                    Colors.orange.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 3),
                  Text(
                    (service['rating'] as num).toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Описание
        Text(
          service['description'],
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
