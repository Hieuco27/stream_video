import 'package:stream_video/features/map/domain/entities/route_entity.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_video/features/map/domain/entities/route_history_point.dart';
import '../../../../core/errors/result.dart';

abstract class RouteRepository {
  Future<Result<RouteEntity>> getRoute(LatLng origin, LatLng destination);
  Future<Result<List<RouteHistoryPoint>>> getRouteHistory(
    String vehicleId,
    DateTime from,
    DateTime to,
  );
  Future<Result<RouteEntity>> matchRoute(List<LatLng> points);
}
