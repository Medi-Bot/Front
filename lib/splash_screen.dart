import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medibot/accounts_page.dart';
import 'package:medibot/src/medibot_texts.dart';

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
        const Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AccountsPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
            child: Column(children: [
              SizedBox(
                  height: 15
              ),
              CircularProgressIndicator(color: Colors.black)
            ],)
        ),
      ),
    );
  }
}
