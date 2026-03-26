import 'package:latlong2/latlong.dart';
import '../../../../services/geocoding_service.dart';

class ReverseGeocodeUseCase {
  final GeocodingService geocodingService;

  ReverseGeocodeUseCase(this.geocodingService);

  Future<String> call(LatLng location) {
    return geocodingService.getAddress(location);
  }
}
