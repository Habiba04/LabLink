class Labtest {
  String id;
  String name;
  String category;
  double price;
  String duration;
  String sampleType;
  String description;
  String preparation;

  Labtest({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.duration,
    required this.sampleType,
    required this.description,
    required this.preparation,
  });
  Future<Map<String, dynamic>> toMap() async {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'duration': duration,
      'sampleType': sampleType,
      'description': description,
      'preparation': preparation,
    };
  }

  factory Labtest.fromMap(Map<String, dynamic> map) {
    return Labtest(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      duration: map['duration'] ?? '',
      sampleType: map['sampleType'] ?? '',
      description: map['description'] ?? '',
      preparation: map['preparation'] ?? '',
    );
  }
}
