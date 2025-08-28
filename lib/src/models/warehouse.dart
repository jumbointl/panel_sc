import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/address.dart';
import 'package:solexpress_panel_sc/src/models/society.dart';

import 'object_with_name_and_id.dart';

Warehouse WarehouseFromJson(String str) => Warehouse.fromJson(json.decode(str));

String WarehouseToJson(Warehouse data) => json.encode(data.toJson());

class Warehouse extends ObjectWithNameAndId {

  String? address;
  String? neighborhood;
  String? city;
  String? country;
  int? idUser;
  int? idSociety;
  int? defaultSelection;
  double? lat;
  double? lng;
  Society? society;

  Warehouse({
    super.id,
    super.name,
    this.address,
    this.neighborhood,
    this.city,
    this.country,
    this.idUser,
    this.idSociety,
    this.lat,
    this.lng,
    this.defaultSelection,
    super.active,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    neighborhood: json["neighborhood"],
    city: json["city"],
    country: json["country"],
    idUser: json["id_user"],
    idSociety: json["id_society"],
    defaultSelection: json["default_selection"],
    lat: json["lat"],
    lng: json["lng"],
    active: json["active"],
  );

  static List<Warehouse> fromJsonList(List<dynamic> jsonList) {
    List<Warehouse> toList = [];

    for (var item in jsonList) {
      if(item is Warehouse){
        toList.add(item);
      } else {
        Warehouse warehouse = Warehouse.fromJson(item);
        toList.add(warehouse);
      }

    }

    return toList;
  }

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "neighborhood": neighborhood,
    "city":city ,
    "country": country,
    "id_user": idUser,
    "id_society": idSociety,
    "default_selection": defaultSelection,
    "active":active,
    "lat": lat,
    "lng": lng,
  };
  Address getAddress(){
    Address a = Address(
      id: id,
      name: name,
      address: address,
      neighborhood: neighborhood,
      city: city,
      country: country,
      idSociety: idSociety,
      lat: lat,
      lng: lng,
      active: active,

    );
    return a;
  }
}
