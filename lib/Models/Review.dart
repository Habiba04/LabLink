import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String userName;
  final String comments;
  final double rating;
  final DateTime? createdAt;

  Review({
    required this.userName,
    required this.comments,
    required this.rating,
    this.createdAt,
  });

  factory Review.fromMap(String id, Map<String, dynamic> data) {
    return Review(
      userName: data['userName'] ?? 'Anonymous',
      comments: data['comments'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] != null)
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'comments': comments,
      'rating': rating,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }
}
