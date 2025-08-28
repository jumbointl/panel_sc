import 'dart:convert';

import 'object_with_name_and_id.dart';

PaymentType paymentTypeFromJson(String str) => PaymentType.fromJson(json.decode(str));

String paymentTypeToJson(PaymentType data) => json.encode(data.toJson());

class PaymentType extends ObjectWithNameAndId {


  PaymentType({
    super.id,
    super.name,
    super.active,
  });


  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
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
  static List<PaymentType> fromJsonList(List<dynamic> list){
    List<PaymentType> newList =[];
    for (var item in list) {
      if(item is PaymentType){
        newList.add(item);
      } else {
        PaymentType paymentType = PaymentType.fromJson(item);
        newList.add(paymentType);
      }

    }
    return newList;
  }
}
