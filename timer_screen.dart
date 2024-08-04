import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  int _totalMilliseconds = 0;
  bool _isRunning = false;

  final TextEditingController _hoursController = TextEditingController(text: '00');
  final TextEditingController _minutesController = TextEditingController(text: '00');
  final TextEditingController _secondsController = TextEditingController(text: '00');
  final TextEditingController _millisecondsController = TextEditingController(text: '00');

  @override
  void dispose() {
    _timer?.cancel();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _millisecondsController.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _totalMilliseconds = (int.tryParse(_hoursController.text) ?? 0) * 3600000 +
          (int.tryParse(_minutesController.text) ?? 0) * 60000 +
          (int.tryParse(_secondsController.text) ?? 0) * 1000 +
          (int.tryParse(_millisecondsController.text) ?? 0);
      _isRunning = true;
    });
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (_totalMilliseconds > 0) {
        setState(() {
          _totalMilliseconds -= 10;
          _updateControllers();
        });
      } else {
        timer.cancel();
        setState(() {
          _isRunning = false;
        });
      }
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void resetTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _totalMilliseconds = 0;
      _isRunning = false;
      _updateControllers();
    });
  }

  void _updateControllers() {
    final hours = (_totalMilliseconds ~/ 3600000).toString().padLeft(2, '0');
    final minutes = ((_totalMilliseconds % 3600000) ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((_totalMilliseconds % 60000) ~/ 1000).toString().padLeft(2, '0');
    final milliseconds = (_totalMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');

    _hoursController.text = hours;
    _minutesController.text = minutes;
    _secondsController.text = seconds;
    _millisecondsController.text = milliseconds;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEditableTimeField(_hoursController, 'Hours'),
              Text(
                ":",
                style: GoogleFonts.ubuntu(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 15.0,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              _buildEditableTimeField(_minutesController, 'Minutes'),
              Text(
                ":",
                style: GoogleFonts.ubuntu(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 15.0,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              _buildEditableTimeField(_secondsController, 'Seconds'),
              Text(
                ".",
                style: GoogleFonts.ubuntu(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 15.0,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              _buildEditableTimeField(_millisecondsController, 'Milliseconds'),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isRunning ? stopTimer : startTimer,
            child: Text(_isRunning ? 'Stop' : 'Start'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: resetTimer,
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableTimeField(TextEditingController controller, String label) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: GoogleFonts.ubuntu(
          fontSize: 48.0,
          fontWeight: FontWeight.bold,
          color: Colors.tealAccent,
          shadows: [
            Shadow(
              blurRadius: 15.0,
              color: Colors.tealAccent,
              offset: Offset(0, 0),
            ),
          ],
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: GoogleFonts.ubuntu(
            fontSize: 18.0,
            color: Colors.white70,
          ),
        ),
        keyboardType: TextInputType.number,
        onTap: () {
          setState(() {
            controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            );
          });
        },
      ),
    );
  }
}
