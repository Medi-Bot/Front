import 'package:flutter/services.dart';

class ServerStarter {
  static const platform = MethodChannel('com.medibot.front/start');

  Future<void> startServer() async {
    try {
      await platform.invokeMethod('startServer');
    } on PlatformException catch (e) {
      print("Failed to start server: '${e.message}'.");
    }
  }
}