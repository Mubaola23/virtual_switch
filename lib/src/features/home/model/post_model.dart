class PostModel {
  final int id;
  final String title;
  final String body;
  final String category;
  final DateTime date;
  final String imageUrl;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.date,
    required this.imageUrl,
  });

  // Factory constructor to create a PostModel from JSON
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      imageUrl: json['imageUrl'],
    );
  }

  // Convert PostModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'category': category,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}
