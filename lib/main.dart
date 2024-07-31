import 'package:babyshophub/Add_Category.dart';
import 'package:babyshophub/Add_Screen.dart';
import 'package:babyshophub/dashboard.dart';
import 'package:babyshophub/page_indicator.dart';
import 'package:babyshophub/sujjestion_Add.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'login.dart';
import 'notification_service.dart';
import 'register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userEmail = prefs.getString('userEmail');

  runApp(MyApplication(startScreen: userEmail == null ? LoginScreen() : Product_Page()));
}

class MyApplication extends StatelessWidget {
  final Widget startScreen;

  MyApplication({required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Product_Page(),
      debugShowCheckedModeBanner: false,
    );
  }
}
