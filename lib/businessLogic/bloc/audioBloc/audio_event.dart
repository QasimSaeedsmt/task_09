part of 'audio_bloc.dart';

abstract class AudioEvent {}

class PickUpAudioEvent extends AudioEvent {}

class PlayAudioEvent extends AudioEvent {}

class PauseAudioEvent extends AudioEvent {}
