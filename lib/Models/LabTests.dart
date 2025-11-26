class LabTest {
  String id;
  String name;
  String category;
  double price;
  String durationMinutes;
  String sampleType;
  String description;
  String preparation;

  LabTest({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.durationMinutes,
    required this.sampleType,
    required this.description,
    required this.preparation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'duration': durationMinutes,
      'sampleType': sampleType,
      'description': description,
      'preparation': preparation,
    };
  }

  factory LabTest.fromMap(Map<String, dynamic> map) {
    return LabTest(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      durationMinutes: map['duration'] ?? '',
      sampleType: map['sampleType'] ?? '',
      description: map['description'] ?? '',
      preparation: map['preparation'] ?? '',
    );
  }
}
