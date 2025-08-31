import 'dart:convert';

import 'object_with_name_and_id.dart';

Pos posFromJson(String str) => Pos.fromJson(json.decode(str));

String posToJson(Pos data) => json.encode(data.toJson());

class Pos extends ObjectWithNameAndId {

  String? posCode;
  int? functionId;

  Pos({
    super.id,
    super.name,
    super.active,
    this.posCode,
    this.functionId,
  });


  factory Pos.fromJson(Map<String, dynamic> json) => Pos(
    id: json["id"],
    name: json["name"],
    active: json["active"],
    posCode: json["pos_code"],
    functionId: json["function_id"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active":active,
    "pos_code": posCode,
    "function_id": functionId,
  };
  static List<Pos> fromJsonList(List<dynamic> list){
    List<Pos> newList =[];
    for (var item in list) {
      if(item is Pos){
        newList.add(item);
      } else {
        Pos pos = Pos.fromJson(item);
        newList.add(pos);
      }

    }
    return newList;
  }
}
