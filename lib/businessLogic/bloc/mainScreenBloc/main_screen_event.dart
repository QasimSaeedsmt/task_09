abstract class MainScreenEvent {}

class UpdateSelectedIndex extends MainScreenEvent {
  final int index;

  UpdateSelectedIndex(this.index);
}
