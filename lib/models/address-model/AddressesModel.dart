class AddressesModel {
  final String id;
  final String userId;
  final String firstname;
  final String lastname;
  final String company;
  final String street;
  final String country;
  final String state;
  final String city;
  final String zipcode;
  final String email;
  final String phone;
  final double latitude;
  final double longitude;

  AddressesModel({
    required this.id,
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.company,
    required this.street,
    required this.country,
    required this.state,
    required this.city,
    required this.zipcode,
    required this.email,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  factory AddressesModel.fromJson(Map<String, dynamic> json) {
    return AddressesModel(
      id: json['_id'] ?? '',
      userId: json['userid'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      company: json['company'] ?? '',
      street: json['street'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      zipcode: json['zipcode'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      latitude: double.tryParse(json['lat']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['long']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userid': userId,
      'firstname': firstname,
      'lastname': lastname,
      'company': company,
      'street': street,
      'country': country,
      'state': state,
      'city': city,
      'zipcode': zipcode,
      'email': email,
      'phone': phone,
      'lat': latitude.toString(),
      'long': longitude.toString(),
    };
  }
}
