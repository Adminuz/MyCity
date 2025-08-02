import 'package:flutter/material.dart';

class ServiceImageWidget extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceImageWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child:
            service['image'].toString().isNotEmpty &&
                service['image'].toString().startsWith('http')
            ? Image.network(
                service['image'],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.teal.withValues(alpha: 0.1),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.teal,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.teal.withValues(alpha: 0.1),
                    child: const Icon(
                      Icons.image,
                      color: Colors.teal,
                      size: 32,
                    ),
                  );
                },
              )
            : Container(
                color: Colors.teal.withValues(alpha: 0.1),
                child: const Icon(Icons.image, color: Colors.teal, size: 32),
              ),
      ),
    );
  }
}
