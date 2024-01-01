import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_09/constants/dimension_resource.dart';
import 'package:task_09/constants/responsive_constants.dart';
import 'package:task_09/constants/string_resource.dart';
import 'package:task_09/extensions/build_context_extension.dart';
import 'package:task_09/presentation/screens/main_screen.dart';
import 'package:task_09/presentation/screens/video_screen.dart';
import 'package:task_09/utils/drawer_widget.dart';

import '../constants/icon_resources.dart';
import '../presentation/screens/audio_screen.dart';
import '../presentation/screens/image_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Drawer(
        child: Column(
      children: [
        SizedBox(
          height: size.height * ResponsiveConstants.S_4,
        ),
        ListTile(
          onTap: () {
            context.pushAndRemoveAll(const MainScreen());
          },
          leading: SvgPicture.asset(
            IconResources.YOUTUBE_ICON,
            width: DimensResource.D_25,
            height: DimensResource.D_25,
          ),
          title: const Text(StringResources.YOUTUBE_LABEL,
              style: TextStyle(fontWeight: FontWeight.w800)),
        ),
        DrawerWidget(
          leadingIcon: Icons.image,
          navigate: () => context.pushAndRemoveAll(const ImageScreen()),
          screenName: StringResources.IMAGE_SCREEN,
        ),
        DrawerWidget(
          leadingIcon: CupertinoIcons.video_camera,
          navigate: () => context.pushAndRemoveAll(const VideoScreen()),
          screenName: StringResources.VIDEO_SCREEN,
        ),
        DrawerWidget(
            leadingIcon: Icons.audiotrack,
            navigate: () => context.pushAndRemoveAll(const AudioScreen()),
            screenName: StringResources.AUDIO_SCREEN),
      ],
    ));
  }
}
