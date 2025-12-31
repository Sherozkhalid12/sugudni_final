class AddSaleToProductModel {
  final double discount;

  AddSaleToProductModel({required this.discount});

  factory AddSaleToProductModel.fromJson(Map<String, dynamic> json) {
    return AddSaleToProductModel(
      discount: json['discount'], // Ensures discount is always double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discount': discount,
    };
  }
}
