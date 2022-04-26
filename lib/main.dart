import 'package:email_password_login/api/firebase_api.dart';
import 'package:email_password_login/screens/app_view.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/notifier/auth_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseRepository>(
          create: (_) => FirebaseRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthNotifier(),
        )
      ],
      child: MaterialApp(
        title: '2FA',
        theme: ThemeData(primarySwatch: Colors.orange),
        debugShowCheckedModeBanner: false,
        home: AppView(),
      ),
    );
  }
}
