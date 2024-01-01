// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_09/constants/dimension_resource.dart';
import 'package:task_09/constants/icon_resources.dart';
import 'package:task_09/constants/string_resource.dart';
import 'package:task_09/constants/video_constants.dart';
import 'package:task_09/utils/custom_drawer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../constants/constants_resources.dart';
import '../../constants/responsive_constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final ScrollController _scrollController;
  final Map<int, dynamic> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    for (int i = ConstantsResources.ZERO;
        i < VideoResources.VIDEO_LINKS.length;
        i++) {
      final videoId = YoutubePlayer.convertUrlToId(
        VideoResources.VIDEO_LINKS[i],
      );
      if (videoId != null) {
        _videoControllers[i] = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      } else {
        _videoControllers[i] = VideoPlayerController.networkUrl(
            Uri.parse(VideoResources.VIDEO_LINKS[i]))
          ..initialize().then((_) {
            setState(() {});
          });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    for (var controller in _videoControllers.values) {
      if (controller is YoutubePlayerController) {
        controller.dispose();
      } else if (controller is VideoPlayerController) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _scrollListener() {
    int? inViewIndex;
    for (int index = ConstantsResources.ZERO;
        index < VideoResources.VIDEO_LINKS.length;
        index++) {
      if (_isVideoInView(index)) {
        inViewIndex = index;
        break;
      }
    }
    if (inViewIndex != null) {
      _startVideo(inViewIndex);
    }
    for (int index = 0; index < VideoResources.VIDEO_LINKS.length; index++) {
      if (index != inViewIndex) {
        _pauseVideo(index);
      }
    }
  }

  bool _isVideoInView(int index) {
    if (!_scrollController.hasClients) {
      return false;
    }

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final double offsetToTop = _scrollController.offset;
    final double offsetToBottom = offsetToTop + size.height;

    final double videoTop = index *
        (ConstantsResources.VERTICAL_ASPECT_RATIO *
                MediaQuery.of(context).size.width *
                ResponsiveConstants.S_90 +
            DimensResource.D_8);
    final double videoBottom = videoTop +
        ConstantsResources.VERTICAL_ASPECT_RATIO *
            MediaQuery.of(context).size.width *
            ResponsiveConstants.S_90;

    return (videoTop < offsetToBottom && videoBottom > offsetToTop);
  }

  void _startVideo(int index) {
    final controller = _videoControllers[index];
    if (controller != null && !controller.value.isPlaying) {
      if (controller is YoutubePlayerController) {
        controller.play();
      } else if (controller is VideoPlayerController) {
        controller.play();
      }
    }
  }

  void _pauseVideo(int index) {
    final controller = _videoControllers[index];
    if (controller != null && controller.value.isPlaying) {
      if (controller is YoutubePlayerController) {
        controller.pause();
      } else if (controller is VideoPlayerController) {
        controller.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SizedBox(
                height: DimensResource.D_40,
                width: DimensResource.D_45,
                child: SvgPicture.asset(IconResources.YOUTUBE_ICON)),
            const SizedBox(
              width: DimensResource.D_10,
            ),
            const Text(
              StringResources.YOUTUBE_LABEL,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: VideoResources.VIDEO_LINKS.length,
        itemBuilder: (context, index) {
          return buildVideoItem(index);
        },
      ),
    );
  }

  Widget buildVideoItem(int index) {
    final controller = _videoControllers[index];
    if (controller == null) {
      return Container();
    }

    if (controller is YoutubePlayerController) {
      return buildYoutubePlayerItem(controller, index);
    } else if (controller is VideoPlayerController) {
      return buildVideoPlayerItem(controller, index);
    }

    return Container();
  }

  Widget buildYoutubePlayerItem(YoutubePlayerController controller, int index) {
    return Padding(
      padding: const EdgeInsets.all(DimensResource.D_8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            progressColors: const ProgressBarColors(
              playedColor: Colors.blue,
              handleColor: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: DimensResource.D_8),
          Text(
            '${StringResources.VIDEO_LABEL} $index',
            style: const TextStyle(
              fontSize: DimensResource.D_18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DimensResource.D_4),
          const Text(
            StringResources.CHANNEL_LABEL,
            style: TextStyle(
              fontSize: DimensResource.D_14,
              color: Colors.grey,
            ),
          ),
          const Divider(
            color: Colors.red,
            height: DimensResource.D_2,
          ),
        ],
      ),
    );
  }

  Widget buildVideoPlayerItem(VideoPlayerController controller, int index) {
    int videoIndex = index + 1;
    return Padding(
      padding: const EdgeInsets.all(DimensResource.D_8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: ConstantsResources.HORIZONTAL_ASPECT_RATIO,
            child: VideoPlayer(controller),
          ),
          const SizedBox(height: DimensResource.D_8),
          Text(
            'Video $videoIndex',
            style: const TextStyle(
              fontSize: DimensResource.D_18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DimensResource.D_4),
          const Text(
            'Channel Name',
            style: TextStyle(
              fontSize: DimensResource.D_14,
              color: Colors.grey,
            ),
          ),
          const Divider(
            color: Colors.red,
            height: 2.0,
          ),
        ],
      ),
    );
  }
}
