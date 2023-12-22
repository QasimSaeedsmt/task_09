import 'package:bloc/bloc.dart';

import 'main_screen_event.dart';
import 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(MainScreenState(0)) {
    on<UpdateSelectedIndex>(
        (event, emit) => emit(MainScreenState(event.index)));
  }
}
