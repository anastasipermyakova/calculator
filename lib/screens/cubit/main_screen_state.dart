abstract class MainScreenState {}

class MainScreenInitial extends MainScreenState {}

class MainScreenCalculated extends MainScreenState {
  final double mass;
  final double speed;
  final double energy;

  MainScreenCalculated({
    required this.mass,
    required this.speed,
    required this.energy,
  });
}

class MainScreenError extends MainScreenState {
  final String message;
  MainScreenError(this.message);
}