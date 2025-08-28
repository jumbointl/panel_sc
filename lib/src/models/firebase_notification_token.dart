import 'dart:convert';

FirebaseNotificationToken firebaseNotificationTokeFromJson(String str) => FirebaseNotificationToken.fromJson(json.decode(str));

String firebaseNotificationTokenToJson(FirebaseNotificationToken data) => json.encode(data.toJson());

class FirebaseNotificationToken {
  int? timeStamp ;
  int? idUser ;
  String? notificationToken;


  FirebaseNotificationToken({
    this.timeStamp,
    this.idUser,
    this.notificationToken,
  });

  factory FirebaseNotificationToken.fromJson(Map<String, dynamic> json) => FirebaseNotificationToken(
    timeStamp: json["time_stamp"],
    idUser: json["id_user"],
    notificationToken: json["notification_token"],
  );
  static List<FirebaseNotificationToken> fromJsonList(List<dynamic> list){
    List<FirebaseNotificationToken> newList =[];
    for (var item in list) {
      if(item is FirebaseNotificationToken){
        newList.add(item);
      } else {
        FirebaseNotificationToken firebaseNotificationToken = FirebaseNotificationToken.fromJson(item);
        newList.add(firebaseNotificationToken);
      }

    }
    return newList;
  }
  Map<String, dynamic> toJson() => {
    "time_stamp": timeStamp,
    "id_user": idUser,
    "notification_token": notificationToken,
  };
  bool isActive(){
    if(timeStamp!=null && timeStamp==1){
      return true;
    }

    return false;
  }
}