import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class NominatimService {
  Future<String> getAddress(LatLng location) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${location.latitude}&lon=${location.longitude}&format=json&accept-language=vi',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'StreamVideoApp/1.0.0'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? 'Không tìm thấy địa chỉ';
      }
      return 'Không tìm thấy địa chỉ';
    } catch (e) {
      return 'Không thể lấy địa chỉ';
    }
  }
}
