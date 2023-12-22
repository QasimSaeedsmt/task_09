part of 'audio_bloc.dart';

abstract class AudioState {}

class AudioStoppedState extends AudioState {}

class AudioPlayingState extends AudioState {}

class AudioPauseState extends AudioState {}

class AudioPermissionDeniedState extends AudioState {}
