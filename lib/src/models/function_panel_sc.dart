import 'dart:convert';

import 'object_with_name_and_id.dart';

FunctionPanelSc functionPanelScFromJson(String str) => FunctionPanelSc.fromJson(json.decode(str));

String functionPanelScToJson(FunctionPanelSc data) => json.encode(data.toJson());

class FunctionPanelSc extends ObjectWithNameAndId{


  FunctionPanelSc({
    super.id,
    super.name,
    super.active,

  });


  factory FunctionPanelSc.fromJson(Map<String, dynamic> json) => FunctionPanelSc(
    id: json["id"],
    name: json["name"],
    active: json["active"],
  );
  static List<FunctionPanelSc> fromJsonList(List<dynamic> list){
    List<FunctionPanelSc> newList =[];
    for (var item in list) {
      if(item is FunctionPanelSc){
        newList.add(item);
      } else {
        FunctionPanelSc functionPanelSc = FunctionPanelSc.fromJson(item);
        newList.add(functionPanelSc);
      }

    }
    return newList;
  }


}
