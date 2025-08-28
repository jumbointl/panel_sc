import 'dart:convert';


Rol rolFromJson(String str) => Rol.fromJson(json.decode(str));

String rolToJson(Rol data) => json.encode(data.toJson());

class Rol {

  int? id;
  String? name;
  String? image;
  String? route;

  bool? isActive = true;
/*
  Rol({
    this.id,
    this.name,
    this.image,
    this.route,
    isActive,
  }): super(isActive: isActive);
*/
  Rol({
    this.id,
    this.name,
    this.image,
    this.route,
    this.isActive,
  });
  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    route: json["route"],
    isActive: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "route": route,
    "active":isActive,
  };
  static List<Rol> fromJsonList(List<dynamic> list){


    List<Rol> newList =[];
    for (var item in list) {
      if(item is Rol){
        newList.add(item);
      } else {
        Rol rol = Rol.fromJson(item);
        newList.add(rol);
      }

    }
    return newList;
  }
}
