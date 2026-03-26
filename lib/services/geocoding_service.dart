import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class GeocodingService {
  Future<String> getAddress(LatLng location) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isEmpty) {
        return 'Không tìm thấy địa chỉ';
      }

      final place = placemarks.first;

      // Ghép các phần: số nhà + đường, phường, quận, tỉnh
      final parts = <String>[
        if (place.street != null && place.street!.isNotEmpty) place.street!,
        if (place.subLocality != null && place.subLocality!.isNotEmpty)
          place.subLocality!,
        if (place.subAdministrativeArea != null &&
            place.subAdministrativeArea!.isNotEmpty)
          place.subAdministrativeArea!,
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty)
          place.administrativeArea!,
      ];

      return parts.isNotEmpty ? parts.join(', ') : 'Không tìm thấy địa chỉ';
    } catch (e) {
      return 'Không thể lấy địa chỉ';
    }
  }
}
