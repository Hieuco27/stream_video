import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class GetVehiclesUseCase {
  final VehicleRepository repository;

  GetVehiclesUseCase(this.repository);

  Future<List<VehicleEntity>> call() {
    return repository.getInitialVehicles();
  }
}
