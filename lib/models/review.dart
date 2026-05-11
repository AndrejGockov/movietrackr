class Review {
  final String userId;
  final String username;
  final String content;
  final double rating;
  final DateTime timestamp;

  Review({
    required this.userId,
    required this.username,
    required this.content,
    required this.rating,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'username': username,
    'content': content,
    'rating': rating,
    'timestamp': timestamp.toIso8601String(),
  };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    userId: json['userId'],
    username: json['username'],
    content: json['content'],
    rating: (json['rating'] as num).toDouble(),
    timestamp: DateTime.parse(json['timestamp']),
  );
}