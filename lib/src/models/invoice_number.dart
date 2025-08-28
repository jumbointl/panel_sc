import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';

import 'dart:convert';



InvoiceNumber InvoiceNumberFromJson(String str) => InvoiceNumber.fromJson(json.decode(str));

String InvoiceNumberToJson(InvoiceNumber data) => json.encode(data.toJson());

class InvoiceNumber extends ObjectWithNameAndId {
  int? branch ;
  int? cashRegister ;
  String? date;
  String? numberInString;
  String? expireDate;
  String? startedAt;
  int? number;


  InvoiceNumber({
     super.id,
     this.branch ,
     this.date,
     super.active,
     this.number ,
     super.name,
     this.cashRegister ,
     this.expireDate,
     this.startedAt,
     this.numberInString,
  });

  factory InvoiceNumber.fromJson(Map<String, dynamic> json) => InvoiceNumber(
    id: json["id"],
    branch: json["branch"],
    cashRegister: json["cash_register"],
    date: json["date"],
    active: json["active"],
    name: json["name"],
    number: json["number"],
    numberInString: json["number_in_string"],
    expireDate: json["expire_date"],
    startedAt: json["started_at"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "branch": branch,
    "date": date,
    "active": active,
    "name": name,
    "number": number,
    "cash_register":cashRegister,
    "expire_date":expireDate,
    "started_at":startedAt,
    "number_in_string":numberInString,
  };

  static List<InvoiceNumber> fromJsonList(List<dynamic> list){
    List<InvoiceNumber> newList =[];
    for (var item in list) {
      if(item is InvoiceNumber){
        newList.add(item);
      } else {
        InvoiceNumber documentItem = InvoiceNumber.fromJson(item);
        newList.add(documentItem);
      }

    }
    return newList;
  }

}
