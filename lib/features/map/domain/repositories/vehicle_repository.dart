import 'package:stream_video/core/errors/result.dart';
import '../entities/vehicle.dart';

abstract class VehicleRepository {
  /// Lấy danh sách xe ban đầu qua API REST
  Future<Result<List<VehicleEntity>>> getInitialVehicles();

  /// Mở kết nối SignalR và lắng nghe vị trí xe cập nhật realtime
  Stream<Result<List<VehicleEntity>>> streamVehicleUpdates();

  /// Ngắt kết nối SignalR khi không dùng nữa
  void stopTracking();
}
