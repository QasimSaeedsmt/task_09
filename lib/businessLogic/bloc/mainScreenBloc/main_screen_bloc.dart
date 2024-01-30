import 'package:bloc/bloc.dart';
import 'package:task_09/constants/constants_resources.dart';

import 'main_screen_event.dart';
import 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(MainScreenState(ConstantsResources.ZERO)) {
    on<UpdateSelectedIndex>(
        (event, emit) => emit(MainScreenState(event.index)));
  }
}
