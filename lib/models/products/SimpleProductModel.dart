import 'package:sugudeni/models/category/SimpleCategoryModel.dart';
import 'package:sugudeni/models/category/SimpleSubCategoryModel.dart';
import 'package:sugudeni/models/products/SellerIdProductReponseModel.dart';

import '../violation/SimpleViolationModel.dart';

class Product {
  final String sku;
  final String supplierName;
  final String brand;
  final String upc;
  final String condition;
  final double shippingPrice;
  final String manufacturerProdId;
  final String shippingLength;
  final String shippingWidth;
  final String shippingHeight;
  final String salesTaxState;
  final String salesTaxPct;
  final String shipFrom;
  final String shipTo;
  final String returnPolicy;
  final String avgShippingDays;
  final double w2bFee;
  final String attributes;
  final double handlingFee;
  final double mapPrice;
  final double wholesale;
  final bool bulk;
  final double saleDiscount;
  final bool featured;
  final double ratingAvg;
  final int ratingCount;
  final String id;
  final SellerIdProductResponseModel sellerId;
  final String title;
  final String imgCover;
  final String weight;
  final String color;
  final String size;
  final List<String> images;
  final String description;
  final double price;
  final double priceAfterDiscount;
  final int quantity;
  final int sold;
  final SimpleCategoryModel? category;
  final SimpleSubCategoryModel? subcategory;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final List<dynamic> reviews;
  final ViolationModel? violation; // New optional field

  Product({
    required this.sku,
    required this.supplierName,
    required this.brand,
    required this.upc,
    required this.condition,
    required this.shippingPrice,
    required this.manufacturerProdId,
    required this.shippingLength,
    required this.shippingWidth,
    required this.shippingHeight,
    required this.salesTaxState,
    required this.salesTaxPct,
    required this.shipFrom,
    required this.shipTo,
    required this.returnPolicy,
    required this.avgShippingDays,
    required this.w2bFee,
    required this.attributes,
    required this.handlingFee,
    required this.mapPrice,
    required this.wholesale,
    required this.bulk,
    required this.saleDiscount,
    required this.featured,
    required this.ratingAvg,
    required this.ratingCount,
    required this.id,
    required this.sellerId,
    required this.title,
    required this.imgCover,
    required this.weight,
    required this.color,
    required this.size,
    required this.images,
    required this.description,
    required this.price,
    required this.priceAfterDiscount,
    required this.quantity,
    required this.sold,
    this.category,
    this.subcategory,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.reviews,
    this.violation
  });
  Product copyWith({
    String? sku,
    String? supplierName,
    String? brand,
    String? upc,
    String? condition,
    double? shippingPrice,
    String? manufacturerProdId,
    String? shippingLength,
    String? shippingWidth,
    String? shippingHeight,
    String? salesTaxState,
    String? salesTaxPct,
    String? shipFrom,
    String? shipTo,
    String? returnPolicy,
    String? avgShippingDays,
    double? w2bFee,
    String? attributes,
    double? handlingFee,
    double? mapPrice,
    double? wholesale,
    bool? bulk,
    double? saleDiscount,
    bool? featured,
    double? ratingAvg,
    int? ratingCount,
    String? id,
    SellerIdProductResponseModel? sellerId,
    String? title,
    String? imgCover,
    String? weight,
    String? color,
    String? size,
    List<String>? images,
    String? description,
    double? price,
    double? priceAfterDiscount,
    int? quantity,
    int? sold,
    SimpleCategoryModel? category,
    SimpleSubCategoryModel? subcategory,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    List<dynamic>? reviews,
  }) {
    return Product(
      sku: sku ?? this.sku,
      supplierName: supplierName ?? this.supplierName,
      brand: brand ?? this.brand,
      upc: upc ?? this.upc,
      condition: condition ?? this.condition,
      shippingPrice: shippingPrice ?? this.shippingPrice,
      manufacturerProdId: manufacturerProdId ?? this.manufacturerProdId,
      shippingLength: shippingLength ?? this.shippingLength,
      shippingWidth: shippingWidth ?? this.shippingWidth,
      shippingHeight: shippingHeight ?? this.shippingHeight,
      salesTaxState: salesTaxState ?? this.salesTaxState,
      salesTaxPct: salesTaxPct ?? this.salesTaxPct,
      shipFrom: shipFrom ?? this.shipFrom,
      shipTo: shipTo ?? this.shipTo,
      returnPolicy: returnPolicy ?? this.returnPolicy,
      avgShippingDays: avgShippingDays ?? this.avgShippingDays,
      w2bFee: w2bFee ?? this.w2bFee,
      attributes: attributes ?? this.attributes,
      handlingFee: handlingFee ?? this.handlingFee,
      mapPrice: mapPrice ?? this.mapPrice,
      wholesale: wholesale ?? this.wholesale,
      bulk: bulk ?? this.bulk,
      saleDiscount: saleDiscount ?? this.saleDiscount,
      featured: featured ?? this.featured,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      title: title ?? this.title,
      imgCover: imgCover ?? this.imgCover,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      size: size ?? this.size,
      images: images ?? this.images,
      description: description ?? this.description,
      price: price ?? this.price,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      quantity: quantity ?? this.quantity,
      sold: sold ?? this.sold,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      reviews: reviews ?? this.reviews,
      violation: violation ?? violation,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    int formatInt(num value) {
      return value.toInt();  // Ensures conversion to int safely
    }
    
    // Fix invalid imgCover from backend (handles cases where backend returns literal strings)
    String rawImgCover = json['imgCover'] ?? '';
    String fixedImgCover = rawImgCover;
    
    // Check if imgCover is invalid (contains backend error strings)
    if (rawImgCover.contains('req.files') || 
        rawImgCover.contains('filename') ||
        (rawImgCover.isNotEmpty && !rawImgCover.startsWith('products/') && !rawImgCover.startsWith('http'))) {
      // Use first image from images array as fallback
      List<String> images = (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [];
      if (images.isNotEmpty) {
        fixedImgCover = images[0];
      } else {
        fixedImgCover = ''; // No fallback available
      }
    }
    
    return Product(
      sku: json['sku'] ?? '',
      supplierName: json['supplier_name'] ?? '',
      brand: json['brand'] ?? '',
      upc: json['upc'] ?? '',
      condition: json['condition'] ?? 'new',
      shippingPrice: (json['shipping_price'] as num?)?.toDouble() ?? 0.0,
      manufacturerProdId: json['manufacturer_prod_id'] ?? '',
      shippingLength: json['shipping_length'] ?? '',
      shippingWidth: json['shipping_width'] ?? '',
      shippingHeight: json['shipping_height'] ?? '',
      salesTaxState: json['sales_tax_state'] ?? '',
      salesTaxPct: json['sales_tax_pct'] ?? '',
      shipFrom: json['ship_from'] ?? '',
      shipTo: json['ship_to'] ?? '',
      returnPolicy: json['return_policy'] ?? '',
      avgShippingDays: json['avg_shipping_days'] ?? '',
      w2bFee: (json['w2b_fee'] as num?)?.toDouble() ?? 0.0,
      attributes: json['attributes'] ?? '',
      handlingFee: (json['handling_fee'] as num?)?.toDouble() ?? 0.0,
      mapPrice: (json['map_price'] as num?)?.toDouble() ?? 0.0,
      wholesale: (json['wholesale'] as num?)?.toDouble() ?? 0.0,
      bulk: json['bulk'] ?? false,
      saleDiscount: (json['saleDiscount'] as num?)?.toDouble() ?? 0.0,
      featured: json['featured'] ?? false,
      ratingAvg: (json['ratingAvg'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['ratingCount'] ?? 0,
      id: json['_id'] ?? '',
      sellerId: SellerIdProductResponseModel.fromJson(json['sellerid']),
      title: json['title'] ?? '',
      imgCover: fixedImgCover, // Use fixed imgCover
      weight: json['weight'] ?? '',
      color: json['color'] ?? '',
      size: json['size'] ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      description: json['descripton'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toDouble() ?? 0.0,
      quantity: formatInt(json['quantity'] ?? 0),  // Convert double to int
      sold: json['sold'] ?? 0,
      category: json['category'] != null ? SimpleCategoryModel.fromJson(json['category']) : null, // Handle optional violation
      subcategory: json['subcategory'] != null ? SimpleSubCategoryModel.fromJson(json['subcategory']) : null, // Handle optional violation
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      v: json['__v'] ?? 0,
      reviews: json['reviews'] ?? [],
      violation: json['violation'] != null ? ViolationModel.fromJson(json['violation']) : null, // Handle optional violation

    );
  }
  
  /// Get a valid image URL for display
  /// Falls back to first image from images array if imgCover is invalid
  String getValidImageUrl() {
    // Check if imgCover is invalid
    if (imgCover.contains('req.files') || 
        imgCover.contains('filename') ||
        (imgCover.isNotEmpty && !imgCover.startsWith('products/') && !imgCover.startsWith('http'))) {
      // Use first image from images array as fallback
      if (images.isNotEmpty) {
        return images[0];
      }
      return imgCover; // Return original if no fallback
    }
    return imgCover;
  }
  Map<String, dynamic> toJson() {
    return {
      'sku': sku,
      'supplier_name': supplierName,
      'brand': brand,
      'upc': upc,
      'condition': condition,
      'shipping_price': shippingPrice,
      'manufacturer_prod_id': manufacturerProdId,
      'shipping_length': shippingLength,
      'shipping_width': shippingWidth,
      'shipping_height': shippingHeight,
      'sales_tax_state': salesTaxState,
      'sales_tax_pct': salesTaxPct,
      'ship_from': shipFrom,
      'ship_to': shipTo,
      'return_policy': returnPolicy,
      'avg_shipping_days': avgShippingDays,
      'w2b_fee': w2bFee,
      'attributes': attributes,
      'handling_fee': handlingFee,
      'map_price': mapPrice,
      'wholesale': wholesale,
      'bulk': bulk,
      'saleDiscount': saleDiscount,
      'featured': featured,
      'ratingAvg': ratingAvg,
      'ratingCount': ratingCount,
      '_id': id,
      'sellerid': sellerId.toJson(),
      'title': title,
      'imgCover': imgCover,
      'weight': weight,
      'color': color,
      'size': size,
      'images': images,
      'descripton': description,
      'price': price,
      'priceAfterDiscount': priceAfterDiscount,
      'quantity': quantity,
      'sold': sold,
      'category': category!.toJson(),
      'subcategory': subcategory!.toJson(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'reviews': reviews,
      if (violation != null) "violation": violation!.toJson(), // Include violation only if it exists

    };
  }

}
String? extractCategoryId(dynamic category) {
  if (category == null) return null;
  if (category is String) return category;
  if (category is Map<String, dynamic> && category.containsKey('_id')) {
    return category['_id'];
  }
  return null;
}

// class ProductForSafe {
//   final String sku;
//   final String supplierName;
//   final String brand;
//   final String upc;
//   final String condition;
//   final double shippingPrice;
//   final String manufacturerProdId;
//   final String shippingLength;
//   final String shippingWidth;
//   final String shippingHeight;
//   final String salesTaxState;
//   final String salesTaxPct;
//   final String shipFrom;
//   final String shipTo;
//   final String returnPolicy;
//   final String avgShippingDays;
//   final double w2bFee;
//   final String attributes;
//   final double handlingFee;
//   final double mapPrice;
//   final double wholesale;
//   final bool bulk;
//   final double saleDiscount;
//   final bool featured;
//   final double ratingAvg;
//   final int ratingCount;
//   final String id;
//   final String sellerId;
//   final String title;
//   final String imgCover;
//   final String weight;
//   final String color;
//   final String size;
//   final List<String> images;
//   final String description;
//   final double price;
//   final double priceAfterDiscount;
//   final int quantity;
//   final int sold;
//   final String category;
//   final String subcategory;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int v;
//   final List<dynamic> reviews;
//
//   ProductForSafe({
//     required this.sku,
//     required this.supplierName,
//     required this.brand,
//     required this.upc,
//     required this.condition,
//     required this.shippingPrice,
//     required this.manufacturerProdId,
//     required this.shippingLength,
//     required this.shippingWidth,
//     required this.shippingHeight,
//     required this.salesTaxState,
//     required this.salesTaxPct,
//     required this.shipFrom,
//     required this.shipTo,
//     required this.returnPolicy,
//     required this.avgShippingDays,
//     required this.w2bFee,
//     required this.attributes,
//     required this.handlingFee,
//     required this.mapPrice,
//     required this.wholesale,
//     required this.bulk,
//     required this.saleDiscount,
//     required this.featured,
//     required this.ratingAvg,
//     required this.ratingCount,
//     required this.id,
//     required this.sellerId,
//     required this.title,
//     required this.imgCover,
//     required this.weight,
//     required this.color,
//     required this.size,
//     required this.images,
//     required this.description,
//     required this.price,
//     required this.priceAfterDiscount,
//     required this.quantity,
//     required this.sold,
//     required this.category,
//     required this.subcategory,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.reviews,
//   });
//   ProductForSafe copyWith({
//     String? sku,
//     String? supplierName,
//     String? brand,
//     String? upc,
//     String? condition,
//     double? shippingPrice,
//     String? manufacturerProdId,
//     String? shippingLength,
//     String? shippingWidth,
//     String? shippingHeight,
//     String? salesTaxState,
//     String? salesTaxPct,
//     String? shipFrom,
//     String? shipTo,
//     String? returnPolicy,
//     String? avgShippingDays,
//     double? w2bFee,
//     String? attributes,
//     double? handlingFee,
//     double? mapPrice,
//     double? wholesale,
//     bool? bulk,
//     double? saleDiscount,
//     bool? featured,
//     double? ratingAvg,
//     int? ratingCount,
//     String? id,
//     String? sellerId,
//     String? title,
//     String? imgCover,
//     String? weight,
//     String? color,
//     String? size,
//     List<String>? images,
//     String? description,
//     double? price,
//     double? priceAfterDiscount,
//     int? quantity,
//     int? sold,
//     String? category,
//     String? subcategory,
//     String? status,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     int? v,
//     List<dynamic>? reviews,
//   }) {
//     return ProductForSafe(
//       sku: sku ?? this.sku,
//       supplierName: supplierName ?? this.supplierName,
//       brand: brand ?? this.brand,
//       upc: upc ?? this.upc,
//       condition: condition ?? this.condition,
//       shippingPrice: shippingPrice ?? this.shippingPrice,
//       manufacturerProdId: manufacturerProdId ?? this.manufacturerProdId,
//       shippingLength: shippingLength ?? this.shippingLength,
//       shippingWidth: shippingWidth ?? this.shippingWidth,
//       shippingHeight: shippingHeight ?? this.shippingHeight,
//       salesTaxState: salesTaxState ?? this.salesTaxState,
//       salesTaxPct: salesTaxPct ?? this.salesTaxPct,
//       shipFrom: shipFrom ?? this.shipFrom,
//       shipTo: shipTo ?? this.shipTo,
//       returnPolicy: returnPolicy ?? this.returnPolicy,
//       avgShippingDays: avgShippingDays ?? this.avgShippingDays,
//       w2bFee: w2bFee ?? this.w2bFee,
//       attributes: attributes ?? this.attributes,
//       handlingFee: handlingFee ?? this.handlingFee,
//       mapPrice: mapPrice ?? this.mapPrice,
//       wholesale: wholesale ?? this.wholesale,
//       bulk: bulk ?? this.bulk,
//       saleDiscount: saleDiscount ?? this.saleDiscount,
//       featured: featured ?? this.featured,
//       ratingAvg: ratingAvg ?? this.ratingAvg,
//       ratingCount: ratingCount ?? this.ratingCount,
//       id: id ?? this.id,
//       sellerId: sellerId ?? this.sellerId,
//       title: title ?? this.title,
//       imgCover: imgCover ?? this.imgCover,
//       weight: weight ?? this.weight,
//       color: color ?? this.color,
//       size: size ?? this.size,
//       images: images ?? this.images,
//       description: description ?? this.description,
//       price: price ?? this.price,
//       priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
//       quantity: quantity ?? this.quantity,
//       sold: sold ?? this.sold,
//       category: category ?? this.category,
//       subcategory: subcategory ?? this.subcategory,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       v: v ?? this.v,
//       reviews: reviews ?? this.reviews,
//     );
//   }
//
//   factory ProductForSafe.fromJson(Map<String, dynamic> json) {
//     int formatInt(num value) {
//       return value.toInt();  // Ensures conversion to int safely
//     }
//     return ProductForSafe(
//       sku: json['sku'] ?? '',
//       supplierName: json['supplier_name'] ?? '',
//       brand: json['brand'] ?? '',
//       upc: json['upc'] ?? '',
//       condition: json['condition'] ?? 'new',
//       shippingPrice: (json['shipping_price'] as num?)?.toDouble() ?? 0.0,
//       manufacturerProdId: json['manufacturer_prod_id'] ?? '',
//       shippingLength: json['shipping_length'] ?? '',
//       shippingWidth: json['shipping_width'] ?? '',
//       shippingHeight: json['shipping_height'] ?? '',
//       salesTaxState: json['sales_tax_state'] ?? '',
//       salesTaxPct: json['sales_tax_pct'] ?? '',
//       shipFrom: json['ship_from'] ?? '',
//       shipTo: json['ship_to'] ?? '',
//       returnPolicy: json['return_policy'] ?? '',
//       avgShippingDays: json['avg_shipping_days'] ?? '',
//       w2bFee: (json['w2b_fee'] as num?)?.toDouble() ?? 0.0,
//       attributes: json['attributes'] ?? '',
//       handlingFee: (json['handling_fee'] as num?)?.toDouble() ?? 0.0,
//       mapPrice: (json['map_price'] as num?)?.toDouble() ?? 0.0,
//       wholesale: (json['wholesale'] as num?)?.toDouble() ?? 0.0,
//       bulk: json['bulk'] ?? false,
//       saleDiscount: (json['saleDiscount'] as num?)?.toDouble() ?? 0.0,
//       featured: json['featured'] ?? false,
//       ratingAvg: (json['ratingAvg'] as num?)?.toDouble() ?? 0.0,
//       ratingCount: json['ratingCount'] ?? 0,
//       id: json['_id'] ?? '',
//       sellerId: json['sellerid']??'',
//       title: json['title'] ?? '',
//       imgCover: json['imgCover'] ?? '',
//       weight: json['weight'] ?? '',
//       color: json['color'] ?? '',
//       size: json['size'] ?? '',
//       images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
//       description: json['descripton'] ?? '',
//       price: (json['price'] as num?)?.toDouble() ?? 0.0,
//       priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toDouble() ?? 0.0,
//       quantity: formatInt(json['quantity'] ?? 0),  // Convert double to int
//       sold: json['sold'] ?? 0,
//       category: json['category'] ?? '',
//       subcategory: json['subcategory'] ?? '',
//       status: json['status'] ?? '',
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
//       v: json['__v'] ?? 0,
//       reviews: json['reviews'] ?? [],
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'sku': sku,
//       'supplier_name': supplierName,
//       'brand': brand,
//       'upc': upc,
//       'condition': condition,
//       'shipping_price': shippingPrice,
//       'manufacturer_prod_id': manufacturerProdId,
//       'shipping_length': shippingLength,
//       'shipping_width': shippingWidth,
//       'shipping_height': shippingHeight,
//       'sales_tax_state': salesTaxState,
//       'sales_tax_pct': salesTaxPct,
//       'ship_from': shipFrom,
//       'ship_to': shipTo,
//       'return_policy': returnPolicy,
//       'avg_shipping_days': avgShippingDays,
//       'w2b_fee': w2bFee,
//       'attributes': attributes,
//       'handling_fee': handlingFee,
//       'map_price': mapPrice,
//       'wholesale': wholesale,
//       'bulk': bulk,
//       'saleDiscount': saleDiscount,
//       'featured': featured,
//       'ratingAvg': ratingAvg,
//       'ratingCount': ratingCount,
//       '_id': id,
//       'sellerid': sellerId,
//       'title': title,
//       'imgCover': imgCover,
//       'weight': weight,
//       'color': color,
//       'size': size,
//       'images': images,
//       'descripton': description,
//       'price': price,
//       'priceAfterDiscount': priceAfterDiscount,
//       'quantity': quantity,
//       'sold': sold,
//       'category': category,
//       'subcategory': subcategory,
//       'status': status,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       '__v': v,
//       'reviews': reviews,
//     };
//   }
//
// }
