import 'flutter_plugin_test_platform_interface.dart';

class FlutterPluginTest {
  Future<String?> getPlatformVersion() {
    return FlutterPluginTestPlatform.instance.getPlatformVersion();
  }

  Future<String?> getResult(int a, int b) {
    return FlutterPluginTestPlatform.instance.getResult(a, b);
  }
  Future<String?> getBlackbox() {
    return FlutterPluginTestPlatform.instance.getBlackbox();
  }
}
