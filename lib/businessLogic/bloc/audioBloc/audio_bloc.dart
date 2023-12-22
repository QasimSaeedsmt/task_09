import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:task_09/constants/string_resource.dart';
import 'package:task_09/utils/permission_utils.dart';

import '../../../constants/constants_resources.dart';

part 'audio_event.dart';
part 'audio_state.dart';

dynamic filePath;
final audioPlayer = AudioPlayer();

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  AudioBloc() : super(AudioStoppedState()) {
    on<PickUpAudioEvent>((event, emit) async {
      Future<bool> audioPermission = PermissionUtils.requestAudioPermission();
      if (await audioPermission) {
        pickAudioFile();
        emit(AudioStoppedState());
      } else {
        throw StringResources.NO_PERMISSION_GRANTED;
      }
    });

    on<PauseAudioEvent>((event, emit) async {
      await audioPlayer.pause();
      emit(AudioPauseState());
    });

    on<PlayAudioEvent>((event, emit) async {
      await _playPickedAudio();
      emit(AudioPlayingState());
    });
  }
}

Future<String?> pickAudioFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ConstantsResources.ALLOWED_AUDIO_EXTENSIONS,
  );

  if (result != null) {
    filePath = result.files.single.path;
  }

  return filePath;
}

_playPickedAudio() async {
  if (filePath != null) {
    var source = DeviceFileSource(filePath);
    await audioPlayer.play(source);
    return;
  }

  if (kDebugMode) {
    print(StringResources.FAILED_TO_PLAY_AUDIO);
  }
}
