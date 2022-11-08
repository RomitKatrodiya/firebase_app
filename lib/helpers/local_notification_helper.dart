import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationHelper {
  LocalNotificationHelper._();
  static final LocalNotificationHelper localNotificationHelper =
      LocalNotificationHelper._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> simpleNotification() async {
    var android = const AndroidNotificationDetails('id', 'channel ',
        channelDescription: 'description',
        priority: Priority.max,
        importance: Importance.max);

    var iOS = const DarwinNotificationDetails();

    var platform = NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Simple Notification',
      'Flutter Local Notification Demo',
      platform,
      payload: 'Your Custom Data',
    );
  }

  Future<void> scheduleNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channel id', 'channel name',
        channelDescription: 'channel description',
        icon: 'mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
        priority: Priority.max,
        importance: Importance.max);

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'scheduled Notification',
      'Flutter Local Notification Demo',
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 2)),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: "Your Custom Data",
    );
  }

  Future<void> bigPictureNotification() async {
    var bigPictureStyleInformation = const BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
      largeIcon: DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
      contentTitle: 'flutter devs',
      summaryText: 'summaryText',
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        channelDescription: 'big text channel description',
        styleInformation: bigPictureStyleInformation,
        priority: Priority.max,
        importance: Importance.max);

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Big Picture Notification',
      'Flutter Local Modification Demo',
      platformChannelSpecifics,
      payload: "Your Custom Data",
    );
  }

  Future<void> mediaStyleNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'media channel id', 'media channel name',
        channelDescription: 'media channel description',
        color: Colors.red,
        enableLights: true,
        largeIcon: DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
        styleInformation: MediaStyleInformation(),
        priority: Priority.max,
        importance: Importance.max);

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);

    await flutterLocalNotificationsPlugin.show(0, 'Media Style Notification',
        'Flutter Local Notification Demo', platformChannelSpecifics,
        payload: "Your Custom Data");
  }
}
