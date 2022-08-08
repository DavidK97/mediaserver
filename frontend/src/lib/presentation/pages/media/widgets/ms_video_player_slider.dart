import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MSVideoPlayerSlider extends StatefulWidget {
  final VideoPlayerController controller;

  const MSVideoPlayerSlider(this.controller, {Key? key}) : super(key: key);

  @override
  State<MSVideoPlayerSlider> createState() => _MSVideoPlayerSliderState();
}

class _MSVideoPlayerSliderState extends State<MSVideoPlayerSlider> {
  _MSVideoPlayerSliderState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  late VoidCallback listener;

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.value.isInitialized) {
      final int duration = controller.value.duration.inMilliseconds;
      int position = controller.value.position.inMilliseconds;

      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Row(
          children: [
            Text(_printDuration(controller.value.position)),
            Expanded(
              child: Slider(
                value: position.toDouble(),
                min: 0.0,
                max: duration.toDouble(),
                onChanged: (value) {
                  setState(() {
                    controller.seekTo(Duration(milliseconds: value.toInt()));
                  });
                },
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
              ),
            ),
            Text(_printDuration(controller.value.duration)),
          ],
        ),
      );
    } else {
      return Slider(
        value: 0.0,
        onChanged: (val) {},
      );
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String mins = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$mins:$seconds';
  }
}
