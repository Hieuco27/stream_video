import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/route_repository.dart';
import '../../../../services/directions_service.dart';
import '../../domain/entities/route_history_point.dart';
import '../models/mock_route_history.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/dio_failure_mapper.dart';

class RouteRepositoryImpl implements RouteRepository {
  final DirectionsService directionsService;

  RouteRepositoryImpl({required this.directionsService});

  @override
  Future<Result<RouteEntity>> getRoute(
    LatLng origin,
    LatLng destination,
  ) async {
    try {
      final route = await directionsService.getRoute(origin, destination);
      return Result.success(route);
    } on DioException catch (e) {
      return Result.error(DioFailureMapper.map(e));
    } catch (e) {
      return Result.error(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<RouteHistoryPoint>>> getRouteHistory(
    String vehicleId,
    DateTime from,
    DateTime to,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return Result.success(mockRouteHistory);
    } catch (e) {
      return Result.error(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<RouteEntity>> matchRoute(List<LatLng> points) async {
    try {
      final route = await directionsService.matchRoute(points);
      return Result.success(route);
    } on DioException catch (e) {
      return Result.error(DioFailureMapper.map(e));
    } catch (e) {
      return Result.error(NetworkFailure(message: e.toString()));
    }
  }
}
