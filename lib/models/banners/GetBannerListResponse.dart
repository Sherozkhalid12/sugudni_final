class GetBannerListResponse {
  final int page;
  final String message;
  final List<BannerModel> getAllProducts;

  GetBannerListResponse({
    required this.page,
    required this.message,
    required this.getAllProducts,
  });

  factory GetBannerListResponse.fromJson(Map<String, dynamic> json) {
    return GetBannerListResponse(
      page: json['page'] as int,
      message: json['message'] as String,
      getAllProducts: (json['getAllProducts'] as List)
          .map((e) => BannerModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'message': message,
      'getAllProducts': getAllProducts.map((e) => e.toJson()).toList(),
    };
  }
}

class BannerModel {
  final String id;
  final String tag;
  final String title;
  final String tagline;
  final String link;
  final String position;
  final String banner;
  final List<dynamic> products;
  final int v;

  BannerModel({
    required this.id,
    required this.tag,
    required this.title,
    required this.tagline,
    required this.link,
    required this.position,
    required this.banner,
    required this.products,
    required this.v,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'] as String,
      tag: json['tag'] as String,
      title: json['title'] as String,
      tagline: json['tagline'] as String,
      link: json['link'] as String,
      position: json['position'] as String,
      banner: json['banner'] as String,
      products: json['products'] as List<dynamic>,
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'tag': tag,
      'title': title,
      'tagline': tagline,
      'link': link,
      'position': position,
      'banner': banner,
      'products': products,
      '__v': v,
    };
  }
}
