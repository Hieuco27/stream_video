import 'package:latlong2/latlong.dart';
import 'package:stream_video/features/map/domain/entities/route_entity.dart';
import 'package:stream_video/features/map/domain/repositories/route_repository.dart';

class GetRouteUseCase {
  final RouteRepository repository;

  GetRouteUseCase(this.repository);

  Future<RouteEntity> call(LatLng origin, LatLng destination) {
    return repository.getRoute(origin, destination);
  }
}
