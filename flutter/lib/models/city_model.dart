class CityModel {
  final String id;
  final String name;
  final String code;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CityModel({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
