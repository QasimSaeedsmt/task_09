import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_09/constants/dimension_resource.dart';
import 'package:task_09/utils/custom_drawer.dart';
import 'package:video_player/video_player.dart';

import '../../businessLogic/bloc/videoBloc/video_bloc.dart';
import '../../businessLogic/bloc/videoBloc/video_event.dart';
import '../../businessLogic/bloc/videoBloc/video_state.dart';
import '../../constants/responsive_constants.dart';
import '../../constants/string_resource.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final _videoBloc = VideoBloc();

  @override
  void initState() {
    super.initState();
    context.read<VideoBloc>().getVideoController();
  }

  void onVideoPicked(File videoFile) {
    _videoBloc.add(AddVideoEvent(videoFile));
  }

  void onVideoCaptured(File videoFile) {
    _videoBloc.add(AddVideoEvent(videoFile));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        final videoController = context.read<VideoBloc>().getVideoController();
        final videoBloc = context.read<VideoBloc>();
        return Scaffold(
          appBar: AppBar(
            title: const Text(StringResources.VIDEO_SCREEN),
            actions: [
              SizedBox(width: size.height * ResponsiveConstants.S_2),
              IconButton(
                onPressed: () {
                  context
                      .read<VideoBloc>()
                      .add(CaptureVideoEvent(context: context));
                },
                icon: const Icon(CupertinoIcons.video_camera),
              ),
              SizedBox(width: size.height * ResponsiveConstants.S_6),
              IconButton(
                onPressed: () {
                  context
                      .read<VideoBloc>()
                      .add(PickVideoEvent(context: context));
                },
                icon: const Icon(Icons.photo_album_outlined),
              ),
              SizedBox(width: size.height * ResponsiveConstants.S_4),
            ],
          ),
          drawer: const CustomDrawer(),
          body: videoController != null
              ? FutureBuilder<void>(
                  future: videoController.initialize(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height *
                                  ResponsiveConstants.S_70,
                            ),
                            child: VideoPlayer(videoController),
                          ),
                          videoBloc.state is NoVideoState
                              ? const SizedBox()
                              : IconButton(
                                  onPressed: () {
                                    if (state is VideoPlayingState) {
                                      context
                                          .read<VideoBloc>()
                                          .add(PauseVideoEvent());
                                    } else if (state is VideoPausedState) {
                                      context
                                          .read<VideoBloc>()
                                          .add(PlayVideoEvent());
                                    } else {
                                      context
                                          .read<VideoBloc>()
                                          .add(PlayVideoEvent());
                                    }
                                  },
                                  icon: Icon(
                                    size: DimensResource.D_40,
                                    videoBloc.state is VideoPlayingState
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                )
              : const Center(
                  child: Text(StringResources.EMPTY_STRING),
                ),
        );
      },
    );
  }
}
