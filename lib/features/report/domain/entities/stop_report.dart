import 'package:equatable/equatable.dart';

class StopReport extends Equatable {
  final DateTime date;
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String address;
  Duration get stopDuration => endTime.difference(startTime);

  const StopReport({
    required this.date,
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.address,
  });

  @override
  List<Object?> get props => [date, id, startTime, endTime, address];
}

class TotalStopReport extends Equatable {
  final Duration totalWorkingTime;
  final int totalStopCount;
  const TotalStopReport({
    required this.totalWorkingTime,
    required this.totalStopCount,
  });
  factory TotalStopReport.fromList(List<StopReport> list) {
    Duration totalWorkingTime = Duration.zero;
    for (final report in list) {
      totalWorkingTime += report.stopDuration;
    }
    return TotalStopReport(
      totalWorkingTime: totalWorkingTime,
      totalStopCount: list.length,
    );
  }

  @override
  List<Object?> get props => [totalWorkingTime, totalStopCount];
}
