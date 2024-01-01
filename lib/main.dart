import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_09/businessLogic/bloc/imageBloc/image_bloc.dart';
import 'package:task_09/businessLogic/bloc/videoBloc/video_bloc.dart';
import 'package:task_09/presentation/screens/main_screen.dart';

import 'businessLogic/bloc/audioBloc/audio_bloc.dart';
import 'businessLogic/bloc/mainScreenBloc/main_screen_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ImageBloc(),
          ),
          BlocProvider(
            create: (context) => AudioBloc(),
          ),
          BlocProvider(
            create: (context) => MainScreenBloc(),
          ),
          BlocProvider(
            create: (context) => VideoBloc(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: Colors.red,
            ),
            bottomNavigationBarTheme:
                const BottomNavigationBarThemeData(backgroundColor: Colors.red),
            primarySwatch: Colors.red,
          ),
          debugShowCheckedModeBanner: false,
          home: const MainScreen(),
        ));
  }
}
