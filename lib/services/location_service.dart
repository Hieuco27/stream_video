import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  Future<LatLng> getCurrentLocation() async {
    // 1. Kiểm tra GPS bật chưa
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('GPS chưa bật. Vui lòng bật GPS.');
    }

    // 2. Kiểm tra và xin quyền location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Quyền vị trí bị từ chối.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
        'Quyền vị trí bị từ chối vĩnh viễn. Hãy vào Cài đặt để bật.',
      );
    }

    // 3. Lấy vị trí hiện tại
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(position.latitude, position.longitude);
  }
}

/// Custom exception cho lỗi Location
class LocationException implements Exception {
  final String message;
  const LocationException(this.message);

  @override
  String toString() => message;
}
