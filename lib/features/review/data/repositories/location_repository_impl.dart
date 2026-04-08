import 'package:latlong2/latlong.dart';
import 'package:stream_video/features/review/domain/repositories/location_repository.dart';
import 'package:stream_video/core/errors/result.dart';
import 'package:stream_video/core/errors/failure.dart';
import 'package:stream_video/services/location_service.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;

  LocationRepositoryImpl({required this.locationService});

  @override
  Future<Result<LatLng>> getCurrentLocation() async {
    try {
      final location = await locationService.getCurrentLocation();
      return Result.success(LatLng(location.latitude, location.longitude));
    } catch (e) {
      if (e is LocationException) {
        return Result.error(LocationFailure(message: e.message));
      }
      return Result.error(LocationFailure(message: e.toString()));
    }
  }
}
