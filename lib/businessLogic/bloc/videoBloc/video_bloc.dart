// ignore_for_file: unused_element

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_09/businessLogic/bloc/videoBloc/video_event.dart';
import 'package:task_09/businessLogic/bloc/videoBloc/video_state.dart';
import 'package:task_09/constants/string_resource.dart';
import 'package:task_09/utils/permission_utils.dart';
import 'package:video_player/video_player.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  List<File> videos = [];

  VideoBloc() : super(NoVideoState()) {
    on<AddVideoEvent>((event, emit) {
      videos.add(event.video);
      emit(VideoAddedState(List.from(videos)));
    });

    on<CaptureVideoEvent>((event, emit) async {
      await _pickVideo(ImageSource.camera);
      emit(VideoPickedState());
    });
    on<PickVideoEvent>((event, emit) async {
      await _pickVideo(ImageSource.gallery);
      emit(VideoPickedState());
    });

    on<PauseVideoEvent>((event, emit) async {
      _videoController?.pause();
      emit(VideoPausedState());
    });

    on<PlayVideoEvent>((event, emit) async {
      if (_videoController != null && !_videoController!.value.isPlaying) {
        playVideo();
        emit(VideoPlayingState());
      }
    });
  }

  getVideoController() {
    return _videoController;
  }
}

final FlutterFFmpeg _encoder = FlutterFFmpeg();
File? _videoFile;
VideoPlayerController? _videoController;
ImageProvider? _thumbnail;

Future<File> _getThumbnail(String videoPath) async {
  final appDir = await getTemporaryDirectory();
  final thumbnailPath =
      '${appDir.path}/${DateTime.now().toIso8601String()}.jpg';
  await _encoder.execute('-i $videoPath -vframes 1 $thumbnailPath');
  return File(thumbnailPath);
}

final permissions = PermissionUtils();

Future<void> _pickVideo(ImageSource source) async {
  if (_videoController != null) {
    _videoController?.dispose();
  }
  Future<bool> videoPermission = PermissionUtils.requestVideoPermission();
  if (await videoPermission) {
    final pickedVideo = await ImagePicker().pickVideo(source: source);
    if (pickedVideo != null) {
      final videoFile = File(pickedVideo.path);

      _videoController = VideoPlayerController.file(videoFile);

      await _videoController!.initialize();
      await _videoController!.setVolume(1.0);
      await _videoController!.seekTo(Duration.zero);
    } else {
      throw StringResources.NO_PERMISSION_GRANTED;
    }
  }
}

@override
Future<void> close() async {
  await _videoController?.dispose();
}

Future<void> _initializeVideoPlayer(File videoFile) async {
  _videoController ??= VideoPlayerController.file(videoFile)
    ..initialize().then((_) {});
}

void playVideo() async {
  if (_videoController != null) {
    if (_videoController!.value.isInitialized) {
      if (!_videoController!.value.isPlaying) {
        await _videoController?.play();
      }
    }
  }
}
