import 'package:solexpress_panel_sc/src/models/product.dart';

import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/vat.dart';


DocumentItem DocumentItemFromJson(String str) => DocumentItem.fromJson(json.decode(str));

String DocumentItemToJson(DocumentItem data) => json.encode(data.toJson());

class DocumentItem extends Product {
  int? idProduct;
  int? idOrder;
  String? discount;
  Vat? vat;
  double? quantityShipped;
  double? quantityReturned;
  double? quantityInvoiced;
  double? noTaxable;
  double? taxable5Percent;
  double? taxable10Percent;
  double? vatTotal;

  DocumentItem({
     super.id,
     this.idProduct,
     this.idOrder,
     this.discount,
     super.idVat,
     this.vat,
     super.active,
     super.price,
     this.quantityShipped,
     this.quantityReturned,
     this.quantityInvoiced,
     super.name,
     super.vatPercent,
     super.quantity,
     this.noTaxable,
     this.taxable5Percent,
     this.taxable10Percent,
     super.image1,
     super.image2,
     super.image3,
  });

  factory DocumentItem.fromJson(Map<String, dynamic> json) => DocumentItem(
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
    noTaxable: double.tryParse(json["no_taxable"].toString()),
    taxable5Percent: double.tryParse(json["taxable_5"].toString()),
    taxable10Percent: double.tryParse(json["taxable_10"].toString()),
    image1: json["image1"],
    image2: json["image2"],
    image3: json["image3"],
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
    "no_taxable": noTaxable,
    "taxable_5": taxable5Percent,
    "taxable_10": taxable10Percent,
    "image1": image1,
    "image2": image2,
    "image3": image3,

  };

  static List<DocumentItem> fromJsonList(List<dynamic> list){
    List<DocumentItem> newList =[];
    for (var item in list) {
      if(item is DocumentItem){
        newList.add(item);
      } else {
        DocumentItem documentItem = DocumentItem.fromJson(item);
        newList.add(documentItem);
      }

    }
    return newList;
  }
  calculateTaxableValueForPriceIncludedVat(){
    if(vatPercent==null || quantity ==null || price ==null){
      return;
    }
    double total = quantity! * price!;
    vatPercent ??= vat?.percent;
    if(vatPercent==null) {
      return;
    }
    switch(vatPercent){
      case 0:
        vatTotal = 0;
        noTaxable = total ;
        taxable5Percent =0 ;
        taxable10Percent =0;
        break;
      case 5:
      //int v = (total-total/(1+vatTotal!/100)).round();
      //vatTotal = ((total /21).round()).toDouble();
        vatTotal = ((total /21).round()).toDouble();
        noTaxable =0 ;
        taxable5Percent =total;
        taxable10Percent =0;
        break;
      case 10:
      //int v = (total-total/(1+vatTotal!/100)).round();
      //vatTotal = v.toDouble();
        vatTotal = ((total /11).round()).toDouble();
        noTaxable =0 ;
        taxable5Percent =0;
        taxable10Percent = total ;
        break;
      default:
        int v = (total-total/(1+vatTotal!/100)).round();
        vatTotal = v.toDouble();
        taxable10Percent = 11*vatTotal! ;
        noTaxable =total-taxable10Percent! ;
        taxable5Percent =0 ;

        break;

    //();
    }
  }
  calculateTaxableValueForPriceNotIncludedVat() {
    if (vatPercent == null || quantity == null || price == null) {
      return;
    }
    double total = quantity! * price!;

    switch (vatPercent) {
      case 0:
        vatTotal = 0;
        noTaxable = total;
        taxable5Percent = 0;
        taxable10Percent = 0;
        break;

      case 5:
        int v = (total * vatPercent! / 100).round();
        //vatTotal = ((total /21).round()).toDouble();
        vatTotal = v.toDouble();
        noTaxable = 0;
        taxable5Percent = total;
        taxable10Percent = 0;
        break;
      case 10:
        int v = (total * vatPercent! / 100).round();
        //vatTotal = ((total /11).round()).toDouble();
        vatTotal = v.toDouble();
        noTaxable = 0;
        taxable5Percent = 0;
        taxable10Percent = total;
        break;
      default:
        int v = (total * vatPercent! / 100).round();
        vatTotal = v.toDouble();
        taxable10Percent = 10 * vatTotal!;
        noTaxable = total - taxable10Percent!;
        taxable5Percent = 0;

        break;
    }
  }
  void setProduct(Product product, int isVatIncludedOnPrice){

    idProduct = product.id;
    name = product.name;

    idVat = product.idVat;
    vat = Vat(id:idVat,percent: product.vatPercent, name: product.vatName);
    vatPercent = product.vatPercent;
    quantity = product.quantity;
    price = product.price;
    if(isVatIncludedOnPrice==1){
      calculateTaxableValueForPriceIncludedVat();
    } else {
      calculateTaxableValueForPriceNotIncludedVat();
    }
    print(toJson());
  }
}
