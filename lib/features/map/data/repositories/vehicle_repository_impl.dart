import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_remote_data_source.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleRemoteDataSource remoteDataSource;
  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6ImN0eW5nYW5sdWMiLCJwcGlkIjpbIjI1NiIsIjEiLCIxOTcyIiwiUzdJK3M4cndXL1ArUHhlL1dGWDJxNWE4RTV4REV5b1kiXSwibmJmIjoxNzc0NDE5NjE0LCJleHAiOjE3NzUwMjQ0MTQsImlhdCI6MTc3NDQxOTYxNH0.2WtcFh6aa7x-ZDTbsWvdcnsbqa7xnzt8dBm7vTrL8X4";

  VehicleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<VehicleEntity>> getInitialVehicles() async {
    return await remoteDataSource.getInitialVehicles(token);
  }

  @override
  Stream<List<VehicleEntity>> streamVehicleUpdates() async* {
    // Hiện tại dùng Polling mỗi 10s — sau này thay bằng SignalR
    while (true) {
      await Future.delayed(const Duration(seconds: 10));
      try {
        final cars = await getInitialVehicles();
        yield cars;
      } catch (e) {
        print("Polling error: $e");
      }
    }
  }

  @override
  void stopTracking() {
    // Stop polling logic here if needed
  }
}
