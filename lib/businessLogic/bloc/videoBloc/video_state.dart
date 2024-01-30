import 'dart:io';

abstract class VideoState {}

class NoVideoState extends VideoState {}

class VideoPlayingState extends VideoState {}

class VideoPausedState extends VideoState {}

class VideoPickedState extends VideoState {}

class VideoAddedState extends VideoState {
  final List<File> videos;

  VideoAddedState(this.videos);
}
