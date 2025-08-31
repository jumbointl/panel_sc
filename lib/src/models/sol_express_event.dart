import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/panel_sc_config.dart';

import 'object_with_name_and_id.dart';

SolExpressEvent eventFromJson(String str) => SolExpressEvent.fromJson(json.decode(str));

String solExpressEventToJson(SolExpressEvent data) => json.encode(data.toJson());

class SolExpressEvent extends ObjectWithNameAndId {
  List<PanelScConfig>? configurations;
  String? eventStartDate;
  String? eventEndDate;

  SolExpressEvent({
    super.id,
    super.name,
    super.active,
    this.configurations,
    this.eventStartDate,
    this.eventEndDate,
  });


  factory SolExpressEvent.fromJson(Map<String, dynamic> json) => SolExpressEvent(
    id: json["id"],
    name: json["name"],
    active: json["active"],
    configurations: PanelScConfig.fromJsonList(json["configurations"]),
    eventStartDate: json["event_start_date"],
    eventEndDate: json["event_end_date"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active":active,
    "configurations": configurations,
    "event_start_date": eventStartDate,
    "event_end_date": eventEndDate,
  };
  static List<SolExpressEvent> fromJsonList(List<dynamic> list){
    List<SolExpressEvent> newList =[];
    for (var item in list) {
      if(item is SolExpressEvent){
        newList.add(item);
      } else {
        SolExpressEvent event = SolExpressEvent.fromJson(item);
        newList.add(event);
      }

    }
    return newList;
  }
}
