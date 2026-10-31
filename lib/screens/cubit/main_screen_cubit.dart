import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(MainScreenInitial());

  void calculate(double mass, double speed) {
    if (mass <= 0) {
      emit(MainScreenError('Масса должна быть больше 0'));
      return;
    }
    if (speed <= 0) {
      emit(MainScreenError('Скорость должна быть больше 0'));
      return;
    }

    final energy = mass * speed * speed / 2;
    emit(MainScreenCalculated(mass: mass, speed: speed, energy: energy));
  }

  void reset() {
    emit(MainScreenInitial());
  }
}