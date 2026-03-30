import 'package:latlong2/latlong.dart';
import '../repositories/location_repository.dart';
import '../../../../core/errors/result.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<Result<LatLng>> call() {
    return repository.getCurrentLocation();
  }
}
