class Lablocation {
  String ?locationId;
  String name;
  String address;
  String phone;
  String startday;
  String endday;
  String openinghours;
  String closinghours;
  Lablocation({
       this.locationId,
    required this.name,
    required this.address,
    required this.phone,
    required this.startday,
    required this.endday,
    required this.openinghours,
    required this.closinghours,
  });
  Map<String, dynamic> toMap() {
    return {
      'locationId': locationId,
      'name': name,
      'address': address,
      'phone': phone,
       'startday': startday,
      'endday': endday,
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
      startday: map['startday'],
      endday: map['endday'],
      openinghours: map['openinghours'],
      closinghours: map['closinghours'],
    );
  }
}