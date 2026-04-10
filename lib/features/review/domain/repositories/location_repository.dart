import 'package:latlong2/latlong.dart';
import '../../../../core/errors/result.dart';

abstract class LocationRepository {
  Future<Result<LatLng>> getCurrentLocation();
}
