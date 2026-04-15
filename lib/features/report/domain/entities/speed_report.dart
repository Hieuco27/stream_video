class SpeedRecord {
  final DateTime timestamp;
  final int speedKmh;
  final String description;

  const SpeedRecord({
    required this.timestamp,
    required this.speedKmh,
    required this.description,
  });
}

class SpeedMinuteGroup {
  final DateTime minute;
  final List<SpeedRecord> records;

  const SpeedMinuteGroup({required this.minute, required this.records});

  int get avgSpeed {
    if (records.isEmpty) return 0;
    return (records.map((r) => r.speedKmh).reduce((a, b) => a + b) /
            records.length)
        .round();
  }
}

class SpeedTotal {
  final int totalRecords;
  final int avgSpeed;
  final int overSpeedCount;

  const SpeedTotal({
    required this.totalRecords,
    required this.avgSpeed,
    required this.overSpeedCount,
  });

  factory SpeedTotal.fromRecords(List<SpeedRecord> records) {
    if (records.isEmpty) {
      return const SpeedTotal(totalRecords: 0, avgSpeed: 0, overSpeedCount: 0);
    }
    final avg =
        (records.map((r) => r.speedKmh).reduce((a, b) => a + b) /
                records.length)
            .round();
    final over = records.where((r) => r.speedKmh > 40).length;
    return SpeedTotal(
      totalRecords: records.length,
      avgSpeed: avg,
      overSpeedCount: over,
    );
  }
}
