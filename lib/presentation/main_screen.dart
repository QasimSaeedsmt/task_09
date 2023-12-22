// ignore_for_file: library_private_types_in_public_api
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_09/constants/constants_resources.dart';
import 'package:task_09/constants/dimension_resource.dart';
import 'package:task_09/constants/icon_resources.dart';
import 'package:task_09/constants/responsive_constants.dart';
import 'package:task_09/constants/string_resource.dart';
import 'package:task_09/utils/custom_drawer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../businessLogic/bloc/mainScreenBloc/main_screen_bloc.dart';
import '../businessLogic/bloc/mainScreenBloc/main_screen_event.dart';
import '../businessLogic/bloc/mainScreenBloc/main_screen_state.dart';
import '../businessLogic/bloc/videoBloc/video_bloc.dart';
import '../constants/video_constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _videoBloc = VideoBloc();
  late ScrollController _scrollController;
  final Map<int, YoutubePlayerController> _videoControllers = {};
  final Map<int, VideoPlayerController> _selectedVideoControllers = {};
  List<File> selectedVideos = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    for (int i = ConstantsResources.ZERO;
        i < VideoConstants.VIDEO_LINKS.length;
        i++) {
      _videoControllers[i] = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(
          VideoConstants.VIDEO_LINKS[i],
        )!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }

    for (int i = ConstantsResources.ZERO; i < selectedVideos.length; i++) {
      _selectedVideoControllers[i] =
          VideoPlayerController.file(selectedVideos[i]);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    for (var controller in _selectedVideoControllers.values) {
      controller.dispose();
    }
    _videoBloc.close();

    super.dispose();
  }

  void _scrollListener() {
    int? inViewIndex;
    for (int index = ConstantsResources.INITIAL_INDEX;
        index < VideoConstants.VIDEO_LINKS.length;
        index++) {
      if (_isVideoInView(index)) {
        inViewIndex = index;
        break;
      }
    }
    if (inViewIndex != null) {
      context.read<MainScreenBloc>().add(UpdateSelectedIndex(inViewIndex));
      _startVideo(inViewIndex);
    }
    for (int index = ConstantsResources.INITIAL_INDEX;
        index < VideoConstants.VIDEO_LINKS.length;
        index++) {
      if (index != inViewIndex) {
        _pauseVideo(index);
      }
    }
  }

  bool _isVideoInView(int index) {
    final double videoTop = index *
        (ConstantsResources.VERTICAL_ASPECT_RATIO *
                MediaQuery.of(context).size.width *
                ResponsiveConstants.S_90 +
            DimensResource.D_8);
    final double videoBottom = videoTop +
        ConstantsResources.VERTICAL_ASPECT_RATIO *
            MediaQuery.of(context).size.width *
            ResponsiveConstants.S_90;
    final double scrollPosition = _scrollController.position.pixels;
    final double screenHeight = MediaQuery.of(context).size.height;
    return videoBottom > scrollPosition &&
        videoTop < scrollPosition + screenHeight;
  }

  void _startVideo(int index) {
    final controller = _videoControllers[index];
    if (controller != null && !controller.value.isPlaying) {
      controller.play();
    }
  }

  void _pauseVideo(int index) {
    final controller = _videoControllers[index];
    if (controller != null && controller.value.isPlaying) {
      controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoBloc = BlocProvider.of<VideoBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SvgPicture.asset(
              IconResources.YOUTUBE_ICON,
              width: DimensResource.D_25,
              height: DimensResource.D_25,
            ),
            const SizedBox(
              width: DimensResource.D_10,
            ),
            const Text(
              StringResources.YOUTUBE_LABEL,
              style: TextStyle(fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
      drawer: const CustomDrawer(),
      body: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
          selectedVideos = BlocProvider.of<VideoBloc>(context).videos;

          return ListView.builder(
            controller: _scrollController,
            itemCount: VideoConstants.VIDEO_LINKS.length +
                selectedVideos.length +
                videoBloc.videos.length,
            itemBuilder: (context, index) {
              if (index < VideoConstants.VIDEO_LINKS.length) {
                return buildYoutubeVideoItem(index);
              } else if (index <
                  VideoConstants.VIDEO_LINKS.length + selectedVideos.length) {
                final selectedVideoIndex =
                    index - VideoConstants.VIDEO_LINKS.length;
                return buildSelectedVideoItem(selectedVideoIndex);
              } else {
                final newVideoIndex = index -
                    VideoConstants.VIDEO_LINKS.length -
                    selectedVideos.length;
                return buildNewVideoItem(
                  newVideoIndex,
                  videoBloc.videos[newVideoIndex].path,
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget buildYoutubeVideoItem(int index) {
    if (!_videoControllers.containsKey(index)) {
      _videoControllers[index] = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(
          VideoConstants.VIDEO_LINKS[index],
        )!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(DimensResource.D_18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          YoutubePlayer(
            aspectRatio: ConstantsResources.HORIZONTAL_ASPECT_RATIO,
            controller: _videoControllers[index]!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            progressColors: const ProgressBarColors(
              playedColor: Colors.blue,
              handleColor: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: DimensResource.D_8),
          Text(
            '${StringResources.VIDEO_TITLE_LABEL} ${index + ConstantsResources.INCREMENT}',
            style: const TextStyle(
              fontSize: DimensResource.D_18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DimensResource.D_4),
          Text(
            '${StringResources.CHANNEL_NAME_LABEL} ${index + ConstantsResources.INCREMENT}',
            style: const TextStyle(
              fontSize: DimensResource.D_14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: DimensResource.D_8),
          const Divider(
            color: Colors.red,
            height: DimensResource.D_2,
          ),
        ],
      ),
    );
  }

  Widget buildSelectedVideoItem(int index) {
    final selectedVideoController = _selectedVideoControllers[index];

    return Padding(
      padding: const EdgeInsets.all(DimensResource.D_18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          selectedVideoController != null
              ? AspectRatio(
                  aspectRatio: selectedVideoController.value.aspectRatio,
                  child: VideoPlayer(selectedVideoController),
                )
              : Container(),
          const SizedBox(height: DimensResource.D_8),
          const Divider(
            color: Colors.grey,
            height: DimensResource.D_2,
          ),
        ],
      ),
    );
  }

  Widget buildNewVideoItem(int index, String newVideo) {
    final videoController = VideoPlayerController.file(File(newVideo));
    _selectedVideoControllers[index] = videoController;
    return Padding(
      padding: const EdgeInsets.all(DimensResource.D_18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: VideoPlayer(videoController),
          ),
          const SizedBox(height: DimensResource.D_8),
          const Divider(
            color: Colors.grey,
            height: DimensResource.D_2,
          ),
        ],
      ),
    );
  }
}
