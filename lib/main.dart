import 'package:ekskul/provider/announcement_provider.dart';
import 'package:ekskul/provider/auth_provider_class.dart';
import 'package:ekskul/provider/ekstra_provider_class.dart';
import 'package:ekskul/provider/location_provider.dart';
import 'package:ekskul/provider/presenst_provider_class.dart';
import 'package:ekskul/provider/user_provider_class.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void main() async {
    runApp(MultiProvider(
    providers: providers,
    child: const MyApp(),
  ));
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<AuthProviderClass>(create: (_) => AuthProviderClass()),
  ChangeNotifierProvider<UserProviderClass>(create: (_) => UserProviderClass()),
  ChangeNotifierProvider<EkstraProviderClass>(
      create: (_) => EkstraProviderClass()),
  ChangeNotifierProvider<AnnouncementsProviderClass>(
      create: (_) => AnnouncementsProviderClass()),
  ChangeNotifierProvider<PresentsProviderClass>(
      create: (_) => PresentsProviderClass()),
  ChangeNotifierProvider<LocationProviderClass>(
      create: (_) => LocationProviderClass()),
];

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin!.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel!.id,
    //           channel!.name,
    //           channelDescription: channel!.description,
    //           icon: 'launch_background',
    //         ),
    //       ),
    //     );
    //   }
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('notification clicked!');
    //   // navigation
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          titleTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.black),
          color: Colors.white,
        ),
        fontFamily: 'Gotham',
        dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          titleTextStyle: const TextStyle(
              fontFamily: '', fontWeight: FontWeight.bold, color: Colors.black),
          contentTextStyle: const TextStyle(
            fontFamily: '',
            color: Colors.black,
          ),
        ),
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child!,
        );
      },
      home: const Splash(),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
