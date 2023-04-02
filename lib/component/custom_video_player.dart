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

    // 원래 비율대로 설정할려면 AspectRatio
    return Center(
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(
              videoController!,
            ),
            _Controls(
              onReversePressed: onReversePressed,
              onPlayPressed: onPlayPressed,
              isPlay: videoController!.value.isPlaying,
              onForwardPressed: onForwardPressed,
            ),
            // stack 쓸때 많이 씀 위치지정
            Positioned(
              right: 1,
              child: IconButton(
                onPressed: () {},
                color: Colors.white,
                iconSize: 30.0,
                icon: const Icon(Icons.photo_camera_back),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onReversePressed() {
    final currentPosition = videoController!.value.position;

    Duration position = const Duration(); // 0초

    if (currentPosition.inSeconds > 2) {
      position = currentPosition - const Duration(seconds: 2);
    }

    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    // 이미 실행중이면 중지
    // 실행중이면 중지

    setState(() {
      if (videoController!.value.isPlaying) {
        videoController!.pause();
      } else {
        videoController!.play();
      }
    });
  }

  void onForwardPressed() {
    // 전체 총길이
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;
    Duration position = maxPosition;
    if ((maxPosition - const Duration(seconds: 2)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + const Duration(seconds: 2);
    }

    videoController!.seekTo(position);
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversePressed;
  final VoidCallback onForwardPressed;
  final bool isPlay;

  const _Controls({
    required this.onPlayPressed,
    required this.onReversePressed,
    required this.onForwardPressed,
    required this.isPlay,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          renderIconButton(
            onPressed: onReversePressed,
            iconData: Icons.rotate_left,
          ),
          renderIconButton(
            onPressed: onPlayPressed,
            iconData: isPlay ? Icons.pause : Icons.play_arrow,
          ),
          renderIconButton(
            onPressed: onForwardPressed,
            iconData: Icons.rotate_right,
          )
        ],
      ),
    );
  }

  Widget renderIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
  }) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.white,
      icon: Icon(iconData),
    );
  }
}
