import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/host.dart';

import 'object_with_name_and_id.dart';

Configuration configurationFromJson(String str) => Configuration.fromJson(json.decode(str));

String configurationToJson(Configuration data) => json.encode(data.toJson());

class Configuration extends ObjectWithNameAndId {

  double? commission;
  List<Host>? urls;

  Configuration({
    super.id,
    super.name,
    this.commission,
    this.urls,
    super.active,
  });


  factory Configuration.fromJson(Map<String, dynamic> json) => Configuration(
    id: json["id"],
    name: json["name"],
    urls: json["urls"] != null ? Host.fromJsonList(json["urls"]): null,
    commission: double.tryParse(json["commission"].toString()),
    active: json["active"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "commission": commission,
    "urls": urls?.map((e) => e.toJson()).toList(),
    "active":active,
  };
  static List<Configuration> fromJsonList(List<dynamic> list){
    List<Configuration> newList =[];
    for (var item in list) {
      if(item is Configuration){
        newList.add(item);
      } else {
        Configuration configuration = Configuration.fromJson(item);
        newList.add(configuration);
      }

    }
    return newList;
  }
}
