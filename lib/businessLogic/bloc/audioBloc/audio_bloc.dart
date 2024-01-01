import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:task_09/businessLogic/bloc/audioBloc/audio_state.dart';

import '../../../constants/constants_resources.dart';
import '../../../utils/permission_utils.dart';
import 'audio_event.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  AudioBloc() : super(AudioInitial()) {
    on<SetUpAudioPlayerEvent>((event, emit) {
      _setUpAudioPlayer(event.player, event.filePath);
      emit(AudioPlayerSetState(player: event.player));
    });

    on<PickUpAudioEvent>((event, emit) async {
      dynamic filePath = await pickAudioFile(event.context);
      if (filePath != null) {
        emit(AudioPickedState(filePath: filePath, player: event.player));
      }
    });
  }
}

Future<void> _setUpAudioPlayer(AudioPlayer player, dynamic filePath) async {
  player.playbackEventStream
      .listen((event) {}, onError: (Object e, StackTrace stacktrace) {});
  try {
    await player.setAudioSource(AudioSource.file(filePath));
  } catch (e) {
    throw Exception(e);
  }
}

Future<String?> pickAudioFile(BuildContext context) async {
  dynamic filePath;
  Future<bool> audioPermission =
      PermissionUtils.requestAudioPermission(context);
  if (await audioPermission) {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ConstantsResources.ALLOWED_AUDIO_EXTENSIONS,
    );

    if (result != null) {
      filePath = result.files.single.path;
      return filePath;
    } else {
      return null;
    }
  } else {
    return null;
  }
}
