import 'package:stream_video/core/errors/result.dart';
import '../entities/vehicle.dart';
import '../repositories/vehicle_repository.dart';

class StreamVehicleUpdatesUseCase {
  final VehicleRepository repository;

  StreamVehicleUpdatesUseCase(this.repository);

  Stream<Result<List<VehicleEntity>>> call() {
    return repository.streamVehicleUpdates();
  }
}
