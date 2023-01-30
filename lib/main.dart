import 'package:ekskul/constant/color.dart';
import 'package:ekskul/firebase_options.dart';
import 'package:ekskul/pembina/provider/announcement_provider.dart';
import 'package:ekskul/pembina/provider/auth_provider_class.dart';
import 'package:ekskul/pembina/provider/ekstra_provider_class.dart';
import 'package:ekskul/pembina/provider/location_provider.dart';
import 'package:ekskul/pembina/provider/members_provider_class..dart';
import 'package:ekskul/pembina/provider/pembina_provider_class.dart';
import 'package:ekskul/pembina/provider/presenst_provider_class.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  ChangeNotifierProvider<MembersProviderClass>(
      create: (_) => MembersProviderClass()),
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
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    // );
    FocusScope.of(context).unfocus();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // transparent status bar
        // systemNavigationBarColor: Colors.black, // navigation bar color
        // statusBarIconBrightness: Brightness.dark, // status bar icons' color
        // systemNavigationBarIconBrightness:
        //     Brightness.dark, //navigation bar icons' color
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
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
                fontFamily: 'Gotham',
                fontWeight: FontWeight.bold,
                color: Colors.black),
            contentTextStyle: const TextStyle(
              fontFamily: 'Gotham',
              color: Colors.black,
            ),
          ),
        ),
        builder: EasyLoading.init(
          builder: (context, child) {
            // EasyLoading.instance.customAnimation!.buildWidget();
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: child!,
            );
          },
        ),
        home: const Splash(),
      ),
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
