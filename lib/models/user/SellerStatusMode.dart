class SellerStatModel {
  final String message;
  final List<dynamic> orders;
  final List<OrderStat> orderStats;
  final ReviewStat reviewStats;

  SellerStatModel({
    required this.message,
    required this.orders,
    required this.orderStats,
    required this.reviewStats,
  });

  factory SellerStatModel.fromJson(Map<String, dynamic> json) {
    return SellerStatModel(
      message: json['message'] ?? '',
      orders: json['orders'] ?? [],
      orderStats: (json['orderStats'] as List<dynamic>?)
          ?.map((e) => OrderStat.fromJson(e))
          .toList() ??
          [],
      reviewStats: ReviewStat.fromJson(json['reviewStats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'orders': orders,
      'orderStats': orderStats.map((e) => e.toJson()).toList(),
      'reviewStats': reviewStats.toJson(),
    };
  }
}

class OrderStat {
  final String status;
  final List<dynamic> orders;
  final int count;

  OrderStat({
    required this.status,
    required this.orders,
    required this.count,
  });

  factory OrderStat.fromJson(Map<String, dynamic> json) {
    return OrderStat(
      status: json['status'] ?? '',
      orders: json['orders'] ?? [],
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'orders': orders,
      'count': count,
    };
  }
}

class ReviewStat {
  final int reviewsCount;
  final List<dynamic> reviews;

  ReviewStat({
    required this.reviewsCount,
    required this.reviews,
  });

  factory ReviewStat.fromJson(Map<String, dynamic> json) {
    return ReviewStat(
      reviewsCount: json['reviewsCount'] ?? 0,
      reviews: json['reviews'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewsCount': reviewsCount,
      'reviews': reviews,
    };
  }
}
