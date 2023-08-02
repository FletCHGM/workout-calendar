import 'package:hive/hive.dart';
import 'package:workout_calendar/feutures/repos/workout_page_repos/calendar/event_boxes.dart';

part 'calendar_event.g.dart';

@HiveType(typeId: 0)
class CalendarEvent {
  CalendarEvent(
      {required this.date,
      required this.time,
      required this.title,
      required this.key});

  @HiveField(0)
  String? date;

  @HiveField(1)
  String? time;

  @HiveField(3)
  String? title;

  @HiveField(4)
  String? key;
}

class ToDoEvent {
  uploadEvent(String date, String time, String title) async {
    eventBox = await Hive.openBox<CalendarEvent>('eventBox');
    DateTime currentTime = DateTime.now();
    eventBox.put(
        currentTime.toString(),
        CalendarEvent(
            date: date, time: time, title: title, key: currentTime.toString()));
  }
}
