import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewiePage extends StatefulWidget {
  const ChewiePage({Key? key}) : super(key: key);

  @override
  State<ChewiePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChewiePage> {
  String url =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

  late final VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  final _progressClors = ChewieProgressColors(
    playedColor: Colors.red,
    handleColor: Colors.red,
    backgroundColor: Colors.grey,
    bufferedColor: Colors.blue,
  );

  @override
  initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(Uri.encodeFull(url));
  }

  _videoInitializer() async {
    await _videoPlayerController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _videoInitializer(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: 9 / 16,
            autoPlay: true,
            looping: true,
            cupertinoProgressColors: _progressClors,
            materialProgressColors: _progressClors,
            autoInitialize: true,
            allowFullScreen: true,
            placeholder: Container(
              color: Colors.black,
            ),
          );
          return Scaffold(
            appBar: AppBar(
              title: const Text("ChewiePage"),
            ),
            body: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Chewie(controller: _chewieController),
                ),
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
