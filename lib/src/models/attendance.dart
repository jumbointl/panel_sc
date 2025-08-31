import 'dart:convert';

import 'object_with_name_and_id.dart';

Attendance attendanceFromJson(String str) => Attendance.fromJson(json.decode(str));

String attendanceToJson(Attendance data) => json.encode(data.toJson());

class Attendance extends ObjectWithNameAndId {

  String? dateTime;
  String? qr;
  int? placeId;
  int? processed;
  int? posId;
  int? configId;


  Attendance({
    super.id,
    super.name,
    super.active,
    this.dateTime,
    this.qr,
    this.placeId,
    this.processed,
    this.posId,
    this.configId,
  });


  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    id: json["id"],
    name: json["name"],
    active: json["active"],
    dateTime: json["date_time"],
    qr: json["qr"],
    placeId: json["place_id"],
    processed: json["processed"],
    posId: json["pos_id"],
    configId: json["config_id"],

  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active":active,
    "date_time":dateTime,
    "qr":qr,
    "place_id":placeId,
    "processed":processed,
    "pos_id":posId,
    "config_id":configId,

  };
  static List<Attendance> fromJsonList(List<dynamic> list){
    List<Attendance> newList =[];
    for (var item in list) {
      if(item is Attendance){
        newList.add(item);
      } else {
        Attendance attendance = Attendance.fromJson(item);
        newList.add(attendance);
      }

    }
    return newList;
  }
}
