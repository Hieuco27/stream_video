import 'package:stream_video/features/map/domain/entities/route_entity.dart';
import 'package:latlong2/latlong.dart';

abstract class RouteRepository {
  Future<RouteEntity> getRoute(LatLng origin, LatLng destination);
}
