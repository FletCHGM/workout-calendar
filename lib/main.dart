import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_calendar/feutures/app/app_exports.dart';
import 'package:workout_calendar/feutures/repos/workout_page_repos/calendar/event_boxes.dart';
import 'package:workout_calendar/feutures/repos/workout_page_repos/calendar/todo_list.dart';
import 'package:workout_calendar/feutures/repos/workout_page_repos/calendar/calendar_event.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CalendarEventAdapter());
  Hive.registerAdapter(TodoListEventAdapter());
  eventBox = await Hive.openBox<CalendarEvent>('eventBox');
  todoEvent = await Hive.openBox<TodoListEvent>('todoEvent');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HomePage());
}
