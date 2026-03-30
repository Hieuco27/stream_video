import 'package:dio/dio.dart';
import 'failure.dart';


class DioFailureMapper {
  static Failure map(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Kết nối quá thời gian chờ');

      case DioExceptionType.connectionError:
        return const NetworkFailure(message: 'Không thể kết nối đến server');

      case DioExceptionType.badResponse:
        return _mapStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return const NetworkFailure(message: 'Yêu cầu đã bị hủy');

      default:
        return UnexpectedFailure(message: error.message ?? 'Lỗi không xác định');
    }
  }

  static Failure _mapStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const ServerFailure(message: 'Yêu cầu không hợp lệ', code: 400);
      case 401:
        return const AuthFailure(message: 'Chưa xác thực, vui lòng đăng nhập lại', code: 401);
      case 403:
        return const AuthFailure(message: 'Không có quyền truy cập', code: 403);
      case 404:
        return const ServerFailure(message: 'Không tìm thấy tài nguyên', code: 404);
      case 500:
        return const ServerFailure(message: 'Lỗi nội bộ server', code: 500);
      default:
        return ServerFailure(message: 'Lỗi server: $statusCode', code: statusCode);
    }
  }
}
