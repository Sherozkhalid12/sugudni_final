class SimpleSellerModel {
  final String id;

  SimpleSellerModel({required this.id});

  factory SimpleSellerModel.fromJson(Map<String, dynamic> json) {
    return SimpleSellerModel(
      id: json['_id'] ?? '',
    );
  }

  Map<String,dynamic> toJson(){
    return{
      '_id':id
    };
  }

}
