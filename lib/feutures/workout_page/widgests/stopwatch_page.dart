import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  bool _isGoing = false;
  String _result = '00:00:00';

  void _start() {
    if (!_isGoing) {
      _isGoing = true;
      _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
        setState(() {
          _result =
              '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
        });
      });
      _stopwatch.start();
    } else {
      _stop();
    }
  }

  void _stop() {
    _isGoing = false;
    _timer.cancel();
    _stopwatch.stop();
  }

  void _reset() {
    _stop();
    _stopwatch.reset();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 200,
            ),
            Text(
              _result,
              style: const TextStyle(fontSize: 50.0, color: Colors.white),
            ),
            const SizedBox(
              height: 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    iconSize: 70,
                    color: Colors.white,
                    onPressed: _start,
                    icon: (_isGoing)
                        ? const Icon(Icons.pause_outlined)
                        : const Icon(Icons.play_arrow_rounded)),
                IconButton(
                  iconSize: 70,
                  color: Colors.white,
                  onPressed: _reset,
                  icon: const Icon(Icons.stop_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
