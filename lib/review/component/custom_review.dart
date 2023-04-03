import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomReview extends StatefulWidget {
  XFile video;
  CustomReview({required this.video, super.key});

  @override
  State<CustomReview> createState() => _CustomReviewState();
}

class _CustomReviewState extends State<CustomReview> {
  VideoPlayerController? videoController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeController();
  }

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
      return const CircularProgressIndicator(
        color: Colors.orange,
      );
    }
    return Center(
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(videoController!),
            _Controlls(
              isPlaying: videoController!.value.isPlaying,
              onPlayPressed: onPlayPressed,
              onReversePressed: onReversePressed,
              onforwardPressed: onforwardPressed,
            ),
            Positioned(
              right: 2,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.photo_camera),
                iconSize: 30.0,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  void onReversePressed() {
    final currentPositon = videoController!.value.position;
    Duration position = const Duration();
    if (currentPositon.inSeconds > 2) {
      position = currentPositon - const Duration(seconds: 2);
    }

    // 어떤 위치로 실행할지 정할 수 있음

    videoController!.seekTo(position);
  }

  void onPlayPressed() {
    setState(() {
      if (videoController!.value.isPlaying) {
        videoController!.pause();
      } else {
        videoController!.play();
      }
    });
  }

  void onforwardPressed() {
    final maxPosition = videoController!.value.duration;
    final currentPositon = videoController!.value.position;
    Duration position = maxPosition;

    if ((maxPosition - const Duration(seconds: 2)).inSeconds >
        currentPositon.inSeconds) {
      position = currentPositon + const Duration(seconds: 2);
    }

    // 어떤 위치로 실행할지 정할 수 있음

    videoController!.seekTo(position);
  }
}

class _Controlls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onforwardPressed;
  final VoidCallback onReversePressed;
  final bool isPlaying;

  const _Controlls({
    required this.onPlayPressed,
    required this.onReversePressed,
    required this.onforwardPressed,
    required this.isPlaying,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          renderIconButton(
            iconData: Icons.rotate_left,
            onPressed: onReversePressed,
          ),
          renderIconButton(
            iconData: isPlaying ? Icons.pause : Icons.play_arrow,
            onPressed: onPlayPressed,
          ),
          renderIconButton(
            iconData: Icons.rotate_right,
            onPressed: onforwardPressed,
          ),
        ],
      ),
    );
  }

  Widget renderIconButton(
      {required IconData iconData, required VoidCallback onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(iconData),
      iconSize: 30.0,
      color: Colors.white,
    );
  }
}
