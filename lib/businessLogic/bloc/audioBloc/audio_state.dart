import 'package:just_audio/just_audio.dart';

abstract class AudioState {}

class AudioInitial extends AudioState {}

class AudioPickedState extends AudioState {
  dynamic filePath;
  AudioPlayer player;

  AudioPickedState({required this.filePath, required this.player});
}

class AudioPlayerSetState extends AudioState {
  AudioPlayer player;

  AudioPlayerSetState({required this.player});
}
