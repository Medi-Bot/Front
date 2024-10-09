import 'package:flutter/material.dart';
import 'package:medibot/accounts_page.dart';
import 'package:medibot/login_page.dart';
import 'package:medibot/splash_screen.dart';
import 'package:medibot/src/medibots_colors.dart';
import 'package:medibot/src/medibot_texts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MediBotTexts.appTittle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MediBotColors.white),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/accounts': (_) => const AccountsPage(),
        '/login': (_) => const LoginPage(username: '', isCreate: false,),
      },
    );
  }
}
