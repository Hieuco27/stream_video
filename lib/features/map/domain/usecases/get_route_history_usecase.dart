import 'package:stream_video/features/map/domain/entities/route_history_point.dart';
import 'package:stream_video/features/map/domain/repositories/route_repository.dart';

class GetRouteHistoryUseCase {
  final RouteRepository repository;

  GetRouteHistoryUseCase(this.repository);

  Future<List<RouteHistoryPoint>> call(
    String vehicleId,
    DateTime from,
    DateTime to,
  ) {
    return repository.getRouteHistory(vehicleId, from, to);
  }
}
