import 'failure.dart';

sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;

  factory Result.error(Failure failure) = Error<T>;

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

  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;

  Failure? get failureOrNull =>
      this is Error<T> ? (this as Error<T>).failure : null;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}
