import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:better_player/better_player.dart';

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
  /// block screenshot
  Future<void> initSecureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  /// test video urls
  String videoURL = "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";
  String videoURL2 = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  String videoURL3 = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";

  /// better_player
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  void initBetterPlayer() {
    // init better controller
    BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(
      autoPlay: true,
      looping: true,
    );
    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      // videoURL,
      videoURL2,
      // videoURL3,
    );
    _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: _betterPlayerDataSource,
    );
    _betterPlayerController.play();
  }

  @override
  void initState() {
    initSecureScreen();
    initBetterPlayer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _betterPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Method Channel Test"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 42),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text("3. better_player", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),),
              Center(
                child: BetterPlayer(controller: _betterPlayerController),
              ),
            ],
          ),
        ),
      )
    );
  }
}