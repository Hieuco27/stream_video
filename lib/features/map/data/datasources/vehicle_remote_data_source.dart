import 'package:dio/dio.dart';
import 'dart:convert';
import '../models/vehicle_model.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleModel>> getInitialVehicles(String token);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final Dio dio;
  final String baseUrl = "http://nganluc.bodam3g.com/Online";

  VehicleRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<VehicleModel>> getInitialVehicles(String token) async {
    try {
      final response = await dio.get(
        "$baseUrl/GetOnlineDevices",
        queryParameters: {"token": token},
      );

      if (response.statusCode == 200) {
        final dynamic rawData = response.data;
        final List<dynamic> data = rawData is String
            ? jsonDecode(rawData)
            : rawData;
        return data.map((json) => VehicleModel.fromJson(json)).toList();
      } else {
        throw Exception("Server status error: ${response.statusCode}");
      }
    } catch (e) {
      print("Network error: $e");
      rethrow;
    }
  }
}
