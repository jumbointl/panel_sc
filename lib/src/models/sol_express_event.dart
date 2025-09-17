import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/panel_sc_config.dart';

import 'object_with_name_and_id.dart';

SolExpressEvent eventFromJson(String str) => SolExpressEvent.fromJson(json.decode(str));

String solExpressEventToJson(SolExpressEvent data) => json.encode(data.toJson());

class SolExpressEvent extends ObjectWithNameAndId {
  List<PanelScConfig>? configurations;
  String? eventStartDate;
  String? eventEndDate;
  String? image;
  String? imageToDelete;

  List<String>? daysConfigured;

  SolExpressEvent({
    super.id,
    super.name,
    super.active,
    this.configurations,
    this.eventStartDate,
    this.eventEndDate,
    this.image,
    this.imageToDelete,
    this.daysConfigured,
  });


  factory SolExpressEvent.fromJson(Map<String, dynamic> json) => SolExpressEvent(
    id: json["id"],
    name: json["name"],
    active: json["active"],
    configurations: PanelScConfig.fromJsonList(json["configurations"]),
    eventStartDate: json["event_start_date"],
    eventEndDate: json["event_end_date"],
    image: json["image"],
    imageToDelete: json["image_to_delete"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active":active,
    "configurations": configurations,
    "event_start_date": eventStartDate,
    "event_end_date": eventEndDate,
    "image": image,
    "image_to_delete": imageToDelete,
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
  List<String> getEventDates(){
    DateTime endDate = DateTime.parse(eventEndDate!);
    DateTime startDate = DateTime.parse(eventStartDate!);

    List<String> dates =[];
    if(eventStartDate!=null){
      dates.add(eventStartDate!);
    }
    while(eventEndDate!=null && endDate.isAfter(startDate)){
      startDate = startDate.add(const Duration(days: 1));
      String date = startDate.toIso8601String().split('T')[0];
      dates.add(date);
    }

    return dates;
  }
  List<String> getEventNoConfiguredDays(){

    List<String> noConfiguredDays =[];
    List<String> dates = getEventDates();
    if(daysConfigured==null){
      return dates;
    }
    for(String date in dates) {
      if (!daysConfigured!.contains(date)) {
        noConfiguredDays.add(date);
      }
    }
    return noConfiguredDays;
  }
}
