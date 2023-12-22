import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_09/businessLogic/bloc/imageBloc/image_bloc.dart';
import 'package:task_09/businessLogic/bloc/imageBloc/image_event.dart';
import 'package:task_09/businessLogic/bloc/imageBloc/image_state.dart';
import 'package:task_09/constants/responsive_constants.dart';
import 'package:task_09/constants/string_resource.dart';

import '../utils/custom_drawer.dart';

class Image2 extends StatefulWidget {
  const Image2({super.key});

  @override
  State<Image2> createState() => _Image2State();
}

class _Image2State extends State<Image2> {
  late final ImageBloc imageBloc;

  @override
  void initState() {
    super.initState();
    imageBloc = context.read<ImageBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringResources.IMAGE_SCREEN),
        actions: [
          IconButton(
            onPressed: () {
              imageBloc.add(CaptureImageEvent());
            },
            icon: const Icon(Icons.camera_alt),
          ),
          SizedBox(
            width: size.width * ResponsiveConstants.S_4,
          ),
          IconButton(
            onPressed: () {
              imageBloc.add(PickImageEvent());
            },
            icon: const Icon(Icons.image),
          ),
          SizedBox(
            width: size.width * ResponsiveConstants.S_5,
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: BlocBuilder<ImageBloc, ImageState>(
        builder: (context, state) {
          if (state is ImagePickedState) {
            final filePath = state.imagePath;
            if (filePath != null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.file(filePath),
                  ],
                ),
              );
            }
          }
          return const Center(
            child: Text(StringResources.NO_IMAGE_SELECTED),
          );
        },
      ),
    );
  }
}
