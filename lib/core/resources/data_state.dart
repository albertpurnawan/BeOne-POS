import 'package:dio/dio.dart';

abstract class DataState<T> {
  const DataState({this.data, this.exception});

  final T? data;
  final DioException? exception;
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(DioException exception) : super(exception: exception);
}
