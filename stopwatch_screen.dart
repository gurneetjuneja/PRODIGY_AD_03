import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:stop_watch_app/database_helper.dart'; // Adjust the import path as needed

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  final List<Map<String, dynamic>> _records = [];
  late Timer _timer;
  String _recordLabel = '';
  final FocusNode _recordLabelFocusNode = FocusNode();
  final TextEditingController _recordLabelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {});
      }
    });

    _recordLabelFocusNode.addListener(() {
      setState(() {});
    });

    _loadRecords(); // Load records from database on initialization
  }

  @override
  void dispose() {
    _timer.cancel();
    _recordLabelFocusNode.dispose();
    _recordLabelController.dispose();
    super.dispose();
  }

  void _startStopwatch() {
    setState(() {
      _stopwatch.start();
    });
  }

  void _stopStopwatch() {
    setState(() {
      _stopwatch.stop();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
    });
  }

  void _saveRecord() async {
    if (_recordLabel.isNotEmpty) {
      final record = {
        'label': _recordLabel,
        'time': _stopwatch.elapsed.inMilliseconds, // Store as milliseconds
      };
      int id = await DatabaseHelper.instance.insert(record);
      print('Inserted record with ID: $id'); // Debug print

      setState(() {
        record['_id'] = id; // Add _id to the record
        _records.insert(0, record); // Add new record to the top of the list
        _recordLabel = ''; // Clear the record label after saving
        _recordLabelController.clear(); // Clear the TextField
      });
    }
  }

  void _deleteRecord(int index) async {
    final record = _records[index];
    final recordId = record['_id'] as int; // Ensure this matches the database column name
    print('Deleting record with ID: $recordId'); // Debug print

    int rowsDeleted = await DatabaseHelper.instance.delete(recordId);
    if (rowsDeleted > 0) {
      print('Record deleted successfully');
      setState(() {
        _records.removeAt(index);
      });
    } else {
      print('Failed to delete record with ID: $recordId');
    }
  }

  void _loadRecords() async {
    final records = await DatabaseHelper.instance.queryAllRows();
    print('Loaded records: $records'); // Debug print
    setState(() {
      _records.clear();
      _records.addAll(records);
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = _stopwatch.elapsed;
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds = (duration.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50), // Increased gap between app bar and time display
          Text(
            '$hours:$minutes:$seconds.$milliseconds',
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
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _startStopwatch,
                child: Text('Start'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: _stopStopwatch,
                child: Text('Stop'),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                onPressed: _resetStopwatch,
                child: Text('Reset'),
              ),
            ],
          ),
          SizedBox(height: 24),
          TextField(
            controller: _recordLabelController,
            focusNode: _recordLabelFocusNode,
            onChanged: (value) {
              setState(() {
                _recordLabel = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Record Label',
              border: UnderlineInputBorder(),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.tealAccent, width: 2),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
            ),
            style: GoogleFonts.ubuntu(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: _recordLabelFocusNode.hasFocus ? Colors.tealAccent : Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: _recordLabelFocusNode.hasFocus ? Colors.tealAccent : Colors.white,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveRecord,
            child: Text('Save Record'),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                final timeMilliseconds = record['time'] as int;
                final time = Duration(milliseconds: timeMilliseconds);
                final label = record['label'] as String;
                final hours = time.inHours.toString().padLeft(2, '0');
                final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');
                final seconds = (time.inSeconds % 60).toString().padLeft(2, '0');
                final milliseconds = (time.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');

                return ListTile(
                  title: Text(
                    '$label - $hours:$minutes:$seconds.$milliseconds',
                    style: GoogleFonts.ubuntu(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.tealAccent,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteRecord(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
