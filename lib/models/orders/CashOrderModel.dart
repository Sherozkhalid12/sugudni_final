class CashOrderModel {
  final String shipping;
  final String deliverySlot;

  CashOrderModel({required this.shipping,required this.deliverySlot});

  factory CashOrderModel.fromJson(Map<String, dynamic> json) {
    return CashOrderModel(
      shipping: json['shipping'] ?? 'Unknown Address',
      deliverySlot: json['deliverySlot'] ?? 'Unknown Address',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipping': shipping,
      'deliverySlot': deliverySlot,
    };
  }
}
