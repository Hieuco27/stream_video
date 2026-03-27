import 'package:latlong2/latlong.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/route_repository.dart';
import '../../../../services/directions_service.dart';
import '../../domain/entities/route_history_point.dart';
import '../models/mock_route_history.dart';

class RouteRepositoryImpl implements RouteRepository {
  final DirectionsService directionsService;

  RouteRepositoryImpl({required this.directionsService});

  @override
  Future<RouteEntity> getRoute(LatLng origin, LatLng destination) {
    return directionsService.getRoute(origin, destination);
  }

  @override
  Future<List<RouteHistoryPoint>> getRouteHistory(
    String vehicleId,
    DateTime from,
    DateTime to,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockRouteHistory;
  }

  @override
  Future<RouteEntity> matchRoute(List<LatLng> points) {
    return directionsService.matchRoute(points);
  }
}
