import 'dart:io';

abstract class VideoEvent {}

class PickVideoEvent extends VideoEvent {}

class CaptureVideoEvent extends VideoEvent {}

class PlayVideoEvent extends VideoEvent {}

class PauseVideoEvent extends VideoEvent {}

class AddVideoEvent extends VideoEvent {
  final File video;

  AddVideoEvent(this.video);
}
