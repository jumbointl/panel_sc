import 'dart:convert';

import 'object_with_name_and_id.dart';

Vat vatFromJson(String str) => Vat.fromJson(json.decode(str));

String vatToJson(Vat data) => json.encode(data.toJson());

class Vat extends ObjectWithNameAndId {

  double? percent;

  Vat({
    super.id,
    super.name,
    this.percent,
    super.active,
  });


  factory Vat.fromJson(Map<String, dynamic> json) => Vat(
    id: json["id"],
    name: json["name"],
    percent: double.tryParse(json["percent"].toString()),
    active: json["active"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "percent": percent,
    "active":active,
  };
  static List<Vat> fromJsonList(List<dynamic> list){
    List<Vat> newList =[];
    for (var item in list) {
      if(item is Vat){
        newList.add(item);
      } else {
        Vat vat = Vat.fromJson(item);
        newList.add(vat);
      }

    }
    return newList;
  }
}
