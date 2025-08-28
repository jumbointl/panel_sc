import 'package:intl/intl.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../models/user.dart';

class RelativeTimeUtil {
  
  static String getRelativeTime(int? timestamp) {


    if(timestamp==null || timestamp<=0){
      return '00-00-0000';
    }
    String s = timestamp.toString();
    if(s.length>13){
      s = s.substring(0,13);
    }
    timestamp = int.tryParse(s);
    if(timestamp==null){
      return '00-00-0000';
    }
    var now = Memory.getDateTimeNowLocal();
    var format = DateFormat('dd-MM-yyyy HH:mm a');
    // NODE.JS Date.now() DEVUELVE HORA EN UTC, HAY QUE RESTAR PARA TRABAJAR
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    date = date.add(Duration(hours: Memory.TIMEZONE_OFFSET));
    var diff = now.difference(date);
    var time = format.format(date);

    if(diff.inHours<0){
      if(now.day==date.day){
        return time.split(' ').first;
      } else {
         int days = 1;
         if(diff.inDays<0){
           days = diff.inDays;
         }
         return '${Messages.IN} ${time.substring(0,5)} ($days ${Messages.DAY})';
      }

    }


    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time =  '$time (${diff.inDays} ${Messages.DAY})';
      } else {
        time =  '$time (${diff.inDays} ${Messages.DAYS})';
      }
    } else {
      if (diff.inDays == 7) {
        time =  '$time (${(diff.inDays / 7).floor()} ${Messages.WEEK})';
      } else {

        time =  '$time (${(diff.inDays / 7).floor()} ${Messages.WEEKS})';
      }
    }


    return time;
  }
  static String getTimeOnString(int? timestamp) {
    if(timestamp==null || timestamp<=0){
      return '';
    }
    String s = timestamp.toString();
    if(s.length>13){
      s = s.substring(0,13);
    }
    timestamp = int.tryParse(s);
    if(timestamp==null){
      return '';
    }



    var format = DateFormat('dd-MM-yyyy HH:mm a');
    // NODE.JS Date.now() DEVUELVE HORA EN UTC, HAY QUE RESTAR PARA TRABAJAR
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    date = date.add(Duration(hours: Memory.TIMEZONE_OFFSET));
    var time = format.format(date);
    return time;
  }
  static String getTimeOnStringOnlyDate(String? dateString) {
    if(dateString==null){
      return '00-00-0000';
    }
    var format = DateFormat('dd-MM-yyyy HH:mm a');
    // NODE.JS Date.now() DEVUELVE HORA EN UTC, HAY QUE RESTAR PARA TRABAJAR
    var date = DateTime.tryParse(dateString);
    if(date==null){
      return '00-00-0000';
    }
    date = date.add(Duration(hours: Memory.TIMEZONE_OFFSET));
    var time = format.format(date);
    return time.split(' ').first;
  }
  static String getTimeOnStringOnlyDayMonth(String? dateString) {
    if(dateString==null){
      return '00-00-0000';
    }
    var format = DateFormat('dd-MM-yyyy HH:mm a');
    // NODE.JS Date.now() DEVUELVE HORA EN UTC, HAY QUE RESTAR PARA TRABAJAR
    var date = DateTime.tryParse(dateString);
    if(date==null){
      return '00-00-0000';
    }
    date = date.add(Duration(hours: Memory.TIMEZONE_OFFSET));
    var time = format.format(date);
    return time.substring(0,5);
  }
  static String getStringFromLocalTimeForSql(DateTime? date) {
    if(date==null){
      return '0000-00-00 00:00:00';
    }
    var format = DateFormat('yyyy-MM-dd HH:mm:ss');
    // NODE.JS Date.now() DEVUELVE HORA EN UTC, HAY QUE RESTAR PARA TRABAJAR
    //date = date.add(Duration(hours: -Memory.TIMEZONE_OFFSET));
    var time = format.format(date);
    return time;

  }
  static String getDayOnly(int? timestamp) {
    if(timestamp==null || timestamp<=0){
      return '';
    }
    String s = timestamp.toString();
    if(s.length>13){
      s = s.substring(0,13);
    }
    timestamp = int.tryParse(s);
    if(timestamp==null){
      return '';
    }

    var format = DateFormat('dd-MM-yyyy HH:mm a');
    // NODE.JS Date.now() DEVUELVE HORA EN UTC, HAY QUE RESTAR PARA TRABAJAR
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    date = date.add(Duration(hours: Memory.TIMEZONE_OFFSET));
    var time = format.format(date);
    return time.substring(0,2);
  }
  static String getDayMonth(String? dateString) {
    if(dateString==null){
      return '00-00';
    }
    var format = DateFormat('dd-MM-yyyy HH:mm a');
    // NODE.JS Date.now() DEVUELVE HORA EN UTC, HAY QUE RESTAR PARA TRABAJAR
    var date = DateTime.tryParse(dateString);
    if(date==null){
      return '00-00';
    }
    date = date.add(Duration(hours: Memory.TIMEZONE_OFFSET));

    var time = format.format(date);
    String res = time.substring(0,5);
    return res;
  }
  static String getRelativeTimeFromString(String? dateString) {
    if(dateString==null){
      return '0000-00-00';
    }
    var now = Memory.getDateTimeNowLocal();
    var format = DateFormat('dd-MM-yyyy HH:mm a');
    var date = DateTime.tryParse(dateString);
    if(date==null){
      return '0000-00-00';
    }
    // MYSQL DEVUELVE HORA EN UTC, HAY QUE RESTAR PARA TRABAJAR
    date = date.add(Duration(hours: Memory.TIMEZONE_OFFSET));
    var diff = now.difference(date);
    var time = format.format(date);
    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time =  '$time (${diff.inDays} ${Messages.DAY})';
      } else {
        time =  '$time (${diff.inDays} ${Messages.DAYS})';
      }
    } else {
      if (diff.inDays == 7) {
        time =  '$time (${(diff.inDays / 7).floor()} ${Messages.WEEK})';
      } else {

        time =  '$time (${(diff.inDays / 7).floor()} ${Messages.WEEKS})';
      }
    }
    return time;
  }
  static bool isFirebaseNotificationTokenValid(User user) {
    if(user.notificationToken==null || user.ntfTokenCreatedAt == null){
      return false;
    }
    var now = Memory.getDateTimeNowLocal();
    // NODE.JS Date.now() DEVUELVE HORA EN UTC, HAY QUE RESTAR PARA TRABAJAR
    var date = DateTime.fromMillisecondsSinceEpoch(user.ntfTokenCreatedAt!);
    date = date.add(Duration(hours: Memory.TIMEZONE_OFFSET));
    var diff = now.difference(date);
    if (diff.inDays > Memory.FIREBASE_NOTIFICATION_TOKEN_EXPIRES_DAYS) {
      print('firebase notification token vencido');
      return false;
    } else {
      print('firebase notification token vigente');
      return true;
    }


  }
  static bool isNeedsToLogin(User user) {
    if(user.sessionToken==null || user.sessionTokenCreatedAt == null){
      return true;
    }
    var now = Memory.getDateTimeNowLocal();
    // NODE.JS Date.now() DEVUELVE HORA EN UTC, HAY QUE RESTAR PARA TRABAJAR
    var date = DateTime.fromMillisecondsSinceEpoch(user.sessionTokenCreatedAt!);
    date = date.add(Duration(hours: Memory.TIMEZONE_OFFSET));
    var diff = now.difference(date);
    if (diff.inDays > Memory.SESSION_TOKEN_EXPIRE_IN_DAYS-1) {
      return true;
    } else {
      return false;
    }


  }

  static int differenceToToday(DateTime? dateLocal) {
    if (dateLocal == null) {
      return 1;
    }
    //now = now.add(Duration(hours: Memory.TIMEZONE_OFFSET));
    //date = date.add(Duration(hours: Memory.TIMEZONE_OFFSET));
    // NODE.JS Date.now() DEVUELVE HORA EN UTC, HAY QUE RESTAR PARA TRABAJAR


    var now = Memory.getDateTimeNowLocal();
    now;
    var diff = now.difference(dateLocal);
    if (diff.inDays != 0) {
      return diff.inDays;
    }

    print('Local--- ${dateLocal.day}/${dateLocal.month}/${dateLocal.year}. ${dateLocal.hour}:${dateLocal.minute}');
    print('Now--- ${now.day}/${now.month}/${now.year}. ${now.hour}:${now.minute}');
    if(dateLocal.year==now.year){
      if(dateLocal.month==now.month){
        if(dateLocal.day==now.day){
          return 0;
        } else if(dateLocal.day>now.day){
          return -1;
        } else {
          return 1;
        }
      } else if(dateLocal.month>now.month){
        return -1;
      } else {
        return 1;
      }

    } else if(dateLocal.year>now.year){
      return -1;
    } else {
      return 1;
    }







    return diff.inDays;
  }
  static DateTime? getDateTimeFromSavedGetStorageMicrosecondsSinceEpochLocal(int? timestamp) {
    // GetStorage devuelve mas digitos que 13;
    if(timestamp==null || timestamp<=0){
      return null;
    }
    String s = timestamp.toString();
    if(s.length>13){
      s = s.substring(0,13);
    }
    timestamp = int.tryParse(s);
    if(timestamp==null){
      return null;
    }

    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    date = date.add(Duration(hours: Memory.TIMEZONE_OFFSET));
    return date;
  }
}