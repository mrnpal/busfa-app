class Activity {
  final String title;
  final String description;
  final String date;
  final String? imageUrl;

  Activity({
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl,
  });

  factory Activity.fromMap(Map<String, dynamic> data) {
    return Activity(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }
}
