import 'package:equatable/equatable.dart';

class TripReport extends Equatable {
  final DateTime date;
  final String id;
  final String vehicleId;
  final String vehicleplate;
  final String driverName;
  final String driverLicense;
  final DateTime startTime;
  final DateTime endTime;
  final String startAddress;
  final String endAddress;
  Duration get drivingDuration => endTime.difference(startTime);

  const TripReport({
    required this.date,
    required this.id,
    required this.vehicleId,
    required this.vehicleplate,
    required this.driverName,
    required this.driverLicense,
    required this.startTime,
    required this.endTime,
    required this.startAddress,
    required this.endAddress,
  });

  @override
  List<Object?> get props => [
    date,
    id,
    vehicleId,
    vehicleplate,
    driverName,
    driverLicense,
    startTime,
    endTime,
    startAddress,
    endAddress,
  ];
}

class TotalTripReport extends Equatable {
  final Duration totalWorkingTime;
  const TotalTripReport({required this.totalWorkingTime});
  factory TotalTripReport.fromList(List<TripReport> list) {
    Duration totalWorkingTime = Duration.zero;
    for (final report in list) {
      totalWorkingTime += report.drivingDuration;
    }
    return TotalTripReport(totalWorkingTime: totalWorkingTime);
  }

  @override
  List<Object?> get props => [totalWorkingTime];
}
