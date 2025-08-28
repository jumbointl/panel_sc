import 'dart:convert';

import 'object_with_name_and_id.dart';

OrderStatus orderStatusFromJson(String str) => OrderStatus.fromJson(json.decode(str));

String orderStatusToJson(OrderStatus data) => json.encode(data.toJson());

class OrderStatus extends ObjectWithNameAndId {


  OrderStatus({
    super.id,
    super.name,
    super.active,
  });


  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
    id: json["id"],
    name: json["name"],
    active: json["active"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active":active,
  };
  static List<OrderStatus> fromJsonList(List<dynamic> list){
    List<OrderStatus> newList =[];
    for (var item in list) {
      if(item is OrderStatus){
        newList.add(item);
      } else {
        OrderStatus orderStatus = OrderStatus.fromJson(item);
        newList.add(orderStatus);
      }

    }
    return newList;
  }
}
