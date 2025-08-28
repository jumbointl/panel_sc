import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';

class TicketOwner extends ObjectWithNameAndId {
  TicketOwner({
    super.id,
    super.name,
    super.active,
  });

  static TicketOwner fromJson(json) {
    return TicketOwner(
    id: json['id'],
    name: json['name'],
    active: json['active'],
    );
  }
}