import 'dart:io';

abstract class ImageState {}

class NoImageState extends ImageState {}

class ImagePickedState extends ImageState {
  File? imagePath;

  ImagePickedState({this.imagePath});
}

class ImageCapturedState extends ImageState {
  File? imagePath;

  ImageCapturedState({this.imagePath});
}
