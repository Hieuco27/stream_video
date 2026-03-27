import 'package:stream_video/features/map/domain/entities/route_entity.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/features/map/domain/entities/route_history_point.dart';

abstract class RouteRepository {
  Future<RouteEntity> getRoute(LatLng origin, LatLng destination);
  Future<List<RouteHistoryPoint>> getRouteHistory(
    String vehicleId,
    DateTime from,
    DateTime to,
  );
  Future<RouteEntity> matchRoute(List<LatLng> points);
}
