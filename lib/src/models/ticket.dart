

import 'package:solexpress_panel_sc/src/models/ticket_owner.dart';

import 'caller.dart';
import 'place.dart';
import 'department.dart';
import 'object_with_name_and_id.dart';

class Ticket extends ObjectWithNameAndId {
  Department? department;
  bool? isCalled;
  String? calledTime;
  Place? place;
  Caller? caller;
  TicketOwner? owner;
  TicketStatus? status;
  int? dBQueryIntervalInSeconds;
  Ticket({
    required super.id,
    required super.name,
    this.department,
    this.isCalled,
    this.calledTime,
    this.place,
    this.caller,
    this.owner,
    this.status,


  });

  String display(){
    String placeName = place?.name ?? '';
    String placeId = place?.id?.toString() ?? '';

    String name = owner?.name ?? '';
    if(name==''){
      return name;
    }
    String display ='$name $placeName';
    return display.toUpperCase();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (department != null) {
      data['department'] = department!.toJson();
    }
    data['isCalled'] = isCalled;
    data['calledTime'] = calledTime;
    if (place != null) {
      data['place'] = place!.toJson();
    }
    if (caller != null) {
      data['caller'] = caller!.toJson();
    }
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    if (status != null) {
      data['status'] = status!;
    }

    return data;
  }
  Ticket fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      name: json['name'],
      department: json['department'] != null ? Department.fromJson(json['department']) : null,
      isCalled: json['isCalled'],
      calledTime: json['calledTime'],
      place: json['place'] != null ? Place.fromJson(json['place']) : null,
      caller: json['caller'] != null ? Caller.fromJson(json['caller']) : null,
      owner: json['owner'] != null ? TicketOwner.fromJson(json['owner']) : null,
      status: json['status'],

    );
  }


}

enum TicketStatus { none, called, received, finished }