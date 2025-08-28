

class Active {
  int? active ;
  String? name;


  Active({
    required this.active,
    required this.name,
  });

  factory Active.fromJson(Map<String, dynamic> json) => Active(
    active: json["active"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "name": name,
  };
  bool isActive(){
    if(active!=null && active==1){
      return true;
    }

    return false;
  }
}