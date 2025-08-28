import 'package:solexpress_panel_sc/src/models/document_item.dart';

import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/vat.dart';


InvoiceItem InvoiceItemFromJson(String str) => InvoiceItem.fromJson(json.decode(str));

String InvoiceItemToJson(InvoiceItem data) => json.encode(data.toJson());

class InvoiceItem extends DocumentItem {

  InvoiceItem({
     super.id,
     super.idProduct,
     super.idOrder,
     super.discount,
     super.idVat,
     super.vat,
     super.active,
     super.price,
     super.quantityShipped,
     super.quantityReturned,
     super.quantityInvoiced,
     name,
     super.vatPercent,
     super.quantity,
  }): super(name: name ?? 'InvoiceItem');

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
    id: json["id"],
    idProduct: json["id_product"],
    idOrder: json["id_order"],
    idVat: json["id_vat"],
    vat: json["vat"]!= null ? Vat.fromJson(json["vat"]) : null,
    discount: json["order_name"],
    active: json["active"],
    name: json["name"],
    quantity: double.tryParse(json["quantity"].toString()),
    price: double.tryParse(json["price_list"].toString()),
    quantityShipped: double.tryParse(json["quantity_shipped"].toString()),
    quantityReturned: double.tryParse(json["quantity_returned"].toString()),
    quantityInvoiced: double.tryParse(json["quantity_invoiced"].toString()),
    vatPercent: double.tryParse(json["vat_percent"].toString()),
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "id_product": idProduct,
    "id_order": idOrder,
    "id_vat": idVat,
    "order_name": discount,
    "vat": vat,
    "active": active,
    "name": name,
    "quantity": quantity,
    "price_list": price,
    "quantity_shipped": quantityShipped,
    "quantity_returned": quantityReturned,
    "quantity_invoiced": quantityInvoiced,
    "vat_percent": vatPercent,
  };
  static List<InvoiceItem> fromJsonList(List<dynamic> list){
    List<InvoiceItem> newList =[];
    for (var item in list) {
      if(item is InvoiceItem){
        newList.add(item);
      } else {
        InvoiceItem invoiceItem = InvoiceItem.fromJson(item);
        newList.add(invoiceItem);
      }

    }
    return newList;
  }

}
