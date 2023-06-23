import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CustomWorldSubsectionShowVideo extends StatelessWidget {
  final String videoURL;
  final String videoName;
  const CustomWorldSubsectionShowVideo(
      {Key? key, required this.videoURL, required this.videoName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;

    final _controller = YoutubePlayerController.fromVideoId(
      videoId: this.videoURL,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(
            this.videoName,
            textAlign: TextAlign.justify,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                  width: width,
                  height: height - 100,
                  child: YoutubePlayer(
                    controller: _controller,
                    aspectRatio: 16 / 9,
                  )),
            ),
          ],
        ));
  }
}
