class UpdateCartQuantityModel {
  final int quantity;

  UpdateCartQuantityModel({required this.quantity});

  factory UpdateCartQuantityModel.fromJson(Map<String, dynamic> json) {
    return UpdateCartQuantityModel(
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
    };
  }
}
