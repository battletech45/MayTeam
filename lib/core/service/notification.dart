// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'log.dart';

class NotificationService {
  final BuildContext context;
  NotificationService(this.context);
  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  @pragma('vm:entry-point')
  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse details) {
    LoggerService.logInfo(
        'onDidReceiveBackgroundNotificationResponse:payload ${details.payload}');
    LoggerService.logInfo(
        'onDidReceiveBackgroundNotificationResponse:actionId ${details.actionId}');
    LoggerService.logInfo(
        'onDidReceiveBackgroundNotificationResponse:id ${details.id}');
    LoggerService.logInfo(
        'onDidReceiveBackgroundNotificationResponse:notificationResponseType ${details.notificationResponseType}');
    navigatePage(details.payload);
  }

  static void navigatePage(String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      Map json = jsonDecode(payload);
      if (json.containsKey('page')) {
        var list = (json['page'] as String).split('/');
        list.remove('');
        LoggerService.logInfo('navigatePage: ${list.toString()}');
        if (list.first == 'kategori') {
          LoggerService.logInfo('navigatePage: kategori');
          //rootKey.currentState?.push(MaterialPageRoute(builder: (_) => NewsDetailScreen(link: list.last)));
        } else if (list.first == 'sayfa') {
          LoggerService.logInfo('navigatePage: sayfa');
          //rootKey.currentState?.push(MaterialPageRoute(builder: (_) => OtherPageScreen(link: list.last)));
        } else if (list.first == 'dergi') {
          LoggerService.logInfo('navigatePage: dergi');
          //rootKey.currentState?.push(MaterialPageRoute(builder: (_) => PDFViewScreen(link: list.last)));
        }
      }
    } else {}
  }

  static void onDidReceiveNotificationResponse(NotificationResponse details) {
    LoggerService.logInfo(
        'onDidReceiveNotificationResponse:payload ${details.payload}');
    LoggerService.logInfo(
        'onDidReceiveNotificationResponse:actionId ${details.actionId}');
    LoggerService.logInfo('onDidReceiveNotificationResponse:id ${details.id}');
    LoggerService.logInfo(
        'onDidReceiveNotificationResponse:notificationResponseType ${details.notificationResponseType}');
    navigatePage(details.payload);
  }

  Future<void> initNotification() async {
    LoggerService.logInfo('initNotification started');
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('logo');
    var ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestProvisionalPermission: true,
    );
    var settings =
        InitializationSettings(android: android, iOS: ios, macOS: ios);
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    LoggerService.logInfo('plugin initialize started');
    await plugin.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
    LoggerService.logInfo('initNotification finished');
  }

  NotificationDetails notificationDetail() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'smartform',
          'smartform',
          importance: Importance.max,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails());
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return plugin.show(id, title, body, notificationDetail(), payload: payload);
  }
}
