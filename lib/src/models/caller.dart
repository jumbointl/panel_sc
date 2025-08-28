import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';

class Caller extends ObjectWithNameAndId {
  Caller({
    super.id,
    super.name,
    super.active,
  });

  static Caller fromJson(json) {
    return Caller(
      id: json['id'],
      name: json['name'],
      active: json['active'],
    );
  }
}