import 'package:latlong2/latlong.dart';
import '../../../../services/geocoding_service.dart';

class ReverseGeocodeUseCase {
  final NominatimService nominatimService;

  ReverseGeocodeUseCase(this.nominatimService);

  Future<String> call(LatLng location) {
    return nominatimService.getAddress(location);
  }
}
