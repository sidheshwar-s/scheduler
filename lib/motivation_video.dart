import 'package:chewie/chewie.dart';
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
  VideoPlayerController? _videoPlayerController1;
  VideoPlayerController? _videoPlayerController2;
  ChewieController? _chewieController;

  List<String> videos = [
    "https://firebasestorage.googleapis.com/v0/b/scheduler-bf29c.appspot.com/o/One%20of%20the%20Greatest%20Speeches%20Ever%20_%20Steve%20Jobs.mp4?alt=media&token=57f94fa2-1513-4977-aa34-b2d20465846e",
    "https://firebasestorage.googleapis.com/v0/b/scheduler-bf29c.appspot.com/o/Success%20Starts%20In%20Your%20Daily%20Routine!%20-%20Morning%20Motivation.mp4?alt=media&token=a561184f-f613-450b-93ed-b167c2b9651f",
    "https://firebasestorage.googleapis.com/v0/b/scheduler-bf29c.appspot.com/o/yt1s.com%20-%20Arnold%20Schwarzenegger%20Leaves%20the%20Audience%20SPEECHLESS%20%20One%20of%20the%20Best%20Motivational%20Speeches%20Ever.mp4?alt=media&token=2eafe80c-e5a4-4804-b8df-a853a0991f30",
    "https://firebasestorage.googleapis.com/v0/b/scheduler-bf29c.appspot.com/o/yt1s.com%20-%20IT%20WILL%20GIVE%20YOU%20GOOSEBUMPS%20%20Elon%20musk%20Motivational%20video.mp4.webm?alt=media&token=8c905594-0527-4e7f-aa9e-7cd3760f36b6",
    "https://firebasestorage.googleapis.com/v0/b/scheduler-bf29c.appspot.com/o/yt1s.com%20-%20The%20speech%20which%20made%20Jack%20Ma%20famous%20%20One%20of%20The%20Most%20Eye%20Opening%20Motivational%20Videos%20Ever.mp4.webm?alt=media&token=890683cf-cf79-4405-8750-a9c67b38acde",
  ];
  bool isLoading = true;

  String? chosenVideo;

  void chooseRandomVideo() async {
    setState(() {
      chosenVideo = (videos..shuffle()).first;
    });
  }

  @override
  void initState() {
    super.initState();
    chooseRandomVideo();
    _videoPlayerController1 =
        VideoPlayerController.network(chosenVideo ?? videos.first);
    _videoPlayerController2 =
        VideoPlayerController.network(chosenVideo ?? videos.first);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1!,
      aspectRatio: 3 / 2,
      looping: true,
      autoPlay: true,
    );
    setState(() {
      isLoading = false;
    });
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
        backgroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Container(
                      height: 400,
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
