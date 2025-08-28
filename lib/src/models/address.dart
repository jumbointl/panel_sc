import 'dart:convert';

import 'object_with_name_and_id.dart';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address extends ObjectWithNameAndId {

  String? address;
  String? neighborhood;
  String? city;
  String? country;
  int? idUser;
  int? idSociety;
  int? defaultSelection;
  double? lat;
  double? lng;

  Address({
    id,
    name,
    this.address,
    this.neighborhood,
    this.city,
    this.country,
    this.idUser,
    this.idSociety,
    this.lat,
    this.lng,
    this.defaultSelection,
    active,
  }):super(active: active,id: id, name: name);

  factory Address.fromJson(Map<String, dynamic> json) => Address(
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

  static List<Address> fromJsonList(List<dynamic> jsonList) {
    List<Address> toList = [];

    for (var item in jsonList) {
      if(item is Address){
        toList.add(item);
      } else {
        Address address = Address.fromJson(item);
        toList.add(address);
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
}
