import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_09/businessLogic/bloc/imageBloc/image_event.dart';
import 'package:task_09/businessLogic/bloc/imageBloc/image_state.dart';
import 'package:task_09/constants/string_resource.dart';
import 'package:task_09/utils/permission_utils.dart';

File? _imageFile;

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(NoImageState()) {
    on<CaptureImageEvent>((event, emit) async {
      final imagePath = await _captureImage(ImageSource.camera, event.context);
      emit(ImageCapturedState(imagePath: imagePath));
    });
    on<PickImageEvent>((event, emit) async {
      final imagePath = await _pickImage(ImageSource.gallery, event.context);
      emit(ImagePickedState(imagePath: imagePath));
    });
  }

  File? getImageFile() {
    return _imageFile;
  }
}

final permissions = PermissionUtils();

Future<File?> _pickImage(ImageSource source, BuildContext context) async {
  Future<bool> imagePermission =
      PermissionUtils.requestImagePickingPermission(context);
  if (await imagePermission) {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  } else {
    throw StringResources.NO_PERMISSION_GRANTED;
  }
}

Future<File?> _captureImage(ImageSource source, BuildContext context) async {
  Future<bool> imagePermission =
      PermissionUtils.requestImageCapturingPermission(context);
  if (await imagePermission) {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  } else {
    throw StringResources.NO_PERMISSION_GRANTED;
  }
}
