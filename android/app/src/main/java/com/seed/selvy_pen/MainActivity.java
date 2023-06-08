package com.seed.selvy_pen;

import android.os.Build;

import androidx.annotation.NonNull;

//import com.seed.selvy_pen.DHWR;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
//        GeneratedPluginRegistrant.registerWith(flutterEngine);
        final MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), "com.seed.selvy_pen");

        channel.setMethodCallHandler(handler);
    }

    private MethodChannel.MethodCallHandler handler = (methodCall, result) -> {
        if (methodCall.method.equals("getPlatformVersion")) {
            result.success("Android Version: " + Build.VERSION.RELEASE);
        } else if (methodCall.method.equals("create")) {
            final String filesPath = getFilesDir().getAbsolutePath();

            int status = DHWR.Create(filesPath + "/license_key/" + "license.key");
            result.success(status);
        } else {
            result.notImplemented();
        }
    };
}