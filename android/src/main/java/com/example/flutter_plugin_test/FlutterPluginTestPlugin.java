package com.example.flutter_plugin_test;

import android.app.Activity;
import android.os.Handler;
import android.os.HandlerThread;
import android.util.Log;

import androidx.annotation.NonNull;
import cn.tongdun.android.shell.FMAgent;
import cn.tongdun.android.shell.TDOption;
import cn.tongdun.android.shell.inter.FMCallback;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterPluginTestPlugin
 */
public class FlutterPluginTestPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private static final String TAG = "FlutterPluginTestPlugin";
    private MethodChannel channel;
    private Handler mHandler;
    private HandlerThread mHandlerThread;

    private Activity activity;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_plugin_test");
        channel.setMethodCallHandler(this);
        mHandlerThread = new HandlerThread("FlutterPlugin");
        mHandlerThread.start();
        mHandler = new Handler(mHandlerThread.getLooper());
        Log.d(TAG, "onAttachedToEngine: ----");
    }

    @Override
    public void onMethodCall(@NonNull final MethodCall call, @NonNull final Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("getResult")) {
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    int a = (Integer) call.argument("a");
                    int b = (Integer) call.argument("b");
                    int c = a + b;
                    result.success(c + "");
                }
            }, 3000);
        } else if (call.method.equals("getBlackbox")) {
            TDOption tdOption = new FMAgent.Builder().production(false).partner("tongdun").callback(new FMCallback() {
                @Override
                public void onEvent(String s) {
                    result.success(s);
                }
            }).build();
            FMAgent.init(activity.getApplicationContext(), tdOption);

        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        if (mHandlerThread != null)
            mHandlerThread.quitSafely();
        Log.d(TAG, "onDetachedFromEngine: ----");
    }


    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        Log.d(TAG, "onAttachedToActivity: ----");
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.d(TAG, "onDetachedFromActivityForConfigChanges: ----");
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        Log.d(TAG, "onReattachedToActivityForConfigChanges: ----");
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
        Log.d(TAG, "onDetachedFromActivity: ----");
    }
}
