import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:demo/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

setupNotifications() {
  //1. Initialize Notification Channels
  initNotifications();

  //2. Request Notification Permissions
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) AwesomeNotifications().requestPermissionToSendNotifications();
  });

  //3. Initialize Firebase Background Handler
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  //4. Listen and Show Notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) => showNotification(message));
}

Future<void> backgroundHandler(RemoteMessage? message) async {
  await Firebase.initializeApp();
  showNotification(message!);
}

showNotification(RemoteMessage message) async {
  debugPrint(message.data['type'].toString());

  if (message.data['type'] != 'inapp') {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'zp_channel',
        title: message.notification!.title,
        body: message.notification!.body,
      ),
    );
  } else {
    final notificationService = Get.find<NotificationService>();
    String title = "This is an in-app message" ?? '';
    String content = message.data['offer'] ?? '';
    notificationService.showPopup(title, content);
  }
  // final userController = Get.put(UserController());
  // userController.currentUser.value.unreadNotifications = true;
}

initNotifications() {
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'zp_channel_group',
          channelKey: 'zp_channel',
          channelName: 'Notifications',
          channelDescription: 'Notification channel for Zuellig Pharma',
          ledColor: Colors.orange,
          importance: NotificationImportance.Max,
          //channelShowBadge: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupkey: 'zp_channel_group',
          channelGroupName: 'ZP group',
        ),
      ],
      debug: true);
}
