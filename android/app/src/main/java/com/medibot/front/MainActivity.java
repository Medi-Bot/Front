package com.medibot.front;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import java.io.IOException;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.medibot.front/start";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("startServer")) {
                        startServer();
                        result.success(null);
                    } else {
                        result.notImplemented();
                    }
                }
        );
    }

    private void startServer() {
        try {
            String jarPath = getFilesDir() + "/libs/Back-0.0.1-SNAPSHOT.jar";
            ProcessBuilder processBuilder = new ProcessBuilder("java", "-jar", jarPath);
            processBuilder.start();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}