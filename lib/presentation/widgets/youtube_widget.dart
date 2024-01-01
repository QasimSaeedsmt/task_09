// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// import '../../constants/constants_resources.dart';
// import '../../constants/dimension_resource.dart';
// import '../../constants/string_resource.dart';
// import '../../constants/video_constants.dart';
//
// class YouTubeWidget extends StatelessWidget {
//   const YouTubeWidget({super.key,
//     required Map<int, YoutubePlayerController> videoControllers,
//     required this.index,
//   }) : _videoControllers = videoControllers;
//
//   final Map<int, YoutubePlayerController> _videoControllers;
//   final int index;
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_videoControllers.containsKey(index)) {
//       _videoControllers[index] = YoutubePlayerController(
//         initialVideoId: YoutubePlayer.convertUrlToId(
//           VideoConstants.VIDEO_LINKS[index],
//         )!,
//         flags: const YoutubePlayerFlags(
//           autoPlay: false,
//           mute: false,
//         ),
//       );
//     }
//     return Padding(
//       padding: const EdgeInsets.all(DimensResource.D_18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           YoutubePlayer(
//             aspectRatio: ConstantsResources.HORIZONTAL_ASPECT_RATIO,
//             controller: _videoControllers[index]!,
//             showVideoProgressIndicator: true,
//             progressIndicatorColor: Colors.blueAccent,
//             progressColors: const ProgressBarColors(
//               playedColor: Colors.blue,
//               handleColor: Colors.blueAccent,
//             ),
//           ),
//           const SizedBox(height: DimensResource.D_8),
//           Text(
//             '${StringResources.VIDEO_TITLE_LABEL} ${index + ConstantsResources.INCREMENT}',
//             style: const TextStyle(
//               fontSize: DimensResource.D_18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: DimensResource.D_4),
//           Text(
//             '${StringResources.CHANNEL_NAME_LABEL} ${index + ConstantsResources.INCREMENT}',
//             style: const TextStyle(
//               fontSize: DimensResource.D_14,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: DimensResource.D_8),
//           const Divider(
//             color: Colors.red,
//             height: DimensResource.D_2,
//           ),
//         ],
//       ),
//     );
//   }
// }
