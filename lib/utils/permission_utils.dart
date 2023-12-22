import 'package:permission_handler/permission_handler.dart';
import 'package:task_09/constants/string_resource.dart';

class PermissionUtils {
  static Future<bool> requestAudioPermission() async {
    PermissionStatus status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      throw StringResources.NO_PERMISSION_GRANTED;
    } else {
      final PermissionStatus newStatus = await Permission.microphone.request();
      return newStatus.isGranted;
    }
  }

  static Future<bool> requestVideoPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      throw StringResources.NO_PERMISSION_GRANTED;
    } else {
      final PermissionStatus newStatus = await Permission.camera.request();
      return newStatus.isGranted;
    }
  }

  static Future<bool> requestImagePermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      throw StringResources.NO_PERMISSION_GRANTED;
    } else {
      final PermissionStatus newStatus = await Permission.storage.request();
      return newStatus.isGranted;
    }
  }
}
