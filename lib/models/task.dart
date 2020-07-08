class Task {
  final int id;
  final String name;
  bool isDone;

  Task({this.id, this.name, this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }
}
