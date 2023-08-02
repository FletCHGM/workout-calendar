import 'package:flutter/material.dart';
import 'package:workout_calendar/feutures/workout_page/workout_page_exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkoutApp',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color.fromARGB(255, 65, 65, 65),
      ),
      home: Calendar(),
    );
  }
}
