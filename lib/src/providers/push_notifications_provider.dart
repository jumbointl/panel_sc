import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import 'package:solexpress_panel_sc/src/providers/users_provider.dart';

import '../data/messages.dart';
import '../models/user.dart';

class PushNotificationsProvider extends ProviderModel{

  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  void initPushNotifications() async {
    await plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onMessageListener() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('NUEVA NOTIFICACION');
      }
    });
    // PRIMER PLANO
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print('NUEVA NOTIFICACION EN PRIMER PLANO');
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

  void showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null) {
      print('${notification.title} ${notification.body}');
    }

    if (notification != null && android != null) {
      plugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: 'launch_background',
          ),
        ),
      );
    }
  }


  void saveFirebaseNotificationToken(User user) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if(token==null){
      showErrorMessages(Messages.TOKEN_NOT_GENERATED);
      return;
    }
    if(user.notificationToken !=null && token == user.notificationToken){
      print('Token iguales');
      return;
    }
    user.notificationToken = token;

    FirebaseMessaging.instance.subscribeToTopic('sol_express_py');
    UsersProvider usersProvider = UsersProvider();
      
    await usersProvider.updateNotificationToken(user);

  }

}