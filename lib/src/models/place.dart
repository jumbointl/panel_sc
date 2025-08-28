
import 'object_with_name_and_id.dart';

class Place extends ObjectWithNameAndId{
  Place({
    required super.id,
    required super.name,
    super.active,
  });

  static Place fromJson(json) {
    return Place(
      id: json['id'],
      name: json['name'],
      active: json['active'],
    );
  }

}