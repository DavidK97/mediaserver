import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../../logic/cubits/menu/menu_cubit.dart';
import 'ms_video_player_slider.dart';

class MSVideoPlayer extends StatefulWidget {
  final String url;

  const MSVideoPlayer({required this.url, Key? key}) : super(key: key);

  @override
  State<MSVideoPlayer> createState() => _MSVideoPlayerState();
}

class _MSVideoPlayerState extends State<MSVideoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, bool>(
      builder: (context, state) {
        return Stack(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Visibility(
              visible: state,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      (_controller.value.isPlaying)
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  icon: Icon(
                    (_controller.value.isPlaying)
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  iconSize: 50,
                ),
              ),
            ),
            Visibility(
              visible: state,
              child: Positioned(
                bottom: 15,
                right: 0,
                left: 0,
                child: MSVideoPlayerSlider(_controller),
              ),
            ),
          ],
        );
      },
    );
  }
}
