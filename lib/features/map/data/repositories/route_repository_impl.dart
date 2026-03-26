import 'package:latlong2/latlong.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/route_repository.dart';
import '../../../../services/directions_service.dart';

class RouteRepositoryImpl implements RouteRepository {
  final DirectionsService directionsService;

  RouteRepositoryImpl({required this.directionsService});

  @override
  Future<RouteEntity> getRoute(LatLng origin, LatLng destination) {
    return directionsService.getRoute(origin, destination);
  }
}
