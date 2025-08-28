import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';

class IdempiereWarehouse2 extends ObjectWithNameAndId{
  IdempiereWarehouse2({
    super.id,
    super.name,
    super.active,
  });
  factory IdempiereWarehouse2.fromJson(Map<String, dynamic> json) => IdempiereWarehouse2(
    active: json["active"],
    id: json["id"],
    name: json["name"],
  );
  static List<IdempiereWarehouse2> fromJsonList(List<dynamic> list){
    List<IdempiereWarehouse2> newList =[];
    for (var item in list) {
      if(item is IdempiereWarehouse2){
        newList.add(item);
      } else if(item is Map<String, dynamic>){
        IdempiereWarehouse2 idempiereWarehouse = IdempiereWarehouse2.fromJson(item);
        newList.add(idempiereWarehouse);
      } else if(item is Warehouse){
        IdempiereWarehouse2 idempiereWarehouse = IdempiereWarehouse2(id: item.id, name: item.name);
        newList.add(idempiereWarehouse);
      }

    }
    return newList;
  }
  @override
  Map<String, dynamic> toJson() => {
    "active": active,
    "id": id,
    "name": name,
  };

}