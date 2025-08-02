import 'package:flutter/material.dart';
import 'service_info_item.dart';

class ServiceInfoSection extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceInfoSection({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          ServiceInfoItem(
            icon: Icons.access_time,
            title: 'Ish vaqti',
            content: service['workingHours'] ?? 'Ma\'lumot yo\'q',
            iconColor: Colors.blue,
          ),
          const Divider(height: 16),
          ServiceInfoItem(
            icon: Icons.place,
            title: 'Manzil',
            content: service['address'] ?? 'Ma\'lumot yo\'q',
            iconColor: Colors.red,
          ),
          const Divider(height: 16),
          ServiceInfoItem(
            icon: Icons.phone_in_talk,
            title: 'Telefon',
            content: service['phone'] ?? 'Ma\'lumot yo\'q',
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
