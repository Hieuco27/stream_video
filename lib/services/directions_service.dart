import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/features/map/domain/entities/route_entity.dart';

/// Gọi OSRM API để lấy đường đi ngắn nhất giữa 2 điểm
class DirectionsService {
  final Dio dio;

  DirectionsService({required this.dio});

  Future<RouteEntity> getRoute(LatLng origin, LatLng destination) async {
    // OSRM format: /route/v1/driving/{lng},{lat};{lng},{lat}
    final url =
        'https://router.project-osrm.org/route/v1/driving/'
        '${origin.longitude},${origin.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?overview=full&geometries=geojson';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        final routes = data['routes'] as List;

        if (routes.isEmpty) {
          throw Exception('Không tìm thấy đường đi');
        }

        final route = routes[0];

        // Parse geometry (GeoJSON coordinates: [lng, lat])
        final coordinates = route['geometry']['coordinates'] as List;
        final points = coordinates
            .map<LatLng>(
              (coord) => LatLng(
                (coord[1] as num).toDouble(),
                (coord[0] as num).toDouble(),
              ),
            )
            .toList();

        // Parse distance (meters → km) and duration (seconds → minutes)
        final distanceKm = (route['distance'] as num).toDouble() / 1000;
        final durationMinutes = (route['duration'] as num).toDouble() / 60;

        return RouteEntity(
          id: '${origin.hashCode}_${destination.hashCode}',
          points: points,
          distanceKm: distanceKm,
          durationMinutes: durationMinutes,
        );
      } else {
        throw Exception('OSRM API error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Mất kết nối internet, vui lòng thử lại');
      }
      throw Exception('Không thể tìm đường đi, vui lòng thử lại');
    } catch (e) {
      throw Exception('Không thể tìm đường đi, vui lòng thử lại');
    }
  }

  Future<RouteEntity> matchRoute(List<LatLng> points) async {
    final url =
        'https://router.project-osrm.org/match/v1/driving/'
        '${points.map((p) => '${p.longitude},${p.latitude}').join(';')}'
        '?overview=full&geometries=geojson';
    try {
      final response = await dio.get(url);
      final data = response.data;

      if (data['code'] == 'Ok') {
        final matching = data['matchings'][0];

        // Parse GeoJSON giống getRoute
        final coordinates = matching['geometry']['coordinates'] as List;
        final matchedPoints = coordinates
            .map<LatLng>(
              (coord) => LatLng(
                (coord[1] as num).toDouble(),
                (coord[0] as num).toDouble(),
              ),
            )
            .toList();

        final distanceKm = (matching['distance'] as num).toDouble() / 1000;
        final durationMinutes = (matching['duration'] as num).toDouble() / 60;

        return RouteEntity(
          id: 'match_${points.hashCode}',
          points: matchedPoints,
          distanceKm: distanceKm,
          durationMinutes: durationMinutes,
        );
      }
      throw Exception('OSRM match failed');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Mất kết nối internet, vui lòng thử lại ');
      }
      throw Exception('Không thể tìm đường đi, vui lòng thử lại');
    }
  }
}
