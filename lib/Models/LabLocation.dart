class Lablocation {
  String ?locationId;
  String name;
  String address;
  String phone;
  String Workingdays;
  String openinghours;
  String closinghours;
  Lablocation({
       this.locationId,
    required this.name,
    required this.address,
    required this.phone,
    required this.Workingdays,
    required this.openinghours,
    required this.closinghours,
  });
  Map<String, dynamic> toMap() {
    return {
      'locationId': locationId,
      'name': name,
      'address': address,
      'phone': phone,
      'Workingdays': Workingdays,
      'openinghours': openinghours,
      'closinghours': closinghours,
    };
 }
  factory Lablocation.fromMap(Map<String, dynamic> map) {
    return Lablocation(
      locationId: map['locationId'],
      name: map['name'],
      address: map['address'],
      phone: map['phone'],
      Workingdays: map['Workingdays'],
      openinghours: map['openinghours'],
      closinghours: map['closinghours'],
    );
  }
}