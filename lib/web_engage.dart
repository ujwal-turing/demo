import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class WebEngageTab extends StatefulWidget {
  const WebEngageTab({Key? key}) : super(key: key);

  @override
  State<WebEngageTab> createState() => _WebEngageTabState();
}

class _WebEngageTabState extends State<WebEngageTab> {
  late WebEngagePlugin _webEngagePlugin;
  late String os;

  void _onPushClick(Map<String, dynamic>? message, String? s) {
    debugPrint("This is a push click callback from native to flutter. Payload $message");
  }

  void _onPushActionClick(Map<String, dynamic>? message, String? s) {
    debugPrint("This is a Push action click callback from native to flutter. Payload $message");
    debugPrint("This is a Push action click callback from native to flutter. SelectedId $s");
  }

  void _onInAppPrepared(Map<String, dynamic>? message) {
    debugPrint("This is a inapp prepared callback from native to flutter. Payload $message");
  }

  void _onInAppClick(Map<String, dynamic>? message, String? s) {
    debugPrint("This is a inapp click callback from native to flutter. Payload $message");
  }

  void _onInAppShown(Map<String, dynamic>? message) {
    debugPrint("This is a callback on inapp shown from native to flutter. Payload $message");
  }

  void _onInAppDismiss(Map<String, dynamic>? message) {
    debugPrint("This is a callback on inapp dismiss from native to flutter. Payload $message");
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initWebEngage();
  }

  void initWebEngage() {
    _webEngagePlugin = WebEngagePlugin();
    _webEngagePlugin.setUpPushCallbacks(_onPushClick, _onPushActionClick);
    _webEngagePlugin.setUpInAppCallbacks(_onInAppClick, _onInAppShown, _onInAppDismiss, _onInAppPrepared);
    subscribeToPushCallbacks();
    subscribeToTrackDeeplink();
    subscribeToAnonymousIDCallback();
    _listenToAnonymousID();
  }

  var data = "";

  void _listenToAnonymousID() {
    // _webEngagePlugin.anonymousActionStream.listen((event) {
    //   setState(() {
    //     data = "$event";
    //   });
    // });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await WebEngagePlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {});
  }

  var anonymousId = "null";

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text("Login "),
          onTap: () {
            String s = "test${randomString(6)}";
            WebEngagePlugin.userLogin(s);
            showToast("Login-$s");
          },
        ),
        ListTile(
          title: const Text("Logout"),
          onTap: () {
            WebEngagePlugin.userLogout();
            showToast("Logout");
          },
        ),
        ListTile(
          title: const Text("Set FirstName"),
          onTap: () {
            WebEngagePlugin.setUserFirstName('Ujwal');
            showToast("User FirstName- Ujwal");
          },
        ),
        ListTile(
          title: const Text("Set LastName"),
          onTap: () {
            WebEngagePlugin.setUserLastName('Chordiya');
            showToast("LastName Chordiya");
          },
        ),
        ListTile(
          title: const Text("Set UserEmail"),
          onTap: () {
            WebEngagePlugin.setUserEmail('uvchordiya@zuelligpharma.com');
            showToast("Email - uvchordiya@zuelligpharma.com");
          },
        ),
        ListTile(
          title: const Text("Set UserHashedEmail"),
          onTap: () {
            WebEngagePlugin.setUserHashedEmail('144e0424883546e07dcd727057fd3b62');
            showToast("HashedEmail - 144e0424883546e07dcd727057fd3b62");
          },
        ),
        ListTile(
          title: const Text("Set UserPhone"),
          onTap: () {
            WebEngagePlugin.setUserPhone('+919999900000');
            showToast("Phone - +919999900000");
          },
        ),
        ListTile(
          title: const Text("Set UserHashedPhone"),
          onTap: () {
            WebEngagePlugin.setUserHashedPhone('e0ec043b3f9e198ec09041687e4d4e8d');
            showToast("HashedPhone - e0ec043b3f9e198ec09041687e4d4e8d");
          },
        ),
        ListTile(
          title: const Text("Set UserCompany"),
          onTap: () {
            WebEngagePlugin.setUserCompany('WebEngage');
            showToast("Company - WebEngage");
          },
        ),
        ListTile(
          title: const Text("Set UserBirthDate"),
          onTap: () {
            WebEngagePlugin.setUserBirthDate('1990-02-05');
            showToast("BirthDate - 1990-02-05");
          },
        ),
        ListTile(
          title: const Text("Set User Gender"),
          onTap: () {
            WebEngagePlugin.setUserGender('male');
            showToast("Gender - Male");
          },
        ),
        ListTile(
          title: const Text("Set User Location"),
          onTap: () {
            WebEngagePlugin.setUserLocation(19.25, 72.45);
            showToast("Location - 19.25, 72.45");
          },
        ),
        ListTile(
          title: const Text("Track Event with no attributes"),
          onTap: () {
            WebEngagePlugin.trackEvent('Added to Cart');
            showToast("Added to Cart tracked ");
          },
        ),
        ListTile(
          title: const Text("Opt-In  Push, InApp,email,sms"),
          onTap: () {
            WebEngagePlugin.setUserOptIn('in_app', true);
            WebEngagePlugin.setUserOptIn('sms', true);
            WebEngagePlugin.setUserOptIn('push', true);
            WebEngagePlugin.setUserOptIn('email', true);
            showToast("Opt-In  Push, InApp,email,sms ");
          },
        ),
        ListTile(
          title: const Text("Opt-Out  Push, InApp,email,sms"),
          onTap: () {
            WebEngagePlugin.setUserOptIn('in_app', false);
            WebEngagePlugin.setUserOptIn('sms', false);
            WebEngagePlugin.setUserOptIn('push', false);
            WebEngagePlugin.setUserOptIn('email', false);
            showToast("Opt-Out  Push, InApp,email,sms ");
          },
        ),
        ListTile(
          title: const Text("Track event with attributes"),
          onTap: () {
            WebEngagePlugin.trackEvent('Order Placed', {'Amount': 808.48});
            showToast("Order Placed tracked Amount: 808.48");
          },
        ),
        ListTile(
          title: const Text("Track Screen"),
          onTap: () {
            WebEngagePlugin.trackScreen('Home Page');
            showToast("Track Screen :Home Page");
          },
        ),
        ListTile(
          title: const Text("Track Screen with data"),
          onTap: () {
            WebEngagePlugin.trackScreen('Product Page', {'Product Id': 'UHUH799'});
            showToast("Track Screen :Product Page', {'Product Id': 'UHUH799'}");
          },
        ),
        ListTile(
          title: const Text("Track Date"),
          onTap: () {
            final DateTime now = DateTime.now();
            final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
            WebEngagePlugin.trackEvent('Register', {'Registered On': formatter.format(now)});
            showToast("Track ${formatter.format(now)}");
          },
        ),
      ],
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
  }

  @override
  void dispose() {
    _webEngagePlugin.pushSink.close();
    _webEngagePlugin.pushActionSink.close();
    _webEngagePlugin.trackDeeplinkURLStreamSink.close();
    super.dispose();
  }

  void subscribeToPushCallbacks() async {
    //Push click stream listener
    _webEngagePlugin.pushStream.listen((event) {
      //String? deepLink = event.deepLink;
      //Map<String, dynamic> messagePayload = event.payload!;
      showDialogWithMessage("Push click callback: $event");
    });

    //Push action click listener
    _webEngagePlugin.pushActionStream.listen((event) {
      debugPrint("pushActionStream:$event");
      //String? deepLink = event.deepLink;
      //Map<String, dynamic>? messagePayload = event.payload;
      showDialogWithMessage("PushAction click callback: $event");
    });
  }

  void subscribeToTrackDeeplink() {
    _webEngagePlugin.trackDeeplinkStream.listen((location) {
      //Location URL
    });
  }

  void subscribeToAnonymousIDCallback() {
    // _webEngagePlugin.anonymousActionStream.listen((event) {
    //   //  var message = event as Map<String,dynamic>;
    //   this.setState(() {
    //     anonymousId  =  "${event}";
    //   });
    // });
  }

  final navigatorKey = GlobalKey<NavigatorState>();

  void showDialogWithMessage(String msg) {
    showDialog(
        context: navigatorKey.currentState!.overlay!.context,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: const EdgeInsets.all(5.0),
              child: Container(
                // padding: new EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                  msg,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontFamily: 'helvetica_neue_light',
                  ),
                  textAlign: TextAlign.center,
                ),
              ));
        });
  }
}
