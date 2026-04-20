import 'package:stream_video/core/errors/result.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class GetVehiclesUseCase {
  final VehicleRepository repository;

  GetVehiclesUseCase(this.repository);

  Future<Result<List<VehicleEntity>>> call() {
    return repository.getInitialVehicles();
  }
}
