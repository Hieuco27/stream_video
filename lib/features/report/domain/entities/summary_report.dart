import 'package:equatable/equatable.dart';

class SummaryReport extends Equatable {
  final DateTime date;
  final Duration workingTime; // Thời gian làm việc
  final int stopCount; // Số lần dừng
  final int over4hCount; // Số lần lái liên tục > 4h
  final int speedVioCount; // Số lần quá tốc độ
  final Duration stopDuration; // Tổng thời gian dừng
  final double totalKm; // Tổng km trong ngày
  final String address;

  const SummaryReport({
    required this.totalKm,
    required this.workingTime,
    required this.stopCount,
    required this.over4hCount,
    required this.speedVioCount,
    required this.stopDuration,
    required this.address,
    required this.date,
  });

  @override
  List<Object?> get props => [
    totalKm,
    workingTime,
    stopCount,
    over4hCount,
    speedVioCount,
    stopDuration,
    address,
    date,
  ];
}
