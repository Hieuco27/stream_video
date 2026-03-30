import 'failure.dart';


sealed class Result<T> {
  const Result();

  /// Tạo Result thành công
  factory Result.success(T data) = Success<T>;

  /// Tạo Result thất bại
  factory Result.error(Failure failure) = Error<T>;

  /// Pattern matching — xử lý cả 2 trường hợp
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) {
    final self = this;
    if (self is Success<T>) {
      return success(self.data);
    } else if (self is Error<T>) {
      return error(self.failure);
    }
    throw StateError('Unreachable');
  }


  /// Kiểm tra nhanh
  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  /// Lấy data (null nếu error)
  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;

  /// Lấy failure (null nếu success)
  Failure? get failureOrNull =>
      this is Error<T> ? (this as Error<T>).failure : null;
}

/// Kết quả thành công
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Kết quả thất bại
class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}
