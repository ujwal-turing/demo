import 'package:demo/clever_tap.dart';
import 'package:demo/controllers/notification_controller.dart';
import 'package:demo/firebase.dart';
import 'package:demo/services/notification_service.dart';
import 'package:demo/web_engage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(NotificationService());
  setupNotifications();
  runApp(GetMaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF2D5E64),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: const Color(0xFFC5D351),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2D5E64),
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xFF2D5E64)), textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white, fontSize: 17)), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), minimumSize: MaterialStateProperty.all(const Size(double.infinity, 45)))),
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Zuellig Demo'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2D5E64),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(label: 'Firebase', icon: Icon(Icons.tab, size: MediaQuery.of(context).size.height * 0.020), activeIcon: const Icon(Icons.tab)),
          BottomNavigationBarItem(label: 'WebEngage', icon: Icon(Icons.tab, size: MediaQuery.of(context).size.height * 0.020), activeIcon: const Icon(Icons.tab)),
          BottomNavigationBarItem(label: 'Clever Tap', icon: Icon(Icons.tab, size: MediaQuery.of(context).size.height * 0.020), activeIcon: const Icon(Icons.tab)),
        ],
        currentIndex: tabIndex,
        onTap: (index) => setState(() => tabIndex = index),
      ),
      body: IndexedStack(
        children: userPages(),
        index: tabIndex,
      ),
    );
  }

  userPages() {
    return [
      const FirebaseTab(),
      const WebEngageTab(),
      const CleverTapTab(),
    ];
  }
}
