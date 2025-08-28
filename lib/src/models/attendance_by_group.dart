import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/place.dart';

import 'object_with_name_and_id.dart';

AttendanceByGroup attendanceByGroupFromJson(String str) => AttendanceByGroup.fromJson(json.decode(str));

String attendanceByGroupToJson(AttendanceByGroup data) => json.encode(data.toJson());

class AttendanceByGroup extends ObjectWithNameAndId {

  int? total;
  Place? place;

  AttendanceByGroup({
    super.id,
    super.name,
    this.total,
    super.active,
    this.place,
  });


  factory AttendanceByGroup.fromJson(Map<String, dynamic> json) => AttendanceByGroup(
    id: json["id"],
    name: json["name"],
    total: int.tryParse(json["total"].toString()),
    active: json["active"],
    place: json["place"] == null ? null : Place.fromJson(json["place"]),
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "total": total,
    "active":active,
    "place": place?.toJson(),
  };
  static List<AttendanceByGroup> fromJsonList(List<dynamic> list){
    List<AttendanceByGroup> newList =[];
    for (var item in list) {
      if(item is AttendanceByGroup){
        newList.add(item);
      } else {
        AttendanceByGroup attendanceByGroup = AttendanceByGroup.fromJson(item);
        newList.add(attendanceByGroup);
      }

    }
    return newList;
  }

  String display() {
    String placeName = place?.name ?? '';
    return '$placeName ($total)';
  }
}
