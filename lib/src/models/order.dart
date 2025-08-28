import 'package:solexpress_panel_sc/src/models/address.dart';
import 'package:solexpress_panel_sc/src/models/commercial_document.dart';
import 'package:solexpress_panel_sc/src/models/group.dart';
import 'package:solexpress_panel_sc/src/models/document_item.dart';
import 'package:solexpress_panel_sc/src/models/payment.dart';
import 'package:solexpress_panel_sc/src/models/payment_type.dart';

import 'dart:convert';

import 'package:solexpress_panel_sc/src/models/society.dart';
import 'package:solexpress_panel_sc/src/models/user.dart';
import 'package:solexpress_panel_sc/src/models/warehouse.dart';

import 'credit.dart';
import 'currency.dart';
import 'order_status.dart';





  Order orderFromJson(String str) => Order.fromJson(json.decode(str));

  String orderToJson(Order data) => json.encode(data.toJson());

  class Order  extends CommercialDocument {

    int? idUser;
    User? user;
    int? idDelivery;
    User? delivery;
    int? idOrderPicker;
    User? orderPicker;
    int? idGroup;
    Group? group;
    int? idCredit;
    Credit? credit;
    int? idPayment;
    int? idPaymentType;
    Payment? payment;
    PaymentType? paymentType;
    int? idOrderStatus;
    int? idWarehouse;
    Warehouse? warehouse;
    OrderStatus? orderStatus;
    String? invoiceNumbers;
    String? shippingNumbers;
    String? deliveredTime;
    double? lat;
    double? lng;
    String? notificationToken;
    Order({
      super.id,
      super.name,
      super.active,
      //create time
      super.date,
      super.number,
      super.isDebitDocument,
      super.idIssuer,
      super.total,
      super.noTaxable,
      super.taxable5,
      super.taxable10,
      super.vatTotal,
      super.vatTotal5,
      super.vatTotal10,
      super.discount,
      super.priceIncludingVat,
      super.idSociety,
      super.society,
      super.idAddress,
      super.address,
      super.issuer,
      super.documentItems,
      super.idCurrency,
      super.currency,
      super.isCashSale,
      this.invoiceNumbers,
      this.shippingNumbers,
      //order status
      this.idOrderStatus,
      this.orderStatus,
      this.idUser,
      this.user,
      this.idDelivery,
      this.delivery,
      this.idOrderPicker,
      this.orderPicker,
      this.idGroup,
      this.group,
      this.idCredit,
      this.credit,
      this.idPayment,
      this.payment,
      this.deliveredTime,
      this.idWarehouse,
      this.warehouse,
      this.lat,
      this.lng,
      this.idPaymentType,
      this.paymentType,
      this.notificationToken,
    });

    factory Order.fromJson(Map<String, dynamic> json) =>

        Order(

          id: json["id"],
          name: json["name"],
          active: json["active"],
          date: json["date"],
          lat: double.tryParse(json["lat"].toString()),
          lng: double.tryParse(json["lng"].toString()),
          number: json["number"],
          isDebitDocument: json["is_debit_document"],
          total: double.tryParse(json["total"].toString()),
          noTaxable: double.tryParse(json["no_taxable"].toString()),
          taxable5: double.tryParse(json["taxable_5"].toString()),
          taxable10: double.tryParse(json["taxable_10"].toString()),
          vatTotal: double.tryParse(json["vat_total"].toString()),
          vatTotal5: double.tryParse(json["vat_total_5"].toString()),
          vatTotal10: double.tryParse(json["vat_total_10"].toString()),
          discount: double.tryParse(json["discount"].toString()),
          priceIncludingVat: json["price_including_vat"],

          idWarehouse: json["id_warehouse"],
          warehouse: json["warehouse"] != null ? json["warehouse"] is Warehouse ? json["warehouse"] :Warehouse.fromJson(json["warehouse"]): null,
          idSociety: json["id_society"],
          society: json["society"] != null ? json["society"] is Society ? json["society"] :Society.fromJson(json["society"]): null,

          idAddress: json["id_address"],
          address: json["address"] != null ? json["address"] is Address ? json["address"] : Address.fromJson(json["address"]) : null,

          idCurrency: json["id_currency"],
          currency: json["currency"] != null ? json["currency"] is Currency ? json["currency"] : Currency.fromJson(json["currency"]) : null,

          idIssuer: json["id_issuer"],
          issuer: json["issuer"] != null  ? json["issuer"] is Society ? json["issuer"] : Society.fromJson(json["issuer"]) : null,
          documentItems: json["document_items"] != null ? DocumentItem.fromJsonList(json["document_items"]) : null,

          idCredit: json["id_credit"],
          credit: json["credit"] != null  ? json["credit"] is Credit ? json["credit"] : Credit.fromJson(json["credit"]) : null,
          idUser: json["id_user"],
          user: json["user"] != null ? json["user"] is User ? json["user"] : User.fromJson(json["user"]) : null,
          idDelivery: json["id_delivery"],
          delivery: json["delivery"] != null  ? json["delivery"] is User ? json["delivery"] : User.fromJson(json["delivery"]) : null,
          idOrderPicker: json["id_order_picker"],
          orderPicker: json["order_picker"] != null ? json["order_picker"] is User ? json["order_picker"] : User.fromJson(json["order_picker"]) : null,
          idGroup: json["id_group"],
          group: json["group"] != null ? json["group"] is Group ? json["group"] : Group.fromJson(json["group"]) : null,
          idPayment: json["id_payment"],
          payment: json["payment"] != null ? json["payment"] is Payment ? json["payment"] :Payment.fromJson(json["payment"]) : null,

          idPaymentType: json["id_payment_type"],
          paymentType: json["payment_type"] != null ? json["payment_type"] is PaymentType ? json["payment_type"] :PaymentType.fromJson(json["payment_type"]) : null,
          idOrderStatus: json["id_order_status"],
          orderStatus: json["order_status"] != null ? json["order_status"] is OrderStatus ? json["order_status"] : OrderStatus.fromJson(json["order_status"]) : null,

          invoiceNumbers: json["invoice_numbers"],
          shippingNumbers: json["shipping_numbers"],
          isCashSale: json["is_cash_sale"],
          deliveredTime: json["delivered_time"],
          notificationToken: json["notification_token"],







        );

    @override
    Map<String, dynamic> toJson() =>
        {
          "id": id,
          "name": name,
          "active": active,
          "date": date,
          "number": number,
          "is_debit_document": isDebitDocument,
          "id_issuer": idIssuer,
          "issuer": issuer?.toJson(),
          "lat": lat,
          "lng": lng,
          "total": total,
          "no_taxable": noTaxable,
          "taxable_5": taxable5,
          "taxable_10": taxable10,
          "vat_total": vatTotal,
          "vat_total_5": vatTotal5,
          "vat_total_10": vatTotal10,
          "discount": discount,
          "price_including_vat": priceIncludingVat,
          "id_warehouse": idWarehouse,
          "warehouse": warehouse?.toJson(),
          "id_society": idSociety,
          "society": society?.toJson(),
          "id_address": idAddress,
          "address": address?.toJson(),
          "id_currency": idAddress,
          "currency": currency?.toJson(),
          "id_order_status": idOrderStatus,
          "order_status": orderStatus,
          "id_user": idUser,
          "user": user,
          "id_delivery": idDelivery,
          "id_order_picker": idOrderPicker,
          "id_group": idGroup,
          "group": group,
          "id_credit": idCredit,
          "credit": credit,
          "delivery": delivery,
          "order_picker": orderPicker,
          "id_payment": idPayment,
          "id_payment_type": idPaymentType,
          "payment_type": paymentType,
          "payment": payment,
          "document_items": documentItems,
          "invoice_numbers": invoiceNumbers,
          "shipping_numbers": shippingNumbers,
          "is_cash_sale": isCashSale,
          "delivered_time": deliveredTime,
          "notification_token": notificationToken,
        };

    static List<Order> fromJsonList(List<dynamic> list) {
      List<Order> newList = [];
      for (var item in list) {
        if(item is Order){
          newList.add(item);
        } else {
          Order order = Order.fromJson(item);
          newList.add(order);
        }

      }
      return newList;
    }
    void setUserAccount(User data){
      idUser = data.id;
      user = data;

      priceIncludingVat = data.society?.priceIncludingVat;
      group = data.group;
      idGroup = data.idGroup;
      credit = data.credit;
      idCredit = data.credit?.id;

      idIssuer = 1;
      isCashSale = data.getIsCashSales();



    }
    void setCurrency(Currency currency){
      super.currency = currency;
      super.currency!.id = currency.id;

    }
    void setPaymentType(PaymentType data){
      paymentType = data;
      idPaymentType = data.id;
    }
    void setOrderStatus(OrderStatus data){
      orderStatus = data;
      idOrderStatus = data.id;
    }
    void setIssuer(Society data){
      issuer = data;
      idIssuer = data.id;
    }
    void setDeliveryBoy(User data) {
      idDelivery =  data.id;
      delivery = data;
      idWarehouse = data.idWarehouse;
      warehouse = data.warehouse;
      lat = data.warehouse?.lat ;
      lng = data.warehouse?.lng;

    }
    void setOrderPicker(User data){
      orderPicker = data;
      idOrderPicker = data.id;
    }

  void setSociety(Society data) {
    idSociety = data.id;
    society = data;

  }



  }
