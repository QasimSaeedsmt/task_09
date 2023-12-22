import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_09/businessLogic/bloc/audioBloc/audio_bloc.dart';
import 'package:task_09/constants/responsive_constants.dart';
import 'package:task_09/constants/string_resource.dart';
import 'package:task_09/utils/custom_drawer.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final audioBloc = AudioBloc();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(StringResources.AUDIO_SCREEN),
            actions: [
              IconButton(
                onPressed: () {
                  if (state is AudioPlayingState) {
                    context.read<AudioBloc>().add(PauseAudioEvent());
                  } else if (state is AudioPauseState) {
                    context.read<AudioBloc>().add(PlayAudioEvent());
                  } else {
                    context.read<AudioBloc>().add(PlayAudioEvent());
                  }
                },
                icon: Icon(
                  state is AudioPlayingState ? Icons.pause : Icons.play_arrow,
                ),
              ),
              SizedBox(
                width: size.width * ResponsiveConstants.S_5,
              ),
              IconButton(
                onPressed: () {
                  audioBloc.add(PickUpAudioEvent());
                },
                icon: const Icon(Icons.audiotrack),
              ),
              SizedBox(
                width: size.width * ResponsiveConstants.S_5,
              ),
            ],
          ),
          drawer: const CustomDrawer(),
        );
      },
    );
  }
}
