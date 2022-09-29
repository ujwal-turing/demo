import 'dart:async';
import 'dart:convert';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class CleverTapTab extends StatefulWidget {
  const CleverTapTab({Key? key}) : super(key: key);

  @override
  State<CleverTapTab> createState() => _CleverTapTabState();
}

class _CleverTapTabState extends State<CleverTapTab> {
  late CleverTapPlugin _clevertapPlugin;
  var inboxInitialized = false;
  var optOut = false;
  var offLine = false;
  var enableDeviceNetworkingInfo = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    activateCleverTapFlutterPluginHandlers();
    CleverTapPlugin.setDebugLevel(3);
    CleverTapPlugin.createNotificationChannel("fluttertest", "Flutter Test", "Flutter Test", 3, true);
    CleverTapPlugin.initializeInbox();
    CleverTapPlugin.registerForPush(); //only for iOS
    //var initialUrl = CleverTapPlugin.getInitialUrl();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void activateCleverTapFlutterPluginHandlers() {
    _clevertapPlugin = new CleverTapPlugin();
    _clevertapPlugin.setCleverTapPushAmpPayloadReceivedHandler(pushAmpPayloadReceived);
    _clevertapPlugin.setCleverTapPushClickedPayloadReceivedHandler(pushClickedPayloadReceived);
    _clevertapPlugin.setCleverTapInAppNotificationDismissedHandler(inAppNotificationDismissed);
    _clevertapPlugin.setCleverTapProfileDidInitializeHandler(profileDidInitialize);
    _clevertapPlugin.setCleverTapProfileSyncHandler(profileDidUpdate);
    _clevertapPlugin.setCleverTapInboxDidInitializeHandler(inboxDidInitialize);
    _clevertapPlugin.setCleverTapInboxMessagesDidUpdateHandler(inboxMessagesDidUpdate);
    _clevertapPlugin.setCleverTapDisplayUnitsLoadedHandler(onDisplayUnitsLoaded);
    _clevertapPlugin.setCleverTapInAppNotificationButtonClickedHandler(inAppNotificationButtonClicked);
    _clevertapPlugin.setCleverTapInboxNotificationButtonClickedHandler(inboxNotificationButtonClicked);
    _clevertapPlugin.setCleverTapFeatureFlagUpdatedHandler(featureFlagsUpdated);
    _clevertapPlugin.setCleverTapProductConfigInitializedHandler(productConfigInitialized);
    _clevertapPlugin.setCleverTapProductConfigFetchedHandler(productConfigFetched);
    _clevertapPlugin.setCleverTapProductConfigActivatedHandler(productConfigActivated);
  }

  void inAppNotificationDismissed(Map<String, dynamic> map) {
    setState(() {
      debugPrint("***************************************\n\ninAppNotificationDismissed called");
    });
  }

  void inAppNotificationButtonClicked(Map<String, dynamic>? map) {
    setState(() {
      debugPrint("***************************************\n\ninAppNotificationButtonClicked called = ${map.toString()}");
    });
  }

  void inboxNotificationButtonClicked(Map<String, dynamic>? map) {
    setState(() {
      debugPrint("***************************************\n\ninboxNotificationButtonClicked called = ${map.toString()}");
    });
  }

  void profileDidInitialize() {
    setState(() {
      debugPrint("***************************************\n\nprofileDidInitialize called");
    });
  }

  void profileDidUpdate(Map<String, dynamic>? map) {
    setState(() {
      debugPrint("***************************************\n\nprofileDidUpdate called");
    });
  }

  void inboxDidInitialize() {
    setState(() {
      debugPrint("***************************************\n\ninboxDidInitialize called");
      inboxInitialized = true;
    });
  }

  void inboxMessagesDidUpdate() {
    setState(() async {
      debugPrint("***************************************\n\ninboxMessagesDidUpdate called");
      int? unread = await CleverTapPlugin.getInboxMessageUnreadCount();
      int? total = await CleverTapPlugin.getInboxMessageCount();
      debugPrint("***************************************\n\nUnread count = $unread");
      debugPrint("***************************************\n\nTotal count = $total");
    });
  }

  void onDisplayUnitsLoaded(List<dynamic>? displayUnits) {
    setState(() async {
      List? displayUnits = await CleverTapPlugin.getAllDisplayUnits();
      debugPrint("***************************************\n\nDisplay Units = $displayUnits");
    });
  }

  void featureFlagsUpdated() {
    debugPrint("***************************************\n\nFeature Flags Updated");
    setState(() async {
      bool? booleanVar = await CleverTapPlugin.getFeatureFlag("BoolKey", false);
      debugPrint("***************************************\n\nFeature flag = $booleanVar");
    });
  }

  void productConfigInitialized() {
    debugPrint("***************************************\n\nProduct Config Initialized");
    setState(() async {
      await CleverTapPlugin.fetch();
    });
  }

  void productConfigFetched() {
    debugPrint("***************************************\n\nProduct Config Fetched");
    setState(() async {
      await CleverTapPlugin.activate();
    });
  }

  void productConfigActivated() {
    debugPrint("***************************************\n\nProduct Config Activated");
    setState(() async {
      String? stringvar = await CleverTapPlugin.getProductConfigString("StringKey");
      debugPrint("***************************************\n\nPC String = $stringvar");
      int? intvar = await CleverTapPlugin.getProductConfigLong("IntKey");
      debugPrint("***************************************\n\nPC int = $intvar");
      double? doublevar = await CleverTapPlugin.getProductConfigDouble("DoubleKey");
      debugPrint("***************************************\n\nPC double = $doublevar");
    });
  }

  void pushAmpPayloadReceived(Map<String, dynamic> map) {
    debugPrint("***************************************\n\npushAmpPayloadReceived called");
    setState(() async {
      var data = jsonEncode(map);
      debugPrint("***************************************\n\nPush Amp Payload = $data");
      CleverTapPlugin.createNotification(data);
    });
  }

  void pushClickedPayloadReceived(Map<String, dynamic> map) {
    debugPrint("***************************************\n\npushClickedPayloadReceived called");
    setState(() async {
      var data = jsonEncode(map);
      debugPrint("***************************************\n\non Push Click Payload = $data");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const Card(
          color: Colors.tealAccent,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: ListTile(
              title: Text("Identity Management"),
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              title: const Text("Performs onUserLogin"),
              subtitle: const Text("Used to identify multiple profiles"),
              onTap: onUserLogin,
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              title: const Text("Get CleverTap ID"),
              subtitle: const Text("Returns Clevertap ID"),
              onTap: getCleverTapId,
            ),
          ),
        ),
        const Card(
          color: Colors.tealAccent,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: ListTile(
              title: Text("Location"),
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              title: const Text("Set Location"),
              subtitle: const Text("Use to set Location of a user"),
              onTap: setLocation,
            ),
          ),
        ),
        const Card(
          color: Colors.tealAccent,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: ListTile(
              title: Text("User Events"),
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              title: const Text("Add 2 Cart Event"),
              subtitle: const Text("Pushes/Records an event"),
              onTap: recordEvent,
            ),
          ),
        ),
        Card(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              title: const Text("Push Charged Event"),
              subtitle: const Text("Pushes/Records a Charged event"),
              onTap: recordChargedEvent,
            ),
          ),
        ),
      ],
    );
  }

  void onUserLogin() async {
    var stuff = ["bags", "shoes"];
    var profile = {'Name': 'Ujwal Chordiya', 'Identity': '100', 'Email': 'abc@xyz.com', 'Phone': '+911111111111', 'stuff': stuff};
    CleverTapPlugin.onUserLogin(profile);
    // String? fcmToken = await FirebaseMessaging.instance.getToken();
    //print("***************************************\n\nTOKEN: $fcmToken");
    //CleverTapPlugin.setPushToken(fcmToken!);
    CleverTapPlugin.registerForPush();
    showToast("User Logged in. Recorded to the dashboard");
  }

  void getCleverTapId() {
    CleverTapPlugin.getCleverTapID().then((clevertapId) {
      if (clevertapId == null) return;
      setState((() {
        showToast("$clevertapId");
        print("***************************************\n\n$clevertapId");
      }));
    }).catchError((error) {
      setState(() {
        print("***************************************\n\n$error");
      });
    });
  }

  void setLocation() {
    var lat = 19.07;
    var long = 72.87;
    CleverTapPlugin.setLocation(lat, long);
    showToast("Location is set");
  }

  void recordEvent() {
    var now = new DateTime.now();
    var eventData = {
      // Key:    Value
      'product1': 50,
      'product2': 60,
      'date': CleverTapPlugin.getCleverTapDate(now),
    };
    CleverTapPlugin.recordEvent("Add 2 Cart", eventData);
    showToast("Raised event - Add 2 Cart");
  }

  void recordChargedEvent() {
    var item1 = {
      // Key:    Value
      'name': 'thing1',
      'amount': '100'
    };
    var item2 = {
      // Key:    Value
      'name': 'thing2',
      'amount': '100'
    };
    var items = [item1, item2];
    var chargeDetails = {
      // Key:    Value
      'total': '200',
      'payment': 'cash'
    };
    CleverTapPlugin.recordChargedEvent(chargeDetails, items);
    showToast("Raised event - Charged");
  }
}
