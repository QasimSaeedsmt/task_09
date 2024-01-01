import 'package:flutter/cupertino.dart';

abstract class ImageEvent {}

class PickImageEvent extends ImageEvent {
  BuildContext context;

  PickImageEvent({required this.context});
}

class CaptureImageEvent extends ImageEvent {
  BuildContext context;

  CaptureImageEvent({required this.context});
}
