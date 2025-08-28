// To parse this JSON data, do
//
//     final seller = societyFromJson(jsonString);

import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';

import 'configuration.dart';
import 'credit.dart';


Society societyFromJson(String str) => Society.fromJson(json.decode(str));

String societyToJson(Society data) => json.encode(data.toJson());

class Society extends ObjectWithNameAndId  {
  @override
  int? id;
  @override
  String? name;
  String? email;
  String? password;
  String? taxId;
  String? image;
  String? phone;
  String? address;
  int? idStatus;
  String? status;
  int? idUser;
  int? idGroup;
  String? groupName;
  String? user;
  String? privateKey;
  String? rememberToken;
  String? sessionToken;
  int? idCredit =1;
  int? priceIncludingVat;
  double? creditUsed;
  Credit? credit;
  Configuration? configuration;
  //String? configuration;

  Society({
    this.id,
    this.name,
    this.email,
    this.password,
    this.taxId,
    this.image,
    this.phone,
    this.address,
    this.idStatus,
    this.status,
    this.idUser,
    this.idGroup,
    this.user,
    this.groupName,
    this.privateKey,
    this.rememberToken,
    this.sessionToken,
    this.priceIncludingVat,
    this.idCredit,
    this.creditUsed,
    this.credit,
    this.configuration,
    active,
  }): super(active: active);

  factory Society.fromJson(Map<String, dynamic> json) => Society(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    taxId: json["tax_id"],
    image: json["image"],
    phone: json["phone"],
    address: json["address"],
    idStatus: json["id_status"],
    status: json["status"],
    idUser: json["id_user"],
    idGroup: json["id_group"],
    user: json["user"],
    groupName: json["group_name"],
    privateKey: json["private_key"],
    rememberToken: json["remember_token"],
    sessionToken: json["session_token"],
    configuration: json["configuration"] != null ? json["configuration"] is Map<String,dynamic> ? Configuration.fromJson(json["configuration"]) : json["configuration"] is String ? Configuration.fromJson(jsonDecode(json["configuration"])): null :null,
    //configuration: json["configuration"] != null ? json["configuration"] is Map<String,dynamic> ? jsonEncode(json["configuration"]): json["configuration"] is String ? json["configuration"] : null    :null,
    //configuration: json["configuration"],
    active: json["active"],
    priceIncludingVat: json["price_including_vat"],
    idCredit: json["id_credit"],
    creditUsed:double.tryParse(json["credit_used"].toString()),
    credit: json["credit"] != null ? json["credit"]  is Credit ? json["credit"] : Credit.fromJson(json["credit"]) : null,
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "tax_id": taxId,
    "image": image,
    "phone": phone,
    "address": address,
    "id_status": idStatus,
    "status": status,
    "id_user": idUser,
    "id_group": idGroup,
    "user": user,
    "group_name": groupName,
    "private_key": privateKey,
    "remember_token": rememberToken,
    "session_token": sessionToken,
    "price_including_vat":priceIncludingVat,
    "id_credit":idCredit,
    "active": active,
    "credit_used":creditUsed,
    "credit": credit,
    "configuration": configuration,
  };
  static List<Society> fromJsonList(List<dynamic> list){
    List<Society> newList =[];
    for (var item in list) {

      if(item is Society){
        print('------------------------${item.configuration?.toJson() ?? 'configuration null'}');
        newList.add(item);
      } else {
        Society society = Society.fromJson(item);
        newList.add(society);
      }

    }
    return newList;
  }

  int isHasCredit(){
    if(credit==null || credit!.id == null){
      return 0;
    } else {
      return credit!.isHasCredit();
    }
  }

}
