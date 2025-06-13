import 'package:flutter/material.dart';
import 'package:time_clock/database_helper.dart';
import 'package:time_clock/time_entry.dart'; // Assuming time_entry.dart is in the same directory

class EditTimeEntryScreen extends StatefulWidget {
  final TimeEntry timeEntry;

  @override
  _EditTimeEntryScreenState createState() => _EditTimeEntryScreenState();
  const EditTimeEntryScreen({Key? key, required this.timeEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Time Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Clock In Time'),
            TextField(
              controller: _clockInController,
              decoration:
                  const InputDecoration(hintText: 'YYYY-MM-DD HH:MM:SS'),
            ),
            SizedBox(height: 16.0),
            const Text('Clock Out Time (Optional)'),
            TextField(
              controller: _clockOutController,
              decoration:
                  const InputDecoration(hintText: 'YYYY-MM-DD HH:MM:SS'),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditTimeEntryScreenState extends State<EditTimeEntryScreen> {
  late TextEditingController _clockInController;
  late TextEditingController _clockOutController;

  @override
  void initState() {
    super.initState();
    _clockInController =
        TextEditingController(text: widget.timeEntry.clockInTime.toString());
    _clockOutController = TextEditingController(
        text: widget.timeEntry.clockOutTime?.toString() ?? '');
  }

  @override
  void dispose() {
    _clockInController.dispose();
    _clockOutController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    // Implement save logic here
    // Parse text to DateTime, create updated TimeEntry, call updateTimeEntry, pop screen
  }
}