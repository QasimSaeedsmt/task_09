import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

abstract class AudioEvent {}

class SetUpAudioPlayerEvent extends AudioEvent {
  AudioPlayer player;
  dynamic filePath;

  SetUpAudioPlayerEvent({required this.player, required this.filePath});
}

class PickUpAudioEvent extends AudioEvent {
  BuildContext context;
  AudioPlayer player;

  PickUpAudioEvent({required this.context, required this.player});
}
