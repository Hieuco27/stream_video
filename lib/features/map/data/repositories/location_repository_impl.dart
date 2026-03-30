import 'package:latlong2/latlong.dart';
import '../../domain/repositories/location_repository.dart';
import '../../../../services/location_service.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/errors/failure.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;

  LocationRepositoryImpl({required this.locationService});

  @override
  Future<Result<LatLng>> getCurrentLocation() async {
    try {
      final location = await locationService.getCurrentLocation();
      return Result.success(location);
    } catch (e) {
      return Result.error(LocationFailure(message: e.toString()));
    }
  }
}
