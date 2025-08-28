// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';
import 'package:solexpress_panel_sc/src/models/warehouse.dart';

import 'credit.dart';
import 'society.dart';
import 'group.dart';
import 'rol.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User extends ObjectWithNameAndId{

  String? email;
  String? emailVerifiedAt;
  String? password;
  String? lastname;
  String? image;
  String? phone;
  String? address;
  String? role;
  int? idStatus;
  String? status;
  int? idSociety;
  String? societyName;
  int? idGroup;
  String? groupName;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? sessionToken;
  int? sessionTokenCreatedAt;
  String? refreshToken;
  int? refreshTokenCreatedAt;
  List<Rol>? roles = [];
  String? imageToDelete;
  String? extensionImage;
  Society? society;
  Group? group ;
  Credit? credit ;
  int? idWarehouse;
  String? notificationToken;
  int? ntfTokenCreatedAt;
  Warehouse? warehouse;
  String? language;
  User({
     super.id,
     super.name,
     this.email,
     this.emailVerifiedAt,
     this.password,
     this.lastname,
     this.image,
     this.phone,
     this.address,
     this.role,
     this.idStatus,
     this.status,
     this.idSociety,
     this.societyName,
     this.idGroup,
     this.groupName,
     this.rememberToken,
     this.createdAt,
     this.updatedAt,
     this.sessionToken,
     this.sessionTokenCreatedAt,
     this.refreshToken,
     this.refreshTokenCreatedAt,
     this.notificationToken,
     this.roles,
     this.society,
     this.group,
     this.imageToDelete,
     this.extensionImage,
     this.credit,
     this.idWarehouse,
     this.warehouse,
     this.ntfTokenCreatedAt,
     this.language,
     super.active,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    password: json["password"],
    lastname: json["lastname"],
    image: json["image"],
    extensionImage: json["extension_image"],
    imageToDelete: json["image_to_delete"],
    phone: json["phone"],
    address: json["address"],
    role: json["role"],
    idStatus: json["id_status"],
    status: json["status"],
    societyName: json["society_name"],
    idSociety: json["id_society"],
    idGroup: json["id_group"],
    groupName : json["group_name"],
    rememberToken: json["remember_token"],
    notificationToken: json["notification_token"],
    ntfTokenCreatedAt: json["ntf_token_created_at"] ,
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    sessionToken: json["session_token"],
    sessionTokenCreatedAt: json["session_token_created_at"],
    refreshToken: json["refresh_token"],
    refreshTokenCreatedAt: json["refresh_token_created_at"],
    roles: json["roles"] == null ? null : Rol.fromJsonList(json["roles"]),
    society: json["society"] == null ? null :  json["society"] is Society ? json["society"] : Society.fromJson(json["society"]),
    credit: json["credit"] != null ? json["credit"]  is Credit ? json["credit"] : Credit.fromJson(json["credit"]) : null,
    idWarehouse: json["id_warehouse"],
    warehouse: json["warehouse"] != null ? json["warehouse"] is Warehouse ? json["warehouse"] :Warehouse.fromJson(json["warehouse"]): null,
    active: json["active"],

  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "password": password,
    "lastname": lastname,
    "image": image,
    "image_to_delete": imageToDelete,
    "extension_image": extensionImage,
    "phone": phone,
    "address": address,
    "role": role,
    "roles": roles,
    "id_status": idStatus,
    "status": status,
    "id_society": idSociety,
    "society_name": societyName,
    "id_group": idGroup,
    "group_name": groupName,
    "remember_token": rememberToken,
    "notification_token": notificationToken,
    "ntf_token_created_at": ntfTokenCreatedAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "session_token": sessionToken,
    "session_token_created_at": sessionTokenCreatedAt,
    "refresh_token": refreshToken,
    "refresh_token_created_at": refreshTokenCreatedAt,
    "society": society,
    "group": group,
    "credit": credit,
    "active":active,
    "id_warehouse": idWarehouse,
    "warehouse": warehouse,

  };
  static List<User> fromJsonList(List<dynamic> list){
    List<User> newList =[];
    for (var item in list) {
      if(item is User){
        newList.add(item);
      } else {
        User user = User.fromJson(item);
        newList.add(user);
      }

    }
    return newList;
  }
  int getIsCashSales(){
    int i =1;
    if(credit==null || credit!.id == null){
      return i;
    }
    if(credit!.always==1){
      return 0;
    }




    return i;
  }

  int isSocietyHasCredit(){
    if(credit==null || credit!.id == null){
      if(society==null){
        return 0;
      } else{
        return society!.isHasCredit();
      }
    } else {
      return credit!.isHasCredit();
    }
  }


}
