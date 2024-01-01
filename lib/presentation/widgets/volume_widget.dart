import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../constants/dimension_resource.dart';

class VolumeAndPlayRowWidget extends StatelessWidget {
  const VolumeAndPlayRowWidget({
    super.key,
    required AudioPlayer player,
  }) : _player = player;

  final AudioPlayer _player;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StreamBuilder(
          stream: _player.volumeStream,
          builder: (context, snapshot) {
            return Row(
              children: [
                const Icon(Icons.volume_up),
                SizedBox(
                  width: 120,
                  child: Slider(
                      value: snapshot.data ?? 1,
                      onChanged: (value) {
                        _player.setVolume(value);
                      }),
                )
              ],
            );
          },
        ),
        StreamBuilder<PlayerState>(
          stream: _player.playerStateStream,
          builder: (context, snapshot) {
            final processingState = snapshot.data?.processingState;
            final playing = snapshot.data?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                  onPressed: _player.play,
                  icon: const Icon(Icons.play_arrow),
                  iconSize: DimensResource.D_65);
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                  onPressed: _player.pause,
                  icon: const Icon(Icons.pause),
                  iconSize: DimensResource.D_65);
            } else {
              return IconButton(
                  onPressed: () => _player.seek(Duration.zero),
                  icon: const Icon(Icons.replay),
                  iconSize: DimensResource.D_65);
            }
          },
        )
      ],
    );
  }
}
