import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product extends ObjectWithNameAndId {
  int? idCategory;
  String? categoryName;
  int? idGroup;
  String? groupName;
  int? idVat;
  String? vatName;
  String? description;
  String? barcode;
  double? price;
  String? image1;
  String? extensionImage1;
  String? image2;
  String? extensionImage2;
  String? image3;
  String? extensionImage3;
  double? vatPercent;
  double? quantity;
  Product({
     id,
     this.idCategory,
     this.categoryName,
     this.idGroup,
     this.groupName,
     this.idVat,
     this.vatName,
     active,
     name,
     this.description,
     this.price,
     this.image1,
     this.extensionImage1,
     this.image2,
     this.extensionImage2,
     this.image3,
     this.extensionImage3,
     this.vatPercent,
     this.barcode,
     this.quantity,
  }): super(active: active,id: id, name: name);

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    idCategory: json["id_category"],
    idGroup: json["id_group"],
    idVat: json["id_vat"],
    vatName: json["vat_name"],
    groupName: json["group_name"],
    active: json["active"],
    name: json["name"],
    description: json["description"],
    barcode: json["barcode"],
    price: double.tryParse(json["price_list"].toString()),
    quantity: double.tryParse(json["quantity"].toString()),
    image1: json["image1"],
    extensionImage1: json["extension_image1"],
    image2: json["image2"],
    extensionImage2: json["extension_image2"],
    extensionImage3: json["extension_image3"],
    image3: json["image3"],
    vatPercent: double.tryParse(json["vat_percent"].toString()),
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "id_category": idCategory,
    "id_group": idGroup,
    "id_vat": idVat,
    "category_name":categoryName,
    "group_name": groupName,
    "vat_name": vatName,
    "active": active,
    "name": name,
    "description": description,
    "barcode": barcode,
    "price_list": price,
    "quantity": quantity,
    "image1": image1,
    "extension_image1": extensionImage1,
    "image2": image2,
    "extension_image2": extensionImage2,
    "image3": image3,
    "extension_image3": extensionImage3,
    "vat_percent": vatPercent,
  };
  static List<Product> fromJsonList(List<dynamic> list){
    List<Product> newList =[];
    for (var item in list) {
      if(item is Product){
        newList.add(item);
      } else {
        Product product = Product.fromJson(item);
        newList.add(product);
      }

    }
    return newList;
  }
}
