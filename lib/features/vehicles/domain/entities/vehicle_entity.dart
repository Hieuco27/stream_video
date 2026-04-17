import 'package:equatable/equatable.dart';

enum VehicleStatus { moving, stopped, engineOff, noSignal, noGps }

class VehicleEntity extends Equatable {
  final String id;
  final String name; // tên lái xe
  final String plate; // biển số xe
  final String type; // loại xe
  final VehicleStatus status; //trạng thái xe
  final String location; // vị trí
  final String speed; // tốc độ
  final String engine; // trạng thái động cơ
  final String battery; // trạng thái pin
  final String signal; // tín hiệu
  final String lastUpdate; // thời gian cập nhật cuối cùng
  final String lastLocation; // vị trí cuối cùng
  final String lastSpeed; // tốc độ cuối cùng
  final String lastEngine; // trạng thái động cơ cuối cùng
  final String lastBattery; // trạng thái pin cuối cùng
  final String lastSignal; // tín hiệu cuối cùng
  final double latitude;
  final double longitude;
  final String parkingDuration; // thời gian đỗ xe
  final String stopDuration; // thời gian dừng
  final String kmToday; // số km đã đi
  final String drivingTimeToday; // thời gian lái xe trong ngày
  final String continuousDrivingTime; // thời gian lái xe liên tục

  const VehicleEntity({
    required this.id,
    required this.name,
    required this.plate,
    required this.type,
    required this.status,
    required this.location,
    required this.speed,
    required this.engine,
    required this.battery,
    required this.signal,
    required this.lastUpdate,
    required this.lastLocation,
    required this.lastSpeed,
    required this.lastEngine,
    required this.lastBattery,
    required this.lastSignal,
    required this.latitude,
    required this.longitude,
    required this.parkingDuration,
    required this.stopDuration,
    required this.kmToday,
    required this.drivingTimeToday,
    required this.continuousDrivingTime,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    plate,
    type,
    status,
    location,
    speed,
    engine,
    battery,
    signal,
    lastUpdate,
    lastLocation,
    lastSpeed,
    lastEngine,
    lastBattery,
    lastSignal,
    latitude,
    longitude,
    parkingDuration,
    stopDuration,
    kmToday,
    drivingTimeToday,
    continuousDrivingTime,
  ];
}
