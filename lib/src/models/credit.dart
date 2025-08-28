import 'dart:convert';

import 'object_with_name_and_id.dart';

Credit creditFromJson(String str) => Credit.fromJson(json.decode(str));

String creditToJson(Credit data) => json.encode(data.toJson());

class Credit extends ObjectWithNameAndId {
  int? always;
  double? limit;
  String? until;

  Credit({
    id,
    name,
    active,
    this.always,
    this.limit,
    this.until,
  }): super(id:id, name:name, active: active);


  factory Credit.fromJson(Map<String, dynamic> json) => Credit(
    id: json["id"],
    name: json["name"],
    active: json["active"],
    always: json["always"],
    until: json["until"],
    limit:  double.tryParse(json["limit"].toString()),
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active":active,
    "always": always,
    "until": until,
    "limit": limit,
  };
  static List<Credit> fromJsonList(List<dynamic> list){
    List<Credit> newList =[];
    for (var item in list) {
      if(item is Credit){
        newList.add(item);
      } else {
        Credit credit = Credit.fromJson(item);
        newList.add(credit);
      }

    }
    return newList;
  }
  int isHasCredit(){
    if(always==1){
      return 1;
    }
    return 0;
  }
}
