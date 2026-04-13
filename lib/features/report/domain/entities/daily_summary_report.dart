import 'package:equatable/equatable.dart';

/// Entity đại diện cho báo cáo tổng hợp của 1 ngày / 1 xe.
class DailySummaryReport extends Equatable {
  final DateTime date; // ngày báo cáo
  final Duration workingTime; // Thời gian làm việc (lái + dừng có động cơ)
  final int stopCount; // Số lần dừng
  final int over4hCount; // Số lần lái liên tục > 4h
  final int speedVioCount; // Số lần quá tốc độ
  final Duration stopDuration; // Tổng thời gian dừng
  final double totalKm; // Tổng km trong ngày
  final String startAddress; // Địa chỉ điểm xuất phát đầu ngày
  final String endAddress;   // Địa chỉ GPS cuối cùng trong ngày

  const DailySummaryReport({
    required this.date,
    required this.workingTime,
    required this.stopCount,
    required this.over4hCount,
    required this.speedVioCount,
    required this.stopDuration,
    required this.totalKm,
    required this.startAddress,
    required this.endAddress,
  });

  @override
  List<Object?> get props => [
    date,
    workingTime,
    stopCount,
    over4hCount,
    speedVioCount,
    stopDuration,
    totalKm,
    startAddress,
    endAddress,
  ];
}

/// Tổng hợp toàn bộ khoảng ngày — dùng cho hàng "Tổng cộng" cuối list.
class SummaryTotal extends Equatable {
  final Duration totalWorkingTime;
  final int totalStopCount;
  final int totalOver4hCount;
  final int totalSpeedVioCount;
  final Duration totalStopDuration;
  final double totalKm;
  final int dayCount;

  const SummaryTotal({
    required this.totalWorkingTime,
    required this.totalStopCount,
    required this.totalOver4hCount,
    required this.totalSpeedVioCount,
    required this.totalStopDuration,
    required this.totalKm,
    required this.dayCount,
  });

  /// Tính tổng từ danh sách DailySummaryReport
  factory SummaryTotal.fromList(List<DailySummaryReport> list) {
    Duration workingTime = Duration.zero;
    Duration stopDuration = Duration.zero;
    int stopCount = 0;
    int over4hCount = 0;
    int speedVioCount = 0;
    double totalKm = 0;

    for (final d in list) {
      workingTime += d.workingTime;
      stopDuration += d.stopDuration;
      stopCount += d.stopCount;
      over4hCount += d.over4hCount;
      speedVioCount += d.speedVioCount;
      totalKm += d.totalKm;
    }

    return SummaryTotal(
      totalWorkingTime: workingTime,
      totalStopCount: stopCount,
      totalOver4hCount: over4hCount,
      totalSpeedVioCount: speedVioCount,
      totalStopDuration: stopDuration,
      totalKm: totalKm,
      dayCount: list.length,
    );
  }

  @override
  List<Object?> get props => [
    totalWorkingTime,
    totalStopCount,
    totalOver4hCount,
    totalSpeedVioCount,
    totalStopDuration,
    totalKm,
    dayCount,
  ];
}
