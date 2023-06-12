import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selvy_pen/pen_input.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:video_player/video_player.dart';

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
  late VideoPlayerController _videoPlayerController;
  String videoURL = "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";

  static const MethodChannel _channel = MethodChannel('com.seed.selvy_pen');

  String _platformVersion = 'Unknown';
  int status = 9999;

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<String> getPlatformVersion() async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future create() async {
    final status = await _channel.invokeMethod('create');
    return status;
  }

  @override
  void initState() {
    secureScreen();
    _videoPlayerController = VideoPlayerController.network(videoURL)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _videoPlayerController.play();
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  void seekByDuration(Duration duration) {
    _videoPlayerController.pause();
    _videoPlayerController.seekTo(duration);
    _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Method Channel Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Center(
              child: _videoPlayerController.value.isInitialized
                  ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                  )
                  : Container(),
            ),
            Text("seekTo..... ", style: TextStyle(fontSize: 20),),
            TextButton(
              child: Text("0:30", style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline,),),
              onPressed: () {
                seekByDuration(const Duration(seconds: 30));
              },
            ),
            TextButton(
              child: Text("1:00", style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline,),),
              onPressed: () {
                seekByDuration(const Duration(minutes: 1));
              },
            ),
            TextButton(
              child: Text("1:30", style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline,),),
              onPressed: () {
                seekByDuration(const Duration(minutes: 1, seconds: 30));
              },
            ),
            TextButton(
              child: Text("2:00", style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline,),),
              onPressed: () {
                seekByDuration(const Duration(minutes: 2));
              },
            ),
          ],
        ),
      ),
    );
  }
}