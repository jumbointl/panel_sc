class SqlQueryCondition {
  String whereAndOrderby;
  int? idCategory;
  String? name;
  int? idGroup;

  SqlQueryCondition({
    required this.whereAndOrderby,
    this.idCategory,
    this.name,
    this.idGroup,
  });
  factory SqlQueryCondition.fromJson(Map<String, dynamic> json) => SqlQueryCondition(
    whereAndOrderby: json["where_and_order_by"],
    idCategory: json["id_category"],
    idGroup: json["id_group"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "where_and_order_by": whereAndOrderby,
    "id_category": idCategory,
    "id_group": idGroup,
    "name": name,

  };
  static List<SqlQueryCondition> fromJsonList(List<dynamic> list){
    List<SqlQueryCondition> newList =[];
    for (var item in list) {
      if(item is SqlQueryCondition){
        newList.add(item);
      } else {
        SqlQueryCondition sqlQueryCondition = SqlQueryCondition.fromJson(item);
        newList.add(sqlQueryCondition);
      }

    }
    return newList;
  }

}