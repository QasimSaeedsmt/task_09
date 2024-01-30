// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/string_resource.dart';

class PermissionUtils {
  static Future<bool> requestAudioPermission(BuildContext context) async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      _showAppSettingsDialog(context);
      throw StringResources.NO_PERMISSION_GRANTED;
    } else {
      final PermissionStatus newStatus = await Permission.storage.request();
      return newStatus.isGranted;
    }
  }

  static Future<bool> requestVideoPermission(BuildContext context) async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      _showAppSettingsDialog(context);
      throw StringResources.NO_PERMISSION_GRANTED;
    } else {
      final PermissionStatus newStatus = await Permission.storage.request();
      return newStatus.isGranted;
    }
  }

  static Future<bool> requestCaptureVideoPermission(
      BuildContext context) async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      _showAppSettingsDialog(context);
      throw StringResources.NO_PERMISSION_GRANTED;
    } else {
      final PermissionStatus newStatus = await Permission.camera.request();
      return newStatus.isGranted;
    }
  }

  static Future<bool> requestImagePickingPermission(
      BuildContext context) async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      _showAppSettingsDialog(context);
      throw StringResources.NO_PERMISSION_GRANTED;
    } else {
      final PermissionStatus newStatus = await Permission.storage.request();
      return newStatus.isGranted;
    }
  }

  static Future<bool> requestImageCapturingPermission(
      BuildContext context) async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      _showAppSettingsDialog(context);
      throw StringResources.NO_PERMISSION_GRANTED;
    } else {
      final PermissionStatus newStatus = await Permission.camera.request();
      return newStatus.isGranted;
    }
  }

  static void _showAppSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(StringResources.PERMISSION_REQUIRED_LABEL),
          content: const Text(StringResources.OPEN_SETTING_CONTENT),
          actions: <Widget>[
            TextButton(
              child: const Text(StringResources.OPEN_SETTING_LABEL),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(StringResources.CANCEL_LABEL),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
