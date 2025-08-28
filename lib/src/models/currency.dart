import 'dart:convert';

import 'object_with_name_and_id.dart';

Currency currencyFromJson(String str) => Currency.fromJson(json.decode(str));

String currencyToJson(Currency data) => json.encode(data.toJson());

class Currency extends ObjectWithNameAndId {

  String? shortName;
  String? countryCode;
  String? countryName;
  int? idCurrencyRate;
  int? defaultSelection;
  double? currencyRate;
  String? startAt;
  String? endAt;

  Currency({
    id,
    name,
    this.shortName,
    this.countryCode,
    this.countryName,
    this.idCurrencyRate,
    this.currencyRate,
    this.startAt,
    this.endAt,
    this.defaultSelection,
    active,
  }):super(active: active,id: id, name: name);

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    id: json["id"],
    name: json["name"],
    shortName: json["short_name"],
    countryCode: json["country_code"],
    countryName: json["country_name"],
    idCurrencyRate: json["id_currency_rate"],
    defaultSelection: json["default_selection"],
    currencyRate: double.tryParse(json["currency_rate"].toString()),
    startAt: json["start_at"],
    endAt: json["end_at"],
    active: json["active"],
  );

  static List<Currency> fromJsonList(List<dynamic> jsonList) {
    List<Currency> toList = [];

    for (var item in jsonList) {

      if(item is Currency){
        toList.add(item);
      } else {
        Currency currency = Currency.fromJson(item);
        toList.add(currency);
      }


    }

    return toList;
  }

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "short_name": shortName,
    "country_code": countryCode,
    "country_name":countryName ,
    "id_currency_rate": idCurrencyRate,
    "default_selection": defaultSelection,
    "active":active,
    "currency_rate": currencyRate,
    "start_at": startAt,
    "end_at": endAt,
  };
}
