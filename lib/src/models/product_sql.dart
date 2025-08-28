import 'package:solexpress_panel_sc/src/models/product.dart';

class ProductSql extends Product {
  List<String?>? imagesToDelete;
  List<String?>? extensionImagesToUpdate;
  List<int?>? positionImagesToDelete;
  ProductSql({
    super.id,
    idCategory,
    categoryName,
    idGroup,
    groupName,
    idVat,
    vatName,
    super.active,
    super.name,
    description,
    price,
    image1,
    image2,
    image3,
    vatPercent,
    barcode,
    this.imagesToDelete,
    this.positionImagesToDelete,
    this.extensionImagesToUpdate,

  }): super(idCategory: idCategory, categoryName: categoryName
      ,idGroup: idGroup,groupName: groupName,idVat: idVat, vatName: vatName,vatPercent: vatPercent
     ,image1: image1,image2: image2, image3: image3, price: price,barcode: barcode, description: description);

  factory ProductSql.fromJson(Map<String, dynamic> json) => ProductSql(
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
    image1: json["image1"],
    image2: json["image2"],
    image3: json["image3"],
    imagesToDelete: json["images_to_delete"],
    extensionImagesToUpdate : json["extension_images_to_update"],
    positionImagesToDelete: json["position_images_to_delete"],
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
    "image1": image1,
    "image2": image2,
    "image3": image3,
    "vat_percent": vatPercent,
    "images_to_delete": imagesToDelete,
    "position_images_to_delete": positionImagesToDelete,
    "extension_images_to_update" : extensionImagesToUpdate,
  };
  static List<ProductSql> fromJsonList(List<dynamic> list){
    List<ProductSql> newList =[];
    for (var item in list) {
      if(item is ProductSql){
        newList.add(item);
      } else {
        ProductSql product = ProductSql.fromJson(item);
        newList.add(product);
      }

    }
    return newList;
  }

}