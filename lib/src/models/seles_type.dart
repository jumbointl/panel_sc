import 'dart:convert';

import 'object_with_name_and_id.dart';

SalesType salesTypeFromJson(String str) => SalesType.fromJson(json.decode(str));

String salesTypeToJson(SalesType data) => json.encode(data.toJson());

class SalesType extends ObjectWithNameAndId {


  SalesType({
    super.id,
    super.name,
    super.active,
  });


  factory SalesType.fromJson(Map<String, dynamic> json) => SalesType(
    id: json["id"],
    name: json["name"],
    active: json["active"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active":active,
  };
  static List<SalesType> fromJsonList(List<dynamic> list){
    List<SalesType> newList =[];
    for (var item in list) {
      if(item is SalesType){
        newList.add(item);
      } else {
        SalesType salesType = SalesType.fromJson(item);
        newList.add(salesType);
      }

    }
    return newList;
  }
}
