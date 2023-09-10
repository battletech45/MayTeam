import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showCustomNotification(RemoteMessage message) async {
    _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // Change this to your own channel ID
      'Custom Notification', // Change this to a proper channel name
      channelDescription: 'Notification for custom content', // Change this to a proper description
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification!.title, // Notification title
      message.notification!.body, // Notification content
      platformChannelSpecifics,
      payload: 'custom_notification', // Optionally add a payload to identify the notification
    );
  }
}



Future<void> onBackgroundMessage(RemoteMessage message) async {
  NotificationHelper.showCustomNotification(message);
}

class FCM {
  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
          (message) async {
        if (message.data.containsKey('data')) {
          streamCtlr.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          streamCtlr.sink.add(message.data['notification']);
        }
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);

        NotificationHelper.showCustomNotification(message);
      },
    );
  }

  Future<void> sendNotification(String title, String body, String targetToken) async {

    String? fcmToken = await FirebaseMessaging.instance.getToken();

    final Map<String, dynamic> notificationData = {
      'notification': {
        'title': title,
        'body': body,
      },
      'priority': 'high',
      'to': targetToken,
    };

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAATl1qm9Q:APA91bGArOF58ZVfw5lhpMgYecBjK3-ujP41sfRHM9uDGqFopoAxuW39xP670yv1XF3Kd9hYD2s_5fBFRTwKM31l9t0o1caL7i6mOmEU2mbC8QNodygsEUTyoY1g07cV66mou3EC8N75',
    };

    final response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), headers: headers, body: jsonEncode(notificationData));

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Error sending notification: ${response.statusCode}');
    }
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}