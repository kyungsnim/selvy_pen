package com.seed.selvy_pen;
import com.selvy.spmath.DHWR;

import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;


import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        final MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), "com.seed.selvy_pen");

        channel.setMethodCallHandler(handler);
    }

    private MethodChannel.MethodCallHandler handler = (methodCall, result) -> {
        if (methodCall.method.equals("getPlatformVersion")) {
            result.success("Android Version: " + Build.VERSION.RELEASE);
        } else if (methodCall.method.equals("create")) {
            final String filesPath = getApplicationContext().getFilesDir().getAbsolutePath();

            Log.d("filePath", filesPath);
            int status = DHWR.Create(filesPath + "/" + "license.key");
            DHWR.SetExternalResourcePath(filesPath.toCharArray());
            result.success(status);
        } else {
            result.notImplemented();
        }
    };
}