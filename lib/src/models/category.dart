import 'dart:convert';

import 'object_with_name_and_id.dart';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category extends ObjectWithNameAndId{

  //int? id;
  int? idVat;
  String? vatName;
  //String? name;
  String? image;
  String? extensionImage;
  String? description;
  double? vat_percent;
  String? imageToDelete;

  Category({
    id,
    this.idVat,
    name,
    this.vatName,
    this.vat_percent,
    this.image,
    this.description,
    this.imageToDelete,
    this.extensionImage,
    active,

  }): super(active: active,id: id, name: name);


  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    idVat: json["id_vat"],
    vatName: json["vat_name"],
    vat_percent: double.tryParse(json["vat_percent"].toString()),
    name: json["name"],
    image: json["image"],
    imageToDelete: json["image_to_delete"],
    active: json["active"],
    description: json["description"],
    extensionImage: json["extension_image"],
  );
  static List<Category> fromJsonList(List<dynamic> list){
    List<Category> newList =[];
    for (var item in list) {
      if(item is Category){
        newList.add(item);
      } else {
        Category category = Category.fromJson(item);
        newList.add(category);
      }

    }
    return newList;
  }

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "id_vat": idVat,
    "vat_name" : vatName,
    "vat_percent" : vat_percent,
    "name": name,
    "description": description,
    "image": image,
    "active":active,
    "image_to_delete": imageToDelete,
  };
}
