import 'package:nasa_satellite/core/error_message.dart';

class HttpResponse<T> {
  final T? data;
  final String? errorMessage;
  final int? statusCode;

  HttpResponse({
    this.data,
    this.errorMessage,
    this.statusCode,
  });

  void handleRequest({
    required Function(T data) onSuccess,
    required Function(String errorMessage) onError,
  }) {
    if (data != null) {
      onSuccess(data as T);
    } else {
      onError(errorMessage.toString());
    }
  }

  void handleStatusCode({
    required Function(T data) on200,
    required Function(String errorMessage) on400,
    Map<int, Function(T data)>? handlers,
    required Function(String errorMessage) unknownError,
  }) {
    switch (statusCode) {
      case 200:
        on200(data as T);
        break;
      case 400:
        on400(errorMessage.toString());
        break;
      default:
        if (handlers != null && handlers.containsKey(statusCode)) {
          handlers[statusCode!]!(data as T);
        } else {
          unknownError(ErrorMessage.messageGenericRequestError);
        }
    }
  }
}
