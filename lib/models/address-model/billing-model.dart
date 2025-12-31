class BillingAddressModel {
  final String id;
  final String firstName;
  final String lastName;
  final String company;
  final String street;
  final String country;
  final String state;
  final String zipcode;
  final String email;
  final String phone;

  BillingAddressModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.street,
    required this.country,
    required this.state,
    required this.zipcode,
    required this.email,
    required this.phone,
  });

  factory BillingAddressModel.fromJson(Map<String, dynamic> json) {
    return BillingAddressModel(
      id: json['_id'],
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      company: json['company'] ?? '',
      street: json['street'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      zipcode: json['zipcode'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "firstname": firstName,
      "lastname": lastName,
      "company": company,
      "street": street,
      "country": country,
      "state": state,
      "zipcode": zipcode,
      "email": email,
      "phone": phone,
    };
  }
  Map<String, dynamic> toJsonShippingUpdate() {
    return {
      "shippingAddress": {
        "firstname": firstName,
        "lastname": lastName,
        "company": company,
        "street": street,
        "country": country,
        "state": state,
        "zipcode": zipcode,
        "email": email,
        "phone": phone,
      }
    };
  }
  Map<String, dynamic> toJsonBillingUpdate() {
    return {
      "billingAddress": {
        "firstname": firstName,
        "lastname": lastName,
        "company": company,
        "street": street,
        "country": country,
        "state": state,
        "zipcode": zipcode,
        "email": email,
        "phone": phone,
      }
    };
  }


}
