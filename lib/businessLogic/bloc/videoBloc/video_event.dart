import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class VideoEvent {}

class PickVideoEvent extends VideoEvent {
  BuildContext context;

  PickVideoEvent({required this.context});
}

class CaptureVideoEvent extends VideoEvent {
  BuildContext context;

  CaptureVideoEvent({required this.context});
}

class PlayVideoEvent extends VideoEvent {}

class PauseVideoEvent extends VideoEvent {}

class AddVideoEvent extends VideoEvent {
  final File video;

  AddVideoEvent(this.video);
}
