import 'package:equatable/equatable.dart';

class VehicleInfoEntity extends Equatable {
  final String id;
  final String name; // tên lái xe
  final String plate; // biển số xe
  final String type; // loại xe

  const VehicleInfoEntity({
    required this.id,
    required this.name,
    required this.plate,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, plate, type];
}
