import 'package:latlong2/latlong.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<LatLng> call() {
    return repository.getCurrentLocation();
  }
}
