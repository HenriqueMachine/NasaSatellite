import 'package:nasa_satellite/error_message.dart';

enum StateViewStatus { loading, success, error }

class StateView<T> {
  final StateViewStatus status;
  final T? data;
  final String? error;

  StateView({required this.status, this.data, this.error});

  factory StateView.loading() => StateView(status: StateViewStatus.loading);

  factory StateView.success(T data) =>
      StateView(status: StateViewStatus.success, data: data);

  factory StateView.error({String error = ErrorMessage.messageGenericError}) =>
      StateView(status: StateViewStatus.error, error: error);
}
