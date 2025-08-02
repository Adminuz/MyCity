class EventModel {
  final String title;
  final String desc;
  final String date;
  final String? image;

  EventModel({
    required this.title,
    required this.desc,
    required this.date,
    this.image,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      title: json['title'] ?? '',
      desc: json['desc'] ?? json['description'] ?? '',
      date: json['date'] ?? '',
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'desc': desc, 'date': date, 'image': image};
  }
}
