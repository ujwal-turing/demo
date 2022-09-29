import 'package:demo/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseTab extends StatefulWidget {
  const FirebaseTab({
    Key? key,
  }) : super(key: key);

  @override
  State<FirebaseTab> createState() => _FirebaseTabState();
}

class _FirebaseTabState extends State<FirebaseTab> {
  final notificationService = Get.find<NotificationService>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          const Text(
            'Send Push Notification',
            textScaleFactor: 1.75,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => notificationService.sendLocalNotification(),
            child: const Text(
              'Send a local notification',
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async => await notificationService.sendNotification("Cloud"),
            child: const Text('Send a push notification'),
          ),
          const Divider(height: 50),
          const Text(
            'Send an in-app Notification',
            textScaleFactor: 1.75,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async => await notificationService.sendNotification(
              'inapp',
            ),
            child: const Text(
              "Send custom in-app message",
            ),
          ),
          const Divider(height: 50),
          const Text(
            "Other Local Notifiers",
            textScaleFactor: 1.75,
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => notificationService.showSnackBar(),
            child: const Text(
              "Show snack-bar",
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => notificationService.showToast(),
            child: const Text(
              "Show toast",
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => notificationService.showPopup(
              "Sample popup",
              "This is a sample dialog",
            ),
            child: const Text(
              "Show popup",
            ),
          ),
        ],
      ),
    );
  }
}
