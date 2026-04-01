import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Lỗi server, vui lòng thử lại sau',
    super.code,
  });
}

/// Lỗi mạng (không có internet, timeout...)
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Không có kết nối mạng', super.code});
}

/// Lỗi xác thực (token hết hạn, sai tài khoản...)
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Phiên đăng nhập hết hạn', super.code});
}

/// Lỗi dữ liệu local (cache, database...)
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Lỗi đọc dữ liệu cục bộ', super.code});
}

/// Lỗi GPS/Location
class LocationFailure extends Failure {
  const LocationFailure({super.message = 'Không thể lấy vị trí', super.code});
}

/// Lỗi không xác định
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'Đã xảy ra lỗi', super.code});
}
