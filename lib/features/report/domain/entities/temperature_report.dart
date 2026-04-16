import 'dart:math';

import 'package:equatable/equatable.dart';

class TemperatureReport extends Equatable {
  final DateTime timestamp;
  final double temperatureC;
  final String sensorId;

  TemperatureReport({
    required this.timestamp,
    required this.temperatureC,
    required this.sensorId,
  });

  @override
  List<Object?> get props => [timestamp, temperatureC, sensorId];
}

class TemperatureTotal extends Equatable {
  final double minTemp;
  final double maxTemp;
  final double avgTemp;
  final int totalRecords;

  TemperatureTotal({
    required this.minTemp,
    required this.maxTemp,
    required this.avgTemp,
    required this.totalRecords,
  });

  factory TemperatureTotal.fromList(List<TemperatureReport> reports) {
    if (reports.isEmpty) {
      return TemperatureTotal(
        minTemp: 0,
        maxTemp: 0,
        avgTemp: 0,
        totalRecords: 0,
      );
    }
    final temps = reports.map((r) => r.temperatureC).toList();
    return TemperatureTotal(
      minTemp: temps.reduce(min),
      maxTemp: temps.reduce(max),
      avgTemp: temps.reduce((a, b) => a + b) / temps.length,
      totalRecords: reports.length,
    );
  }

  @override
  List<Object?> get props => [minTemp, maxTemp, avgTemp, totalRecords];
}
