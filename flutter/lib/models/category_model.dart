import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String iconName;
  final String colorName;
  final String? description;
  final int? serviceCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorName,
    this.description,
    this.serviceCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      iconName: json['icon']?.toString() ?? 'category',
      colorName: json['color']?.toString() ?? 'blue',
      description: json['description']?.toString(),
      serviceCount: json['service_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': iconName,
      'color': colorName,
      'description': description,
      'service_count': serviceCount,
    };
  }

  /// Получение иконки по имени
  IconData get icon {
    switch (iconName.toLowerCase()) {
      case 'store':
        return Icons.store;
      case 'menu_book':
        return Icons.menu_book;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'theater_comedy':
        return Icons.theater_comedy;
      case 'build':
        return Icons.build;
      case 'category':
        return Icons.category;
      case 'card_travel':
        return Icons.card_travel;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'face_retouching_natural':
        return Icons.face_retouching_natural;
      default:
        return Icons.category;
    }
  }

  /// Получение цвета по имени
  Color get color {
    switch (colorName.toLowerCase()) {
      case 'indigo':
        return Colors.indigo;
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'amber':
        return Colors.amber;
      case 'teal':
        return Colors.teal;
      case 'redaccent':
        return Colors.redAccent;
      case 'deeppurple':
        return Colors.deepPurple;
      case 'pink':
        return Colors.pink;
      default:
        return Colors.blue;
    }
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, iconName: $iconName, colorName: $colorName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
