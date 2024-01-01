import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    super.key,
    required AudioPlayer player,
  }) : _player = player;

  final AudioPlayer _player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _player.positionStream,
      builder: (context, snapshot) {
        return ProgressBar(
          progress: snapshot.data ?? Duration.zero,
          buffered: _player.bufferedPosition,
          bufferedBarColor: Colors.black,
          total: _player.duration ?? Duration.zero,
          onSeek: (duration) {
            _player.seek(duration);
          },
        );
      },
    );
  }
}
