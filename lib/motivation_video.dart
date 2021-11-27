import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MotivationVideo extends StatefulWidget {
  MotivationVideo({this.title = 'Motivational Video'});

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _MotivationVideoState();
  }
}

class _MotivationVideoState extends State<MotivationVideo> {
  TargetPlatform? _platform;
  VideoPlayerController? _videoPlayerController1;
  VideoPlayerController? _videoPlayerController2;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController1 = VideoPlayerController.network(
        "https://firebasestorage.googleapis.com/v0/b/scheduler-bf29c.appspot.com/o/Success%20Starts%20In%20Your%20Daily%20Routine!%20-%20Morning%20Motivation.mp4?alt=media&token=a561184f-f613-450b-93ed-b167c2b9651f");
    _videoPlayerController2 = VideoPlayerController.network(
        "https://firebasestorage.googleapis.com/v0/b/scheduler-bf29c.appspot.com/o/Success%20Starts%20In%20Your%20Daily%20Routine!%20-%20Morning%20Motivation.mp4?alt=media&token=a561184f-f613-450b-93ed-b167c2b9651f");
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1!,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1?.dispose();
    _videoPlayerController2?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Container(
                // height: 400,
                child: Chewie(
                  controller: _chewieController!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
