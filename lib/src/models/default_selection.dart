


class DefaultSelection {
  int? defaultSelection ;
  String? name;


  DefaultSelection({
    required this.defaultSelection,
    required this.name,
  });

  factory DefaultSelection.fromJson(Map<String, dynamic> json) => DefaultSelection(
    defaultSelection: json["default_selection"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "default_selection": defaultSelection,
    "name": name,
  };
  bool isDefaultSelection(){
    if(defaultSelection!=null && defaultSelection==1){
      return true;
    }

    return false;
  }
}