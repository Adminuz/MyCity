class ServiceReview {
  final String name;
  final int rating;
  final String comment;
  final String date;

  ServiceReview({
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ServiceReview.fromJson(Map<String, dynamic> json) {
    return ServiceReview(
      name: json['name'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'rating': rating, 'comment': comment, 'date': date};
  }
}

class ServiceModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final double rating;
  final String price;
  final String phone;
  final String address;
  final String workingHours;
  final String? category;
  final String? city;
  final double? latitude;
  final double? longitude;
  final List<ServiceReview> reviews;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.rating,
    required this.price,
    required this.phone,
    required this.address,
    required this.workingHours,
    this.category,
    this.city,
    this.latitude,
    this.longitude,
    required this.reviews,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      price: json['price'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      workingHours: json['workingHours'] ?? '',
      category: json['category']?.toString(),
      city: json['city']?.toString(),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((review) => ServiceReview.fromJson(review))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'rating': rating,
      'price': price,
      'phone': phone,
      'address': address,
      'workingHours': workingHours,
      'category': category,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }

  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    double? rating,
    String? price,
    String? phone,
    String? address,
    String? workingHours,
    String? category,
    String? city,
    double? latitude,
    double? longitude,
    List<ServiceReview>? reviews,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      workingHours: workingHours ?? this.workingHours,
      category: category ?? this.category,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reviews: reviews ?? this.reviews,
    );
  }
}
