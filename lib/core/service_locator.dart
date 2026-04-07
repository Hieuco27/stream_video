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
import '../features/map/domain/usecases/get_route_history_usecase.dart';
import '../services/location_service.dart';
import '../services/directions_service.dart';
import '../services/geocoding_service.dart';
import '../features/map/domain/usecases/reverse_geocode_usecase.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/domain/usecases/sign_in_usecase.dart';
import '../features/auth/domain/usecases/sign_out_usecase.dart';
import '../features/auth/domain/usecases/change_passwword_usecase.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/remember_me_ussecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/profile/presentation/bloc/settings/settings_repository.dart';
import '../features/profile/presentation/bloc/settings/settings_bloc.dart';

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

  // ---------Auth feature---------
  // Data source
  late final AuthRemoteDataSource authRemoteDataSource = AuthRemoteDataSource();

  // Repositories
  late final AuthRepository authRepository = AuthRepositoryImpl();

  // Use cases
  late final GetVehiclesUseCase getVehiclesUseCase = GetVehiclesUseCase(
    vehicleRepository,
  );
  late final GetCurrentLocationUseCase getCurrentLocationUseCase =
      GetCurrentLocationUseCase(locationRepository);
  late final StreamVehicleUpdatesUseCase streamVehicleUpdatesUseCase =
      StreamVehicleUpdatesUseCase(vehicleRepository);
  late final GetRouteUseCase getRouteUseCase = GetRouteUseCase(routeRepository);

  late final GetRouteHistoryUseCase getRouteHistoryUseCase =
      GetRouteHistoryUseCase(routeRepository);

  late final NominatimService nominatimService = NominatimService();

  late final ReverseGeocodeUseCase reverseGeocodeUseCase =
      ReverseGeocodeUseCase(nominatimService);

  late final SignInUseCase signInUseCase = SignInUseCase(authRepository);
  late final SignOutUseCase signOutUseCase = SignOutUseCase(authRepository);
  late final ChangePasswordUseCase changePasswordUseCase =
      ChangePasswordUseCase(authRepository);
  late final GetCurrentUserUseCase getCurrentUserUseCase =
      GetCurrentUserUseCase(authRepository);
  late final RememberMeUseCase rememberMeUseCase = RememberMeUseCase(
    authRepository,
  );

  // ---------Settings feature---------
  late final SettingsRepository settingsRepository = SettingsRepository();
  late final SettingsBloc settingsBloc = SettingsBloc(
    repository: settingsRepository,
  );
}

/// Truy cập nhanh ServiceLocator
final sl = ServiceLocator();
