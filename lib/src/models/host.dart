import 'dart:convert';

import 'object_with_name_and_id.dart';

Host hostFromJson(String str) => Host.fromJson(json.decode(str));

String hostToJson(Host data) => json.encode(data.toJson());

class Host extends ObjectWithNameAndId{

  String? url;

  Host({
    super.id,
    super.name,
    this.url,
    super.active,

  });


  factory Host.fromJson(Map<String, dynamic> json) => Host(
    id: json["id"],
    url: json["url"],
    name: json["name"],
    active: json["active"],
  );
  static List<Host> fromJsonList(List<dynamic> list){
    List<Host> newList =[];
    for (var item in list) {
      if(item is Host){
        newList.add(item);
      } else {
        Host host = Host.fromJson(item);
        newList.add(host);
      }

    }
    return newList;
  }
  static Host fromGetStorage(dynamic item){
      if(item is Host){
        return item;
      } else {
        Host host = Host.fromJson(item);
        return host;
      }


  }

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "url" : url,
    "name": name,
    "active":active,
  };
}
