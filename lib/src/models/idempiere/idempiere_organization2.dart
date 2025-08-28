import 'package:idempiere_rest/idempiere_rest.dart';

import 'idempiere_object.dart';

class IdempiereOrganization2 extends IdempiereObject{
  IdempiereOrganization2({
    super.id,
    super.name,
    super.active,
    super.propertyLabel,
    super.identifier,
    super.modelName,
  });
  factory IdempiereOrganization2.fromJson(Map<String, dynamic> json) => IdempiereOrganization2(
    active: json["active"],
    id: json["id"],
    name: json["name"],
    propertyLabel: json["propertyLabel"],
    identifier: json["identifier"],
    modelName: json["modelName"],
  );
  static List<IdempiereOrganization2> fromJsonList(List<dynamic> list){
    List<IdempiereOrganization2> newList =[];
    for (var item in list) {
      if(item is IdempiereOrganization2){
        newList.add(item);
      } else if(item is Map<String, dynamic>){
        IdempiereOrganization2 idempiereOrganization2 = IdempiereOrganization2.fromJson(item);
        newList.add(idempiereOrganization2);
      } else if(item is Organization){
        IdempiereOrganization2 idempiereOrganization2 = IdempiereOrganization2(id: item.id, name: item.name);
        newList.add(idempiereOrganization2);
      }

    }
    return newList;
  }
  @override
  Map<String, dynamic> toJson() => {
    "active": active,
    "id": id,
    "name": name,
    "propertyLabel": propertyLabel,
    "identifier": identifier,
    "modelName": modelName,
  };

}