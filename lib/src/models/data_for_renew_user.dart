import 'dart:convert';

import 'object_with_name_and_id.dart';

DataForRenewUser dataForRenewUserFromJson(String str) => DataForRenewUser.fromJson(json.decode(str));

String dataForRenewUserToJson(DataForRenewUser data) => json.encode(data.toJson());

class DataForRenewUser extends ObjectWithNameAndId{

  String? oldPassword;
  String? newPassword;
  bool? success = false;

  DataForRenewUser({
    super.id,
    super.name,
    this.oldPassword,
    this.newPassword,
    super.active,
    this.success,

  });


  factory DataForRenewUser.fromJson(Map<String, dynamic> json) => DataForRenewUser(
    id: json["id"],
    name: json["name"],
    oldPassword: json["old_password"],
    active: json["active"],
    newPassword: json["new_password"],
    success: json["success"],
  );
  static List<DataForRenewUser> fromJsonList(List<dynamic> list){
    List<DataForRenewUser> newList =[];
    for (var item in list) {
      if(item is DataForRenewUser){
        newList.add(item);
      } else {
        DataForRenewUser dataForRenewUser = DataForRenewUser.fromJson(item);
        newList.add(dataForRenewUser);
      }

    }
    return newList;
  }

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "old_password": oldPassword,
    "new_password": newPassword,
    "active":active,
    "success":success,
  };
}
