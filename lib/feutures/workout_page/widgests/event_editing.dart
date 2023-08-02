import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:workout_calendar/feutures/repos/workout_page_repos/calendar/calendar_event.dart';

// ignore: must_be_immutable
class EventEditingPage extends StatefulWidget {
  EventEditingPage({super.key, required this.date});
  DateTime date;

  @override
  // ignore: no_logic_in_create_state
  State<EventEditingPage> createState() => _EventEditingPageState(date: date);
}

class _EventEditingPageState extends State<EventEditingPage> {
  _EventEditingPageState({required this.date});
  DateTime date;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  final timeController = TextEditingController();
  final format = DateFormat("HH:mm");

  @override
  void dispose() {
    controller.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/IMG_3969.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: const Color.fromARGB(155, 65, 65, 65),
          appBar: AppBar(title: const Text("Add event")),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.white60),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title field cannot be empty!';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: timeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Time',
                        hintStyle: const TextStyle(color: Colors.white60),
                        suffixIconColor: Colors.white,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.timelapse),
                          onPressed: () {
                            pickTime(context);
                          },
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Time field cannot be empty!';
                      }
                      try {
                        if ((value.length == 5 &&
                                value[2] == ':' &&
                                (int.parse('${value[0]}${value[1]}') <= 24) &&
                                (int.parse('${value[3]}${value[4]}') <= 60)) ||
                            (value.length == 4 &&
                                value[1] == ':' &&
                                (int.parse('${value[2]}${value[3]}') <= 60))) {
                          return null;
                        } else {
                          return 'Incorrect time format!';
                        }
                      } catch (e) {
                        return 'Incorrect time format!';
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ToDoEvent().uploadEvent(
                                  '${date.year}-${date.month}-${date.day}',
                                  timeController.text,
                                  controller.text);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Add"))),
                  const SizedBox()
                ],
              ),
            ),
          )),
    );
  }

  void pickTime(BuildContext context) async {
    DateTime? currentValue;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
    );
    DateTime date = DateTimeField.convert(time)!;
    if (date.minute < 10) {
      timeController.text = "${date.hour}:0${date.minute}";
    } else {
      timeController.text = "${date.hour}:${date.minute}";
    }
  }
}
