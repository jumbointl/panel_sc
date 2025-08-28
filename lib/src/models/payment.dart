import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/payment_type.dart';

import 'object_with_name_and_id.dart';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

class Payment extends ObjectWithNameAndId {
  int? idUser;
  int? idOrder;
  int? idPaymentType;
  String? namePaymentType;
  String? identification;
  double? amount;
  String? createdAt;



  Payment({
    super.id,
    super.name,
    super.active,
    this.idPaymentType,
    this.idUser,
    this.idOrder,
    this.identification,
    this.amount,
    this.namePaymentType,
    this.createdAt,

  });


  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json["id"],
    name: json["name"],
    active: json["active"],
    idPaymentType: json["id_payment_type"],
    namePaymentType: json["name_payment_type"],
    idUser: json["id_user"],
    idOrder: json["id_order"],
    identification: json["identification"],
    amount: json["amount"] != null ? double.tryParse(json["amount"] .toString()): null,
    createdAt: json["created_at"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active":active,
    "id_payment_type":idPaymentType,
    "name_payment_type":namePaymentType,
    "id_user" :idUser,
    "id_order":idOrder,
    "identification":identification,
    "amount":amount,
    "created_at":createdAt,
  };
  static List<Payment> fromJsonList(List<dynamic> list){
    List<Payment> newList =[];
    for (var item in list) {
      if(item is Payment){
        newList.add(item);
      } else {
        Payment payment = Payment.fromJson(item);
        newList.add(payment);
      }

    }
    return newList;
  }
  void setPaymentType(PaymentType data){
    idPaymentType = data.id;
    namePaymentType = data.name;
  }
  PaymentType getPaymentType(){
    PaymentType type = PaymentType(id: idPaymentType,name: namePaymentType);
    return type;
  }

  bool isValid() {
    if(idPaymentType==null || idOrder ==null || idUser ==null || namePaymentType == null ||
            amount ==null ){
      return false;
    }
    return true;
  }
}
