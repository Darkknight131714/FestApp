import 'package:festapp/adminHome.dart';
import 'package:festapp/home.dart';
import 'package:festapp/login.dart';
import 'package:festapp/midScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'func.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

CustomUser mainUser = CustomUser();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    ChangeNotifierProvider<CustomUser>(
      create: (_) {
        return mainUser;
      },
      child: MyApp(),
    ),
  );
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        colorScheme:
            ThemeData.dark().colorScheme.copyWith(primary: Colors.orange),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            keepLoggedIn(FirebaseAuth.instance.currentUser!.email.toString());
            if (Provider.of<CustomUser>(context).fest == '') {
              return HomeScreen();
            } else {
              return MidScreen();
            }
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}

class CustomUser extends ChangeNotifier {
  String name = '';
  String email = '';
  String mobile = '';
  String roll = '';
  String fest = '';
  void changeUser(String newName, String newEmail, String newMobile,
      String newRoll, String newFest) {
    name = newName;
    email = newEmail;
    mobile = newMobile;
    roll = newRoll;
    fest = newFest;
    notifyListeners();
  }
}
