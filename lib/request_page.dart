import 'package:flutter/material.dart';
import 'package:medibot/home_page.dart';
import 'package:medibot/src/medibots_colors.dart';
import 'package:medibot/src/medibot_texts.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key, required this.username});

  final String username;

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MediBotColors.white,
        automaticallyImplyLeading: false,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => Navigator.of(context)
                  ..pop()
                  ..pop(),
                child: const Image(
                    image: AssetImage('assets/images/logo/logo.png')),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.person,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          )
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
