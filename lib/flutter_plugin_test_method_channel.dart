import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_plugin_test_platform_interface.dart';

/// An implementation of [FlutterPluginTestPlatform] that uses method channels.
class MethodChannelFlutterPluginTest extends FlutterPluginTestPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_plugin_test');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<String> getResult(int a, int b) async {
    Map<String, dynamic> map = {"a": a, "b": b};
    String result = await methodChannel.invokeMethod("getResult", map);
    return result;
  }

  Future<String> getBlackbox() async {
    String result = await methodChannel.invokeMethod("getBlackbox");
    return result;
  }
}
