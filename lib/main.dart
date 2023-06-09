import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selvy_pen/pen_input.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Method Channel Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const MethodChannel _channel =
  MethodChannel('com.seed.selvy_pen');

  String _platformVersion = 'Unknown';
  int status = 9999;
  Future<String> getPlatformVersion() async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future create() async {
    final status = await _channel.invokeMethod('create');
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Method Channel Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: Text("Get Platform Version"),
              onPressed: () async {
                String result = await getPlatformVersion();
                setState(() {
                  _platformVersion = result;
                });
              },
            ),
            TextButton(
              child: Text("create"),
              onPressed: () async {
                int tmp = await create();
                setState(() {
                  status = tmp;
                });
              },
            ),
            Text(_platformVersion),
            Text('status : $status'),
            PenInput(
              answerCount: 1,
              onAnswerChanged: (newValue){}, //(newValue) => saveShortAnswer(newValue),
              memberAnswer: "",
            ),
          ],
        ),
      ),
    );
  }
}