import 'dart:async';

import 'package:demo/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/model/app_status.dart';
import 'package:moengage_flutter/model/gender.dart';
import 'package:moengage_flutter/model/geo_location.dart';
import 'package:moengage_flutter/model/inapp/click_data.dart';
import 'package:moengage_flutter/model/inapp/inapp_data.dart';
import 'package:moengage_flutter/model/inapp/self_handled_data.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/model/push/push_token_data.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter/properties.dart';

class MoEngageTab extends StatefulWidget {
  const MoEngageTab({Key? key}) : super(key: key);

  @override
  State<MoEngageTab> createState() => _MoEngageTabState();
}

class _MoEngageTabState extends State<MoEngageTab> with WidgetsBindingObserver {
  final MoEngageFlutter _moengagePlugin = MoEngageFlutter("0D267X16S0A6CHRRO3K7NQPP");

  void _onPushClick(PushCampaignData message) {
    debugPrint("Main : _onPushClick(): This is a push click callback from native to flutter. Payload $message");
  }

  void _onInAppClick(ClickData message) {
    debugPrint("Main : _onInAppClick() : This is a inapp click callback from native to flutter. Payload $message");
  }

  void _onInAppShown(InAppData message) {
    debugPrint("Main : _onInAppShown() : This is a callback on inapp shown from native to flutter. Payload $message");
  }

  void _onInAppDismiss(InAppData message) {
    debugPrint("Main : _onInAppDismiss() : This is a callback on inapp dismiss from native to flutter. Payload $message");
  }

  void _onInAppSelfHandle(SelfHandledCampaignData message) async {
    debugPrint("Main : _onInAppSelfHandle() : This is a callback on inapp self handle from native to flutter. Payload $message");
    final SelfHandledActions action = await asyncSelfHandledDialog(buildContext);
    switch (action) {
      case SelfHandledActions.Shown:
        _moengagePlugin.selfHandledShown(message);
        break;
      case SelfHandledActions.Clicked:
        _moengagePlugin.selfHandledClicked(message);
        break;
      case SelfHandledActions.Dismissed:
        _moengagePlugin.selfHandledDismissed(message);
        break;
    }
  }

  void _onPushTokenGenerated(PushTokenData pushToken) {
    debugPrint("Main : _onPushTokenGenerated() : This is callback on push token generated from native to flutter: PushToken: $pushToken");
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    debugPrint("initState() : start ");
    _moengagePlugin.setPushClickCallbackHandler(_onPushClick);
    _moengagePlugin.setInAppClickHandler(_onInAppClick);
    _moengagePlugin.setInAppShownCallbackHandler(_onInAppShown);
    _moengagePlugin.setInAppDismissedCallbackHandler(_onInAppDismiss);
    _moengagePlugin.setSelfHandledInAppHandler(_onInAppSelfHandle);
    _moengagePlugin.setPushTokenCallbackHandler(_onPushTokenGenerated);
    _moengagePlugin.initialise();
    debugPrint("initState() : end ");
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    //Push.getTokenStream.listen(_onTokenEvent, onError: _onTokenError);
  }

  late BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    debugPrint("Main : build() ");
    return ListView(
      children: ListTile.divideTiles(context: context, tiles: [
        ListTile(
            title: const Text("Track Event with Attributes"),
            onTap: () async {
              var details = MoEProperties();
              details
                  .addAttribute("temp", 567)
                  .addAttribute("temp1", true)
                  .addAttribute("temp2", 12.30)
                  .addAttribute("stringAttr", "string val")
                  .addAttribute("attrName1", "attrVal")
                  .addAttribute("attrName2", false)
                  .addAttribute("attrName3", 123563563)
                  .addAttribute("arrayAttr", [
                    "str1",
                    12.8,
                    "str2",
                    123,
                    true,
                    {"hello": "testing"}
                  ])
                  .setNonInteractiveEvent()
                  .addAttribute("location1", MoEGeoLocation(12.1, 77.18))
                  .addAttribute("location2", MoEGeoLocation(12.2, 77.28))
                  .addAttribute("location3", MoEGeoLocation(12.3, 77.38))
                  .addISODateTime("dateTime1", "2019-12-02T08:26:21.170Z")
                  .addISODateTime("dateTime2", "2019-12-06T08:26:21.170Z");
              final String value = await asyncInputDialog(context, "Event name");
              debugPrint("Main: Event name : $value");
              _moengagePlugin.trackEvent(value, details);
            }),
        ListTile(
            title: const Text("Track Interactive Event with Attributes"),
            onTap: () async {
              var details = MoEProperties();
              details
                  .addAttribute("temp", 567)
                  .addAttribute("temp1", true)
                  .addAttribute("temp2", 12.30)
                  .addAttribute("stringAttr", "string val")
                  .addAttribute("attrName1", "attrVal")
                  .addAttribute("attrName2", false)
                  .addAttribute("attrName3", 123563563)
                  .addAttribute("arrayAttr", [
                    "str1",
                    12.8,
                    "str2",
                    123,
                    true,
                    {"hello": "testing"}
                  ])
                  .addAttribute("location1", MoEGeoLocation(12.1, 77.18))
                  .addAttribute("location2", MoEGeoLocation(12.2, 77.28))
                  .addAttribute("location3", MoEGeoLocation(12.3, 77.38))
                  .addISODateTime("dateTime1", "2019-12-02T08:26:21.170Z")
                  .addISODateTime("dateTime2", "2019-12-06T08:26:21.170Z");
              final String value = await asyncInputDialog(context, "Event name");
              debugPrint("Main: Event name : $value");
              _moengagePlugin.trackEvent(value, details);
            }),
        ListTile(
            title: const Text("Track Only Event"),
            onTap: () async {
              final String value = await asyncInputDialog(context, "Event name");
              debugPrint("Main: Event name : $value");
              _moengagePlugin.trackEvent(value);
              _moengagePlugin.trackEvent(value, MoEProperties());
            }),
        ListTile(
            title: const Text("Set Unique Id"),
            onTap: () async {
//                    _moengagePlugin.setUniqueId(null);
              final String value = await asyncInputDialog(context, "Unique Id");
              debugPrint("Main: UniqueId: $value");
              _moengagePlugin.setUniqueId(value);
            }),
        ListTile(
            title: const Text("Set UserName"),
            onTap: () async {
              _moengagePlugin.setUserName("Ujwal Chordiya");
              final String value = await asyncInputDialog(context, "User Name");
              debugPrint("Main: UserName: $value");
              _moengagePlugin.setUserName(value);
            }),
        ListTile(
            title: const Text("Set FirstName"),
            onTap: () async {
              final String value = await asyncInputDialog(context, "First Name");
              debugPrint("Main: FisrtName: $value");
              _moengagePlugin.setFirstName(value);
            }),
        ListTile(
            title: const Text("Set LastName"),
            onTap: () async {
              final String value = await asyncInputDialog(context, "Last Name");
              debugPrint("Main: Last Name: $value");
              _moengagePlugin.setLastName(value);
            }),
        ListTile(
            title: const Text("Set Email-Id"),
            onTap: () async {
              final String value = await asyncInputDialog(context, "EmailId");
              debugPrint("Main: EmailId: $value");
              _moengagePlugin.setEmail(value);
            }),
        ListTile(
            title: const Text("Set Phone Number"),
            onTap: () async {
              final String value = await asyncInputDialog(context, "Phone Number");
              debugPrint("Main: Phone Number: $value");
              _moengagePlugin.setPhoneNumber(value);
            }),
        ListTile(
            title: const Text("Set Gender"),
            onTap: () {
              _moengagePlugin.setGender(MoEGender.female);
            }),
        ListTile(
            title: const Text("Set Location"),
            onTap: () {
              _moengagePlugin.setLocation(MoEGeoLocation(23.1, 21.2));
            }),
        ListTile(
            title: const Text("Set Birthday"),
            onTap: () {
              _moengagePlugin.setBirthDate("2019-12-02T08:26:21.170Z");
            }),
        ListTile(
          title: const Text("Set Alias"),
          onTap: () async {
            final String value = await asyncInputDialog(context, "Alias");
            debugPrint("Main: Alias : $value");
            _moengagePlugin.setAlias(value);
          },
        ),
        ListTile(
          title: const Text("Set Custom User Attributes"),
          onTap: () {
            _moengagePlugin.setUserAttribute("userAttr-bool", true);
            _moengagePlugin.setUserAttribute("userAttr-int", 1443322);
            _moengagePlugin.setUserAttribute("userAttr-Double", 45.4567);
            _moengagePlugin.setUserAttribute("userAttr-String", "This is a string");
          },
        ),
        ListTile(
          title: const Text("Set UserAttribute Timestamp"),
          onTap: () {
            _moengagePlugin.setUserAttributeIsoDate("timeStamp", "2019-12-02T08:26:21.170Z");
          },
        ),
        ListTile(
          title: const Text("Set UserAttribute Location"),
          onTap: () {
            _moengagePlugin.setUserAttributeLocation("locationAttr", MoEGeoLocation(72.8, 53.2));
          },
        ),
        ListTile(
            title: const Text("App Status - Install"),
            onTap: () {
              _moengagePlugin.setAppStatus(MoEAppStatus.install);
            }),
        ListTile(
            title: const Text("App Status - Update"),
            onTap: () {
              _moengagePlugin.setAppStatus(MoEAppStatus.update);
            }),
        ListTile(
            title: const Text("iOS -- Register For Push"),
            onTap: () {
              _moengagePlugin.registerForPushNotification();
            }),
        ListTile(
            title: const Text("Show InApp"),
            onTap: () {
              _moengagePlugin.showInApp();
            }),
        ListTile(
            title: const Text("Show Self Handled InApp"),
            onTap: () {
              buildContext = context;
              _moengagePlugin.getSelfHandledInApp();
            }),
        ListTile(
            title: const Text("Set InApp Contexts"),
            onTap: () {
              _moengagePlugin.setCurrentContext(["HOME", "SETTINGS"]);
            }),
        ListTile(
            title: const Text("Reset Contexts"),
            onTap: () {
              _moengagePlugin.resetCurrentContext();
            }),
        ListTile(
            title: const Text("Android -- FCM Push Token"),
            onTap: () async {
              String? fcmToken = await FirebaseMessaging.instance.getToken();
//                     Token passed here is just for illustration purposes. Please pass the actual token instead.
//                    _moengagePlugin.passFCMPushToken(null);
              _moengagePlugin.passFCMPushToken(fcmToken!);
            }),
        ListTile(
            title: const Text("Android -- PushKit Push Token"),
            onTap: () {
              // Token passed here is just for illustration purposes. Please pass the actual token instead.
              _moengagePlugin.passPushKitPushToken("IQAAAACy0T43AABSrIoiO4BN6XNORkptaWgyxTTEcIS9EgA1PUeNdYcAeBP6Ea-X6oIsWv5j7HKA8Hdna_JBMpNiVp_B8xR8HYEHC2Yw5yhE69AyaQ");
            }),
        ListTile(
            title: const Text("Android -- FCM Push Payload"),
            onTap: () {
              // this payload is only for illustration purpose. Please pass the actual push payload.
              var pushPayload = Map<String, String>();
              pushPayload.putIfAbsent("push_from", () => "moengage");
              pushPayload.putIfAbsent("gcm_title", () => "Title");
              pushPayload.putIfAbsent("moe_app_id", () => "0D267X16S0A6CHRRO3K7NQPP");
              pushPayload.putIfAbsent("gcm_notificationType", () => "normal notification");
              pushPayload.putIfAbsent("gcm_alert", () => "Message");

              pushPayload.putIfAbsent("gcm_campaign_id", () => DateTime.now().millisecondsSinceEpoch.toString());
              pushPayload.putIfAbsent("gcm_activityName", () => "com.moengage.sampleapp.MainActivity");
              _moengagePlugin.passFCMPushPayload(pushPayload);
            }),
        ListTile(
            title: const Text("Enable data tracking"),
            onTap: () {
              _moengagePlugin.enableDataTracking();
            }),
        ListTile(
            title: const Text("Disable data tracking"),
            onTap: () {
              _moengagePlugin.disableDataTracking();
            }),
        ListTile(
          title: const Text("Logout"),
          onTap: () {
            _moengagePlugin.logout();
          },
        ),
        ListTile(
          title: const Text("Enable Sdk"),
          onTap: () async {
            _moengagePlugin.enableSdk();
          },
        ),
        ListTile(
          title: const Text("Disable Sdk"),
          onTap: () async {
            _moengagePlugin.disableSdk();
          },
        ),
        ListTile(
          title: const Text("Android- Enable Android Id"),
          onTap: () async {
            _moengagePlugin.enableAndroidIdTracking();
          },
        ),
        ListTile(
          title: const Text("Android- Disable Android Id"),
          onTap: () async {
            _moengagePlugin.disableAndroidIdTracking();
          },
        ),
        ListTile(
          title: const Text("Android- Enable Ad Id"),
          onTap: () async {
            _moengagePlugin.enableAdIdIdTracking();
          },
        ),
        ListTile(
          title: const Text("Android- Disable Ad Id"),
          onTap: () async {
            _moengagePlugin.disableAdIdTracking();
          },
        )
      ]).toList(),
    );
  }
}
