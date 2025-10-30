class LabTest {
  final String id;
  final String name;
  final double price;
  final int durationMinutes;

  LabTest({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMinutes,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'durationMinutes': durationMinutes,
    };
  }

  factory LabTest.fromMap(String id, Map<String, dynamic> map) {
    return LabTest(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      durationMinutes: (map['durationMinutes'] ?? 0).toInt(),
    );
  }
}
