import 'dart:convert';

import 'object_with_name_and_id.dart';

Group groupFromJson(String str) => Group.fromJson(json.decode(str));

String groupToJson(Group data) => json.encode(data.toJson());

class Group extends ObjectWithNameAndId {



  Group({
    super.id,
    super.name,
    super.active,
  });


  factory Group.fromJson(Map<String, dynamic> json) => Group(
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
  static List<Group> fromJsonList(List<dynamic> list){
    List<Group> newList =[];
    for (var item in list) {
      if(item is Group){
        newList.add(item);
      } else {
        Group group = Group.fromJson(item);
        newList.add(group);
      }

    }
    return newList;
  }
}
