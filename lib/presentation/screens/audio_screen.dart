import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:task_09/businessLogic/bloc/audioBloc/audio_bloc.dart';
import 'package:task_09/businessLogic/bloc/audioBloc/audio_event.dart';
import 'package:task_09/constants/dimension_resource.dart';
import 'package:task_09/constants/string_resource.dart';
import 'package:task_09/utils/custom_drawer.dart';

import '../../businessLogic/bloc/audioBloc/audio_state.dart';
import '../widgets/progress_bar_widget.dart';
import '../widgets/volume_widget.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  dynamic filePath;
  bool showPlayer = false;
  AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    context
        .read<AudioBloc>()
        .add(SetUpAudioPlayerEvent(player: _player, filePath: filePath));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        if (state is AudioPickedState) {
          filePath = state.filePath;
          _player = state.player;
          context.read<AudioBloc>().add(SetUpAudioPlayerEvent(
                player: _player,
                filePath: filePath,
              ));
        }
        if (state is AudioPlayerSetState) {
          _player = state.player;
        }
        if (state is AudioPickedState) {
          _player = state.player;
          showPlayer = true;
        }
        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () async {
                  context
                      .read<AudioBloc>()
                      .add(PickUpAudioEvent(context: context, player: _player));

                  context.read<AudioBloc>().add(SetUpAudioPlayerEvent(
                        player: _player,
                        filePath: await filePath,
                      ));
                },
                child: const Text(
                  StringResources.PICK_AUDIO_LABEL,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: DimensResource.D_22),
                ),
              ),
              const SizedBox(
                width: DimensResource.D_25,
              )
            ],
            title: const Text(StringResources.AUDIO_SCREEN),
          ),
          drawer: const CustomDrawer(),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: DimensResource.D_20),
            child: showPlayer
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (filePath != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: DimensResource.D_40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(StringResources.SELECTED_FILE_LABEL),
                              Text(
                                ' ${filePath.split('/').last}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: DimensResource.D_45,
                      ),
                      ProgressBarWidget(player: _player),
                      VolumeAndPlayRowWidget(player: _player)
                    ],
                  )
                : const Center(
                    child: Text(
                    StringResources.NO_PICKED_LABEL,
                    style: TextStyle(fontSize: DimensResource.D_20),
                  )),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _player.dispose();
    filePath.dispose();
  }
}
