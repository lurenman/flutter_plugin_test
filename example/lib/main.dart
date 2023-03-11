import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_test/flutter_plugin_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _TAG = "MyAppState";
  String _platformVersion = 'Unknown';
  String _mResult = 'Unknown';
  final _flutterPluginTestPlugin = FlutterPluginTest();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterPluginTestPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Running on: $_platformVersion\n'),
            Container(
              margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () async {
                    try {
                      // var result = await _flutterPluginTestPlugin.getResult(1, 2);
                      var result = await _flutterPluginTestPlugin.getBlackbox();
                      setState(() {
                        if (result != null) {
                          _mResult = result;
                        }
                      });
                      print(_TAG + " result: ${result}");
                    } on PlatformException catch (err) {
                      // Handle
                      print(_TAG + " Handle err: ${err.toString()}");
                    } catch (err) {
                      // other types of Exceptions
                      print(_TAG +
                          " other types of Exceptions: ${err.toString()}");
                    }
                  },
                  child: Text(
                    "MethodChannel",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text("the result : ${_mResult}"),
            )
          ],
        ),
      ),
    );
  }
}
