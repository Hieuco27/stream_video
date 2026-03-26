import 'package:dio/dio.dart';
import '../features/map/data/datasources/vehicle_remote_data_source.dart';
import '../features/map/data/repositories/vehicle_repository_impl.dart';
import '../features/map/data/repositories/location_repository_impl.dart';
import '../features/map/data/repositories/route_repository_impl.dart';
import '../features/map/domain/repositories/location_repository.dart';
import '../features/map/domain/repositories/vehicle_repository.dart';
import '../features/map/domain/repositories/route_repository.dart';
import '../features/map/domain/usecases/get_vehicles_usecase.dart';
import '../features/map/domain/usecases/stream_vehicle_updates_usecase.dart';
import '../features/map/domain/usecases/get_current_location_usecase.dart';
import '../features/map/domain/usecases/get_route_usecase.dart';
import '../services/location_service.dart';
import '../services/directions_service.dart';
import '../services/geocoding_service.dart';
import '../features/map/domain/usecases/reverse_geocode_usecase.dart';

/// Quản lý tất cả dependencies của app.
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Network
  late final Dio dio = Dio();
  late final VehicleRemoteDataSourceImpl vehicleRemoteDataSource =
      VehicleRemoteDataSourceImpl(dio: dio);

  // ---------Map feature---------
  // Services (infrastructure)
  late final LocationService locationService = LocationService();
  late final DirectionsService directionsService = DirectionsService(dio: dio);

  // Repositories
  late final VehicleRepository vehicleRepository = VehicleRepositoryImpl(
    remoteDataSource: vehicleRemoteDataSource,
  );
  late final LocationRepository locationRepository = LocationRepositoryImpl(
    locationService: locationService,
  );
  late final RouteRepository routeRepository = RouteRepositoryImpl(
    directionsService: directionsService,
  );

  // Use cases
  late final GetVehiclesUseCase getVehiclesUseCase = GetVehiclesUseCase(
    vehicleRepository,
  );
  late final GetCurrentLocationUseCase getCurrentLocationUseCase =
      GetCurrentLocationUseCase(locationRepository);
  late final StreamVehicleUpdatesUseCase streamVehicleUpdatesUseCase =
      StreamVehicleUpdatesUseCase(vehicleRepository);
  late final GetRouteUseCase getRouteUseCase = GetRouteUseCase(routeRepository);
  late final GeocodingService geocodingService = GeocodingService();
  late final ReverseGeocodeUseCase reverseGeocodeUseCase =
      ReverseGeocodeUseCase(geocodingService);
}

/// Truy cập nhanh ServiceLocator
final sl = ServiceLocator();
