import 'package:solexpress_panel_sc/src/models/address.dart';
import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';
import 'package:solexpress_panel_sc/src/models/document_item.dart';

import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/society.dart';

import 'currency.dart';





  CommercialDocument commercialDocumentFromJson(String str) => CommercialDocument.fromJson(json.decode(str));

  String commercialDocumentToJson(CommercialDocument data) => json.encode(data.toJson());

  class CommercialDocument  extends ObjectWithNameAndId {

  String? date;
  String? number;
  int? isDebitDocument;
  //client
  int? idSociety;
  Society? society;
  int? idAddress;
  Address? address;
  int? idIssuer;
  Society? issuer;
  double? total;
  double? noTaxable;
  double? taxable5;
  double? taxable10;
  double? vatTotal;
  double? vatTotal5;
  double? vatTotal10;
  double? discount;
  int? priceIncludingVat;
  int? idCurrency;
  Currency? currency;
  int? isCashSale ;

  List<DocumentItem>? documentItems;

  CommercialDocument({
    id,
    name,
    active,
    this.date,
    this.number,
    this.isDebitDocument,
    this.idIssuer,
    this.total,
    this.noTaxable,
    this.taxable5,
    this.taxable10,
    this.vatTotal,
    this.vatTotal5,
    this.vatTotal10,
    this.discount,
    this.priceIncludingVat,
    this.idSociety,
    this.society,
    this.idAddress,
    this.address,
    this.issuer,
    this.documentItems,
    this.idCurrency,
    this.currency,
    this.isCashSale,


  }): super(active: active,id: id, name: name);

  factory CommercialDocument.fromJson(Map<String, dynamic> json) => CommercialDocument(
    id: json["id"],
    name: json["name"],
    active: json["active"],
    date: json["date"],
    number: json["number"],
    isDebitDocument: json["is_debit_document"],
    idIssuer: json["id_issuer"],
    total: double.tryParse(json["total"].toString()),
    noTaxable: double.tryParse(json["no_taxable"].toString()),
    taxable5: double.tryParse(json["taxable_5"].toString()),
    taxable10: double.tryParse(json["taxable_10"].toString()),
    vatTotal: double.tryParse(json["vat_total"].toString()),
    vatTotal5: double.tryParse(json["vat_total_5"].toString()),
    vatTotal10: double.tryParse(json["vat_total_10"].toString()),
    discount: double.tryParse(json["discount"].toString()),

    priceIncludingVat: json["price_including_vat"],
    idSociety: json["id_society"],

    idAddress: json["id_address"],

    idCurrency: json["id_currency"],
    isCashSale: json["is_cash_sale"],
    address: json["address"]!= null ? Address.fromJson(json["address"]) : null,
    issuer: json["issuer"] != null ? Society.fromJson(json["issuer"]) : null,
    society: json["society"] != null ? Society.fromJson(json["society"]) : null,
    currency: json["currency"] != null ? Currency.fromJson(json["currency"]) : null,

    documentItems: json["document_items"] != null ? DocumentItem.fromJsonList(json["document_items"]) : null,

  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "active": active,
    "date": date,
    "number": number,
    "is_debit_document": isDebitDocument,
    "id_issuer": idIssuer,
    "issuer": issuer?.toJson(),
    "total": total,
    "no_taxable": noTaxable,
    "taxable_5": taxable5,
    "taxable_10": taxable10,
    "vat_total": vatTotal,
    "vat_total_5": vatTotal5,
    "vat_total_10": vatTotal10,
    "discount": discount,
    "price_including_vat": priceIncludingVat,
    "id_society":idSociety,
    "society":society?.toJson(),
    "id_address":idAddress,
    "address":address?.toJson(),
    "id_currency":idAddress,
    "currency":address?.toJson(),
    "document_items" :documentItems,
    "is_cash_sale": isCashSale,
  };

  static List<CommercialDocument> fromJsonList(List<dynamic> list){
    List<CommercialDocument> newList =[];
      for (var item in list) {
        if(item is CommercialDocument){
          newList.add(item);
        } else {
          CommercialDocument commercialDocument = CommercialDocument.fromJson(item);
          newList.add(commercialDocument);
        }

      }
      return newList;
  }

  void addDocumentItem(DocumentItem d) {
    if(documentItems==null){
      documentItems =  <DocumentItem>[];
      total = 0;
      noTaxable = 0;
      taxable5 = 0;
      taxable10 = 0;
      vatTotal =0 ;
      vatTotal5 = 0;
      vatTotal10 = 0;

    }
    documentItems!.add(d);
    total = total! + d.quantity! * d.price!;
    noTaxable =noTaxable! + d.noTaxable!;
    taxable5 = taxable5! + d.taxable5Percent!;
    taxable10 = taxable10! + d.taxable10Percent!;
    vatTotal5 = ((taxable5! *0.05).round()).toDouble() ;
    vatTotal10 = ((taxable10! *0.1).round()).toDouble() ;
    vatTotal = vatTotal5! + vatTotal10!;

  }

}






