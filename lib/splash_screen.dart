import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medibot/accounts_page.dart';
import 'package:medibot/src/medibot_texts.dart';
import 'package:medibot/src/medibots_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    super.initState();

    Timer(
        const Duration(seconds: 2),
            () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AccountsPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              const Image(image: AssetImage('assets/images/logo/logo.png')),
              CircularProgressIndicator(color: MediBotColors.color3),
              Text('')
            ],)
        ),
      ),
    );
  }
}
