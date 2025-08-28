import 'dart:convert';

import 'object_with_name_and_id.dart';

Status statusFromJson(String str) => Status.fromJson(json.decode(str));

String statusToJson(Status data) => json.encode(data.toJson());

class Status extends ObjectWithNameAndId {

  @override
  int? id;
  @override
  String? name;
  String? image;

  Status({
    this.id,
    this.name,
    this.image,
    active,
  }): super(active: active);


  factory Status.fromJson(Map<String, dynamic> json) => Status(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    active: json["active"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "active":active,
  };
  static List<Status> fromJsonList(List<dynamic> list){
    List<Status> newList =[];
    for (var item in list) {
      if(item is Status){
        newList.add(item);
      } else {
        Status status = Status.fromJson(item);
        newList.add(status);
      }

    }
    return newList;
  }
}
