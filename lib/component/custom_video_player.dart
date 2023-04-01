import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  const CustomVideoPlayer({required this.video, super.key});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeController();
  }

// initState 는 asyn 불가능 이여서 따로 함수로 만듬
  initializeController() async {
    videoController = VideoPlayerController.file(
      File(widget.video.path),
    );
    await videoController!.initialize();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return const CircularProgressIndicator();
    }
    return VideoPlayer(
      videoController!,
    );
  }
}
