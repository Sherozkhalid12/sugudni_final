class GetDeliverySlotsModel {
  final String message;
  final List<DeliverySlot> deliverySlots;

  GetDeliverySlotsModel({required this.message, required this.deliverySlots});

  factory GetDeliverySlotsModel.fromJson(Map<String, dynamic> json) {
    return GetDeliverySlotsModel(
      message: json['message'],
      deliverySlots: (json['deliverySlots'] as List)
          .map((slot) => DeliverySlot.fromJson(slot))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'deliverySlots': deliverySlots.map((slot) => slot.toJson()).toList(),
    };
  }
}

class DeliverySlot {
  final String id;
  final String startTime;
  final String endTime;
  final String title;
  final int version;

  DeliverySlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.version,
  });

  factory DeliverySlot.fromJson(Map<String, dynamic> json) {
    return DeliverySlot(
      id: json['_id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      title: json['title'],
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'startTime': startTime,
      'endTime': endTime,
      'title': title,
      '__v': version,
    };
  }
}
