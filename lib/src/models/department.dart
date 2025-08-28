
import 'category.dart';

class Department extends Category {
  Department({
    super.id,
    super.name,
    super.active,
});

 static Department fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
      active: json['active'],
    );

 }


}