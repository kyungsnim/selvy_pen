// import 'package:better_player/src/video_player/video_player.dart'; // as better_video_player;
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
// import 'package:video_player/video_player.dart';
import 'package:better_player/better_player.dart';
// import 'package:chewie/chewie.dart';

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
  /// method channel
  // static const MethodChannel _channel = MethodChannel('com.seed.selvy_pen');
  // String _platformVersion = 'Unknown';
  // int status = 9999;
  // Future<String> getPlatformVersion() async {
  //   final String version = await _channel.invokeMethod('getPlatformVersion');
  //   return version;
  // }
  // Future create() async {
  //   final status = await _channel.invokeMethod('create');
  //   return status;
  // }

  /// block screenshot
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  /// test video urls
  String videoURL = "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";
  String videoURL2 = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  String videoURL3 = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";

  /// video_player
  // late VideoPlayerController _videoPlayerController;
  // void seekByDuration(Duration duration) {
  //   _videoPlayerController.pause();
  //   _videoPlayerController.seekTo(duration);
  //   _videoPlayerController.play();
  // }

  /// chewie, better
  // late ChewieController _chewieController;
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  // void initChewie() {
  //   // init chewie
  //   _chewieController = ChewieController(
  //     autoPlay: true,
  //     looping: true,
  //     videoPlayerController: _videoPlayerController,
  //     customControls: const CupertinoControls(backgroundColor: Colors.black12, iconColor: Colors.white,),
  //     // customControls: const MaterialControls(),
  //   );
  // }
  void initBetter() {
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
    secureScreen();

    // _videoPlayerController = VideoPlayerController.network(videoURL)
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {
    //       initChewie();
    //       initBetter();
    //       _videoPlayerController.play();
    //       _betterPlayerController.play();
    //     });
    //   });

    initBetter();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _videoPlayerController.dispose();
    // _chewieController.dispose();
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
          padding: EdgeInsets.symmetric(vertical: 42),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 1. video_player
              // const Text("1. video_player", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),),
              // Center(
              //   child: _videoPlayerController.value.isInitialized
              //       ? AspectRatio(
              //         aspectRatio: _videoPlayerController.value.aspectRatio,
              //         child: VideoPlayer(_videoPlayerController),
              //       )
              //       : Container(),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text("seekTo :  ", style: TextStyle(fontSize: 20),),
              //     TextButton(
              //       child: const Text("0:30", style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline,),),
              //       onPressed: () {
              //         seekByDuration(const Duration(seconds: 30));
              //       },
              //     ),
              //     TextButton(
              //       child: const Text("1:00", style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline,),),
              //       onPressed: () {
              //         seekByDuration(const Duration(minutes: 1));
              //       },
              //     ),
              //     TextButton(
              //       child: const Text("1:30", style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline,),),
              //       onPressed: () {
              //         seekByDuration(const Duration(minutes: 1, seconds: 30));
              //       },
              //     ),
              //     TextButton(
              //       child: const Text("2:00", style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline,),),
              //       onPressed: () {
              //         seekByDuration(const Duration(minutes: 2));
              //       },
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 80,),
              // 2. chewie
              // const Text("2. chewie", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange),),
              // Center(
              //   child: _videoPlayerController.value.isInitialized
              //       ? AspectRatio(
              //         aspectRatio: _videoPlayerController.value.aspectRatio,
              //         child: Chewie(
              //           controller: _chewieController,
              //         ),
              //       )
              //       : Container(),
              // ),
              // const SizedBox(height: 80,),
              // 3. better_player
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