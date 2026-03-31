import 'package:stream_video/features/map/domain/entities/route_history_point.dart';
import 'package:stream_video/features/map/domain/repositories/route_repository.dart';
import 'package:stream_video/core/errors/result.dart';

class GetRouteHistoryUseCase {
  final RouteRepository repository;

  GetRouteHistoryUseCase(this.repository);

  Future<Result<List<RouteHistoryPoint>>> call(
    String vehicleId,
    DateTime from,
    DateTime to,
  ) {
    return repository.getRouteHistory(vehicleId, from, to);
  }
}
