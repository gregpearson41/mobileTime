import 'package:flutter/material.dart';
import 'package:time_clock/database_helper.dart';
import 'package:time_clock/time_entry.dart';

import 'package:time_clock/edit_time_entry_screen.dart';
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Time Clock',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isClockedIn = false;
  String _statusText = 'Clocked Out';
  List<TimeEntry> _timeEntries = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadTimeEntries();
  }

  void _loadTimeEntries() async {
    final entries = await _dbHelper.getTimeEntries();
    setState(() {
      _timeEntries = entries;
      // Check the last entry to determine current status
      if (_timeEntries.isNotEmpty && _timeEntries.last.clockOutTime == null) {
        _isClockedIn = true;
        _statusText = 'Clocked In';
      }
    });
  }

  void _toggleClockStatus() async {
    setState(() {
      _isClockedIn = !_isClockedIn;
      _statusText = _isClockedIn ? 'Clocked In' : 'Clocked Out';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Clock'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _statusText,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _timeEntries.length,
                itemBuilder: (context, index) {
                  final entry = _timeEntries[index];
                  return Dismissible(
                    key: Key(entry.id.toString()), // Unique key for each item
                    direction: DismissDirection.endToStart, // Swipe from right to left
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) async{
                      await _dbHelper.deleteTimeEntry(entry.id!);
                      _loadTimeEntries(); // Refresh the list after deleting
                    },
                    onTap: () async {
 await Navigator.push(context, MaterialPageRoute(builder: (context) => EditTimeEntryScreen(timeEntry: entry)));
 _loadTimeEntries(); // Refresh list after returning from edit screen
                    },
                    child: ListTile(
                      title: Text(
                          'Clock In: ${entry.clockInTime.toLocal().toString().split('.')[0]}'),
                      subtitle: Text(
                          'Clock Out: ${entry.clockOutTime?.toLocal().toString().split('.')[0] ?? 'Still Clocked In'}\nDuration: ${entry.getDuration()}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_isClockedIn) {
            // Clocking out
            final lastEntry = _timeEntries.last;
            lastEntry.clockOutTime = DateTime.now();
            await _dbHelper.updateTimeEntry(lastEntry);
          } else {
            // Clocking in
            await _dbHelper.insertTimeEntry(TimeEntry(clockInTime: DateTime.now()));
          }
          _loadTimeEntries(); // Reload entries after action
        },
        label: Text(_isClockedIn ? 'Clock Out' : 'Clock In'),
        icon: Icon(_isClockedIn ? Icons.logout : Icons.login),
      ),
    );
  }
}
