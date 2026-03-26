import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class StreamVehicleUpdatesUseCase {
  final VehicleRepository repository;

  StreamVehicleUpdatesUseCase(this.repository);

  Stream<List<VehicleEntity>> call() {
    return repository.streamVehicleUpdates();
  }
}
