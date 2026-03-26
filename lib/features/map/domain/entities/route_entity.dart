import 'package:latlong2/latlong.dart';

class RouteEntity {
  final String id;
  final List<LatLng> points;
  final double distanceKm;
  final double durationMinutes;

  RouteEntity({
    required this.id,
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
  });
}
