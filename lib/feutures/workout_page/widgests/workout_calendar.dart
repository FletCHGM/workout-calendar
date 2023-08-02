import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:workout_calendar/feutures/repos/workout_page_repos/calendar/calendar_event.dart';
import 'package:workout_calendar/feutures/workout_page/widgests/stopwatch_page.dart';
import 'package:workout_calendar/feutures/repos/workout_page_repos/calendar/todo_list.dart';
import 'event_editing.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _selectedDate;
  List eventsOnDay = [];
  List todoOnDay = [];
  late final Box eventBox;
  late final Box todoEvent;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  void openEventBox() async {
    eventBox = await Hive.openBox<CalendarEvent>('eventBox');
    todoEvent = await Hive.openBox<TodoListEvent>('todoEvent');
    setState(() {
      getDayEvents();
      getTodoEvents();
    });
  }

  void getTodoEvents() {
    todoOnDay = [];
    var i = 0;
    while (i < todoEvent.length) {
      TodoListEvent event = todoEvent.getAt(i);
      if (event.date ==
          '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}_todo') {
        todoOnDay.add(event);
      }
      i++;
    }
  }

  void getDayEvents() {
    eventsOnDay = [];
    var i = 0;
    while (i < eventBox.length) {
      CalendarEvent event = eventBox.getAt(i);
      if (event.date ==
          '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}') {
        eventsOnDay.add(event);
      }
      i++;
    }
  }

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
    openEventBox();
  }

  deleteTodoEvent(event) async {
    var key = event.key;
    await todoEvent.delete(key);
    setState(() {
      getTodoEvents();
    });
  }

  deleteEvent(event) async {
    var key = event.key;
    await eventBox.delete(key);
    setState(() {
      getDayEvents();
    });
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(const Duration(days: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/IMG_3965.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(155, 65, 65, 65),
        appBar: AppBar(
          title: const Text("Workout Calendar"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StopwatchPage()));
                },
                child: const Icon(Icons.timer))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EventEditingPage(date: _selectedDate)));
            setState(() {});
          }),
          child: const Icon(Icons.calendar_today),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(6)),
              CalendarTimeline(
                showYears: false,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
                onDateSelected: (date) => setState(() {
                  _selectedDate = date;
                  getDayEvents();
                  getTodoEvents();
                }),
                leftMargin: 20,
                monthColor: Colors.white70,
                dayColor: Colors.white70,
                dayNameColor: const Color(0xFF333A47),
                activeDayColor: Colors.white,
                activeBackgroundDayColor: Colors.brown[400],
                dotsColor: const Color(0xFF333A47),
                locale: 'en',
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 580,
                  child: Row(children: [
                    SizedBox(
                        width: 170,
                        child: RefreshIndicator(
                          child: ListView.separated(
                            separatorBuilder: (context, index) => const Divider(
                              height: 7,
                            ),
                            itemCount: eventsOnDay.length,
                            itemBuilder: (context, i) {
                              String time = eventsOnDay[i].time!;
                              String title = eventsOnDay[i].title!;
                              return Container(
                                color: const Color.fromARGB(220, 96, 125, 139),
                                child: Column(children: [
                                  const SizedBox(height: 50),
                                  Text(
                                    time,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 35),
                                  ),
                                  Text(
                                    title,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  const SizedBox(height: 30),
                                  IconButton(
                                      onPressed: () {
                                        deleteEvent(eventsOnDay[i]);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      )),
                                ]),
                              );
                            },
                          ),
                          onRefresh: () async {
                            setState(() {
                              getDayEvents();
                            });
                          },
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          SizedBox(
                            width: 185,
                            child: TextFormField(
                              controller: controller,
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintText: 'Day note',
                                  hintStyle:
                                      const TextStyle(color: Colors.white60),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await ToDoListEvent().uploadTodoEvent(
                                              controller.text,
                                              '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}_todo');
                                          setState(() {
                                            controller.clear();
                                            getTodoEvents();
                                          });
                                        }
                                      },
                                      icon: const Icon(Icons.add_box,
                                          color: Colors.white))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field cannot be empty!';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            color: Color.fromARGB(169, 78, 92, 99),
                            width: 185,
                            height: 515,
                            child: ListView.builder(
                              itemCount: todoOnDay.length,
                              itemBuilder: (context, i) {
                                String title = todoOnDay[i].title!;
                                return Padding(
                                  padding: const EdgeInsets.all(2.75),
                                  child: Container(
                                    color:
                                        const Color.fromARGB(211, 141, 110, 99),
                                    child: Row(children: [
                                      IconButton(
                                          onPressed: () {
                                            deleteTodoEvent(todoOnDay[i]);
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                          )),
                                      Text(
                                        title,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      const SizedBox(height: 30),
                                    ]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ]))
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
