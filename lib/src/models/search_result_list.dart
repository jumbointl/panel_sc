


import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';

import 'category.dart';

class SqlSerchResult{
  List? _list;
  List<ObjectWithNameAndId>? _listObjectWithNameAndId ;
  int sqlLimitInitialValues = 0;
  int sqlLimitValues = 50;
  int sqlLimitCurrentPosition = 0;
  void setList(List? data){
    _list = data;
    if(data!=null){
      _listObjectWithNameAndId = data.cast<ObjectWithNameAndId>();
    }

  }
  List? getList(){
    return _list;
  }

  Category? getObjectById(int? id){
    if(_list==null || _list!.isEmpty ||
        _listObjectWithNameAndId==null || _listObjectWithNameAndId!.isEmpty){
      return null;
    }
    for(int i=0; i<_listObjectWithNameAndId!.length ;i++){
      ObjectWithNameAndId ob = _listObjectWithNameAndId![i];
      if(ob.id==id){
        return _list![i] ;
      }
    }
    return null;
  }
  String getCurrentLimitString(){
    String r = ' limit $sqlLimitCurrentPosition,$sqlLimitValues}' ;
    return r;
  }
  String getNextLimitString(){
    sqlLimitCurrentPosition += sqlLimitValues;
    String r = ' limit $sqlLimitCurrentPosition,$sqlLimitValues}' ;
    return r;
  }
  String getBeforeLimitString(){
    sqlLimitCurrentPosition -= sqlLimitValues;
    String r = ' limit $sqlLimitCurrentPosition,$sqlLimitValues}' ;
    return r;
  }
}