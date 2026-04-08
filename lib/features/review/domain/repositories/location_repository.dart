import 'package:latlong2/latlong.dart';
import '../../../../core/errors/result.dart';

abstract class LocationRepository {
  /// Lấy tọa độ GPS hiện tại của thiết bị
  Future<Result<LatLng>> getCurrentLocation();
}
