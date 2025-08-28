import 'dart:convert';

import 'object_with_name_and_id.dart';

ProductPriceByGroup productPriceByGroupFromJson(String str) => ProductPriceByGroup.fromJson(json.decode(str));

String productPriceByGroupToJson(ProductPriceByGroup data) => json.encode(data.toJson());

class ProductPriceByGroup extends ObjectWithNameAndId {

  int? idProduct;
  int? idGroup;
  double? price;
  double? quantity;
  double? vatPercent;
  int? priceIncludingVat;

  ProductPriceByGroup({
    id,
    name,
    this.price,
    this.idGroup,
    this.idProduct,
    this.quantity,
    this.vatPercent,
    this.priceIncludingVat,
    active,
  }): super(active: active,id: id,name: name);


  factory ProductPriceByGroup.fromJson(Map<String, dynamic> json) => ProductPriceByGroup(
    id: json["id"],
    idGroup: json["id_group"],
    idProduct: json["id_product"],
    name: json["name"],
    price: double.tryParse(json["price_list"].toString()),
    vatPercent: double.tryParse(json["vat_percent"].toString()),
    quantity: double.tryParse(json["quantity"].toString()),
    priceIncludingVat: json["price_including_vat"],
    active: json["active"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "id_group": idGroup,
    "id_product": idProduct,
    "name": name,
    "price_list": price,
    "quantity": quantity,
    "vat_percent": vatPercent,
    "active":active,
    "price_including_vat": priceIncludingVat,
  };
  static List<ProductPriceByGroup> fromJsonList(List<dynamic> list){
    List<ProductPriceByGroup> newList =[];
    for (var item in list) {
      if(item is ProductPriceByGroup){
        newList.add(item);
      } else {
        ProductPriceByGroup productPriceByGroup = ProductPriceByGroup.fromJson(item);
        newList.add(productPriceByGroup);
      }

    }
    return newList;
  }
}
