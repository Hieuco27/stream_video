import 'package:latlong2/latlong.dart';

/// Interface — BLoC chỉ biết đến interface này
abstract class LocationRepository {
  /// Lấy vị trí hiện tại (kiểm tra GPS + quyền + lấy tọa độ)
  Future<LatLng> getCurrentLocation();
}
