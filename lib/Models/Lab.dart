import 'package:lablink/Models/LabLocation.dart';

class Lab {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<LabLocation> locations;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final String closingTime;
  final int testsCount;
  final int? usersCount;
  double lastMonthRevenue = 0.0;

  Lab({
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.closingTime,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.testsCount,
    required this.usersCount,
    required this.lastMonthRevenue,
    this.locations = const [],
  });

  final String imageUrl = 'assets/images/labs.jpeg';

  factory Lab.fromMap(
    Map<String, dynamic> data, {
    String? id,
    List<LabLocation>? locations,
    int? testsCount,
    int? usersCount,
    double? lastMonthRevenue,
  }) {
    return Lab(
      id: id ?? data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      rating: (data['labRating'] ?? 0).toDouble(),
      locations: locations ?? [],
      reviewCount: data['reviewCount'],
      distanceKm: data['distanceKm'],
      closingTime: data['closingTime'],
      testsCount: testsCount ?? 0,
      usersCount: usersCount ?? 0,
      lastMonthRevenue: lastMonthRevenue ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'locations': locations.map((location) => location.toMap()).toList(),
      'rating': rating,
      'reviewCount': reviewCount,
      'distanceKm': distanceKm,
      'closingTime': closingTime,
      'imageUrl': imageUrl,
    };
  }
}
