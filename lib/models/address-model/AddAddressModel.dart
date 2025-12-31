class AddAddressModel {
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
  final String lat;
  final String long;

  AddAddressModel({
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
    required this.lat,
    required this.long,
  });

  factory AddAddressModel.fromJson(Map<String, dynamic> json) {
    return AddAddressModel(
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
      lat: json['lat'] ?? '',
      long: json['long'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'lat': lat,
      'long': long,
    };
  }
}
