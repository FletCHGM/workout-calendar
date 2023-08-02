import 'package:hive/hive.dart';
import 'package:workout_calendar/feutures/repos/workout_page_repos/calendar/event_boxes.dart';
part 'todo_list.g.dart';

@HiveType(typeId: 1)
class TodoListEvent {
  TodoListEvent({required this.title, required this.date, required this.key});

  @HiveField(0)
  String? title;

  @HiveField(1)
  String? date;

  @HiveField(2)
  String? key;
}

class ToDoListEvent {
  uploadTodoEvent(String title, String date) async {
    todoEvent = await Hive.openBox<TodoListEvent>('todoEvent');
    DateTime currentTime = DateTime.now();
    todoEvent.put(currentTime.toString(),
        TodoListEvent(title: title, date: date, key: currentTime.toString()));
  }
}
