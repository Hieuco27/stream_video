import 'package:equatable/equatable.dart';

class VehicleStatEntity extends Equatable {
  final String id;
  final String parkingDuration; // thời gian đỗ xe
  final String stopDuration; // thời gian dừng
  final double kmToday; // số km đã đi
  final String drivingTimeToday; // thời gian lái xe trong ngày
  final String continuousDrivingTime; // thời gian lái xe liên tục

  const VehicleStatEntity({
    required this.id,
    required this.parkingDuration,
    required this.stopDuration,
    required this.kmToday,
    required this.drivingTimeToday,
    required this.continuousDrivingTime,
  });

  @override
  List<Object?> get props => [
    id,
    parkingDuration,
    stopDuration,
    kmToday,
    drivingTimeToday,
    continuousDrivingTime,
  ];
}
