import 'dart:async';
import 'dart:convert';
import 'package:betsquad/services/database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<String> getToken() async{
    String token = await _firebaseMessaging.getToken();
    return token;
  }

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");

      DatabaseService().updateMessagingToken(token);

      // init local notification
      var initializationSettingsAndroid = AndroidInitializationSettings('ic_stat_name');
      var initializationSettingsIOS = IOSInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
      _flutterLocalNotificationsPlugin.initialize(initializationSettings);

      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          if (message.containsKey('notification')){
            showLocalNotification(title: message['notification']['title'], message: message['notification']['body']);
          }
          else if (message.containsKey('aps')){
            showLocalNotification(title: message['aps']['alert']['title'], message: message['aps']['alert']['body']);
          }
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );
      _initialized = true;
    }
  }

  // Replace with server token from firebase console settings.
  final String serverToken = 'AAAA3SF8Rdc:APA91bG2KQpJzUv_ju_3lLVxO-kQ8iquJLRVrVhiDJKz4mcphf_LVP08U5vb6gVs37YP_IGMOLx4L3ojb3FZ2KeU-SNf1RuJC-Gfl99ieeUHcooDlYLtGzqv8NX5QmR1190Z25LvacnJ';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<void> sendMessage({String to, String title, String message}) async {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': message,
            'title': title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': to,
        },
      ),
    );
  }

  Future<void> showLocalNotification({String title, String message}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'flutter_notif', 'flutter_notif', 'Show notification',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
        10, title, message, platformChannelSpecifics,
        payload: 'item x');
  }

}