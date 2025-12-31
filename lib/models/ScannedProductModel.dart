/// code : "781138811156"
/// codeType : "UPC"
/// product : {"name":"On the Border Jalapeno, Queso Flavored, Spicy 15.25 Oz","description":"Mexican grill & cantina. Spicy. Made with real cheese. Safety button pops up when original seal is broken.","region":"USA or Canada","imageUrl":"https://go-upc.s3.amazonaws.com/images/99132458.jpeg","brand":"On the Border","specs":[["Department","Pantry"],["Allergens","Contains Soybean And Its Derivatives,milk And Its Derivates."],["Category","Salsa, Cheese Sauce, & Dip"],["Length","4.0 In"],["Width","4.0 In"],["Non-GMO","No"],["Ingredients","Water, Monterey Jack Cheese (milk, Cheese Cultures, Salt, Enzymes), Jalapeno Peppers, Soybean Oil, Maltodextrin, Modified Corn Starch, Whey Protein Concentrate, Contains Less Than 2% Of: Green Chiles, Salt, Diced Tomatoes In Juice, Sodium Phosphate, Natural Flavors, Datem, Sodium Citrate, Lactic Acid, Vinegar, Sodium Alginate, Sorbic Acid (preservative), Xanthan Gum, Dried Red And/or Green Bell Peppers, Spices, Dried Onions, Dried Garlic, Yellow 5 & Yellow 6, Tomato Powder."],["Commodity","Snacks"],["Height","4.88 In"],["Organic","No"]],"category":"Salsa","categoryPath":["Food, Beverages & Tobacco","Food Items","Dips & Spreads","Salsa"],"ingredients":{"text":"Water, Monterey Jack Cheese (milk, Cheese Cultures, Salt, Enzymes), Jalapeno Peppers, Soybean Oil, Maltodextrin, Modified Corn Starch, Whey Protein Concentrate, Contains Less Than 2% Of: Green Chiles, Salt, Diced Tomatoes In Juice, Sodium Phosphate, Natural Flavor, Datem, Sodium Citrate, Lactic Acid, Vinegar, Sodium Alginate, Sorbic Acid (preservative), Xanthan Gum, Red And/or Green Bell Peppers (dried), Spices, Dried Onion, Dried Garlic, Artificial Color (yellow 5 & Yellow 6), Tomato Powder."},"upc":781138811156,"ean":781138811156}
/// barcodeUrl : "https://go-upc.com/barcode/781138811156"
/// inferred : false

class ScannedProductModel {
  ScannedProductModel({
      String? code, 
      String? codeType, 
      Product? product, 
      String? barcodeUrl, 
      bool? inferred,}){
    _code = code;
    _codeType = codeType;
    _product = product;
    _barcodeUrl = barcodeUrl;
    _inferred = inferred;
}

  ScannedProductModel.fromJson(dynamic json) {
    _code = json['code'];
    _codeType = json['codeType'];
    _product = json['product'] != null ? Product.fromJson(json['product']) : null;
    _barcodeUrl = json['barcodeUrl'];
    _inferred = json['inferred'];
  }
  String? _code;
  String? _codeType;
  Product? _product;
  String? _barcodeUrl;
  bool? _inferred;
ScannedProductModel copyWith({  String? code,
  String? codeType,
  Product? product,
  String? barcodeUrl,
  bool? inferred,
}) => ScannedProductModel(  code: code ?? _code,
  codeType: codeType ?? _codeType,
  product: product ?? _product,
  barcodeUrl: barcodeUrl ?? _barcodeUrl,
  inferred: inferred ?? _inferred,
);
  String? get code => _code;
  String? get codeType => _codeType;
  Product? get product => _product;
  String? get barcodeUrl => _barcodeUrl;
  bool? get inferred => _inferred;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['codeType'] = _codeType;
    if (_product != null) {
      map['product'] = _product?.toJson();
    }
    map['barcodeUrl'] = _barcodeUrl;
    map['inferred'] = _inferred;
    return map;
  }

}

/// name : "On the Border Jalapeno, Queso Flavored, Spicy 15.25 Oz"
/// description : "Mexican grill & cantina. Spicy. Made with real cheese. Safety button pops up when original seal is broken."
/// region : "USA or Canada"
/// imageUrl : "https://go-upc.s3.amazonaws.com/images/99132458.jpeg"
/// brand : "On the Border"
/// specs : [["Department","Pantry"],["Allergens","Contains Soybean And Its Derivatives,milk And Its Derivates."],["Category","Salsa, Cheese Sauce, & Dip"],["Length","4.0 In"],["Width","4.0 In"],["Non-GMO","No"],["Ingredients","Water, Monterey Jack Cheese (milk, Cheese Cultures, Salt, Enzymes), Jalapeno Peppers, Soybean Oil, Maltodextrin, Modified Corn Starch, Whey Protein Concentrate, Contains Less Than 2% Of: Green Chiles, Salt, Diced Tomatoes In Juice, Sodium Phosphate, Natural Flavors, Datem, Sodium Citrate, Lactic Acid, Vinegar, Sodium Alginate, Sorbic Acid (preservative), Xanthan Gum, Dried Red And/or Green Bell Peppers, Spices, Dried Onions, Dried Garlic, Yellow 5 & Yellow 6, Tomato Powder."],["Commodity","Snacks"],["Height","4.88 In"],["Organic","No"]]
/// category : "Salsa"
/// categoryPath : ["Food, Beverages & Tobacco","Food Items","Dips & Spreads","Salsa"]
/// ingredients : {"text":"Water, Monterey Jack Cheese (milk, Cheese Cultures, Salt, Enzymes), Jalapeno Peppers, Soybean Oil, Maltodextrin, Modified Corn Starch, Whey Protein Concentrate, Contains Less Than 2% Of: Green Chiles, Salt, Diced Tomatoes In Juice, Sodium Phosphate, Natural Flavor, Datem, Sodium Citrate, Lactic Acid, Vinegar, Sodium Alginate, Sorbic Acid (preservative), Xanthan Gum, Red And/or Green Bell Peppers (dried), Spices, Dried Onion, Dried Garlic, Artificial Color (yellow 5 & Yellow 6), Tomato Powder."}
/// upc : 781138811156
/// ean : 781138811156

class Product {
  Product({
      String? name, 
      String? description, 
      String? region, 
      String? imageUrl, 
      String? brand, 
      List<List<String>>? specs, 
      String? category, 
      List<String>? categoryPath, 
      Ingredients? ingredients, 
      num? upc, 
      num? ean,}){
    _name = name;
    _description = description;
    _region = region;
    _imageUrl = imageUrl;
    _brand = brand;
    _specs = specs;
    _category = category;
    _categoryPath = categoryPath;
    _ingredients = ingredients;
    _upc = upc;
    _ean = ean;
}
  Product.fromJson(dynamic json) {
    _name = json['name'];
    _description = json['description'];
    _region = json['region'];
    _imageUrl = json['imageUrl'];
    _brand = json['brand'];

    // Properly handling specs as List<List<String>>
    _specs = json['specs'] != null ? List<List<String>>.from(json['specs'].map((e) => List<String>.from(e))) : [];

    _category = json['category'];
    _categoryPath = json['categoryPath'] != null ? List<String>.from(json['categoryPath']) : [];
    _ingredients = json['ingredients'] != null ? Ingredients.fromJson(json['ingredients']) : null;
    _upc = json['upc'];
    _ean = json['ean'];
  }

  String? _name;
  String? _description;
  String? _region;
  String? _imageUrl;
  String? _brand;
  List<List<String>>? _specs;
  String? _category;
  List<String>? _categoryPath;
  Ingredients? _ingredients;
  num? _upc;
  num? _ean;
Product copyWith({  String? name,
  String? description,
  String? region,
  String? imageUrl,
  String? brand,
  List<List<String>>? specs,
  String? category,
  List<String>? categoryPath,
  Ingredients? ingredients,
  num? upc,
  num? ean,
}) => Product(  name: name ?? _name,
  description: description ?? _description,
  region: region ?? _region,
  imageUrl: imageUrl ?? _imageUrl,
  brand: brand ?? _brand,
  specs: specs ?? _specs,
  category: category ?? _category,
  categoryPath: categoryPath ?? _categoryPath,
  ingredients: ingredients ?? _ingredients,
  upc: upc ?? _upc,
  ean: ean ?? _ean,
);
  String? get name => _name;
  String? get description => _description;
  String? get region => _region;
  String? get imageUrl => _imageUrl;
  String? get brand => _brand;
  List<List<String>>? get specs => _specs;
  String? get category => _category;
  List<String>? get categoryPath => _categoryPath;
  Ingredients? get ingredients => _ingredients;
  num? get upc => _upc;
  num? get ean => _ean;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['description'] = _description;
    map['region'] = _region;
    map['imageUrl'] = _imageUrl;
    map['brand'] = _brand;
    map['specs'] = _specs;
    map['category'] = _category;
    map['categoryPath'] = _categoryPath;
    if (_ingredients != null) {
      map['ingredients'] = _ingredients?.toJson();
    }
    map['upc'] = _upc;
    map['ean'] = _ean;
    return map;
  }

}

/// text : "Water, Monterey Jack Cheese (milk, Cheese Cultures, Salt, Enzymes), Jalapeno Peppers, Soybean Oil, Maltodextrin, Modified Corn Starch, Whey Protein Concentrate, Contains Less Than 2% Of: Green Chiles, Salt, Diced Tomatoes In Juice, Sodium Phosphate, Natural Flavor, Datem, Sodium Citrate, Lactic Acid, Vinegar, Sodium Alginate, Sorbic Acid (preservative), Xanthan Gum, Red And/or Green Bell Peppers (dried), Spices, Dried Onion, Dried Garlic, Artificial Color (yellow 5 & Yellow 6), Tomato Powder."

class Ingredients {
  Ingredients({
      String? text,}){
    _text = text;
}

  Ingredients.fromJson(dynamic json) {
    _text = json['text'];
  }
  String? _text;
Ingredients copyWith({  String? text,
}) => Ingredients(  text: text ?? _text,
);
  String? get text => _text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    return map;
  }

}