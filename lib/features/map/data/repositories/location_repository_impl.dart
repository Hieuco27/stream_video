import 'package:latlong2/latlong.dart';
import '../../domain/repositories/location_repository.dart';
import '../../../../services/location_service.dart';

/// Implementation — gọi LocationService bên dưới
class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;

  LocationRepositoryImpl({required this.locationService});

  @override
  Future<LatLng> getCurrentLocation() {
    return locationService.getCurrentLocation();
  }
}
