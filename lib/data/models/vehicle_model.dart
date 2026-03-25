import 'package:stream_video/domain/entities/vehicle.dart';

class VehicleModel extends VehicleEntity {
  VehicleModel({
    required String id,
    required String licensePlate,
    required VehicleStatus status,
    required double latitude,
    required double longitude,
    required double speed,
    required double heading,
    required DateTime lastUpdate,
    String? address,
  }) : super(
         id: id,
         licensePlate: licensePlate,
         status: status,
         latitude: latitude,
         longitude: longitude,
         speed: speed,
         heading: heading,
         lastUpdate: lastUpdate,
         address: address,
       );

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    // Xử lý parse toạ độ từ String sang double
    final lat = double.tryParse(json['Latitude']?.toString() ?? '0') ?? 0.0;
    final lng = double.tryParse(json['Longitude']?.toString() ?? '0') ?? 0.0;

    // Xử lý parse ngày tháng từ định dạng /Date(1774422743000)/
    DateTime parsedTime = DateTime.now();
    final timeStr = json['Time']?.toString() ?? '';
    if (timeStr.contains('Date')) {
      final milliseconds = int.tryParse(timeStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      parsedTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    }

    // Mapping trạng thái xe dựa trên logic nghiệp vụ (ví dụ: DongCo, VGPS, TrangThaiTinHieu)
    VehicleStatus derivedStatus = VehicleStatus.lostSignal;
    final bool isEngineOn = json['DongCo'] ?? false;
    final double speed = (json['VGPS'] as num?)?.toDouble() ?? 0.0;
    final String signalStatus = json['TrangThaiTinHieu']?.toString() ?? '0';

    if (signalStatus == '0') {
      derivedStatus = VehicleStatus.lostSignal;
    } else if (speed > 0) {
      derivedStatus = VehicleStatus.running;
    } else if (isEngineOn) {
      derivedStatus = VehicleStatus.parked;
    } else {
      derivedStatus = VehicleStatus.engineOff;
    }

    return VehicleModel(
      id: json['IMEI']?.toString() ?? json['ID']?.toString() ?? '',
      licensePlate: json['BienSoXe']?.toString() ?? '',
      status: derivedStatus,
      latitude: lat,
      longitude: lng,
      speed: speed,
      heading: (json['Heading'] as num?)?.toDouble() ?? 0.0,
      lastUpdate: parsedTime,
      address: json['Address']?.toString(),
    );
  }
}
