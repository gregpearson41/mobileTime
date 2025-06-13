class TimeEntry {
  int? id;
  DateTime clockInTime;
  DateTime? clockOutTime;

  TimeEntry({this.id, required this.clockInTime, this.clockOutTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clock_in_time': clockInTime.toIso8601String(),
      'clock_out_time': clockOutTime?.toIso8601String(),
    };
  }

  factory TimeEntry.fromMap(Map<String, dynamic> map) {
    return TimeEntry(
      id: map['id'],
      clockInTime: DateTime.parse(map['clock_in_time']),
      clockOutTime: map['clock_out_time'] != null
          ? DateTime.parse(map['clock_out_time'])
          : null,
    );
  }

  String getDuration() {
    if (clockOutTime == null) {
      return 'Ongoing';
    }

    Duration duration = clockOutTime!.difference(clockInTime);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}