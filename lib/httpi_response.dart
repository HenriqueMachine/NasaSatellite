class HttpResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;
  final int? statusCode;

  HttpResponse({
    required this.success,
    this.data,
    this.errorMessage,
    this.statusCode,
  });

  void handleRequest({
    required Function(T data) onSuccess,
    required Function(String errorMessage) onError,
  }) {
    if (success) {
      if (data != null) {
        onSuccess(data as T);
      } else {
        onError('error to do request');
      }
    } else {
      onError(errorMessage ?? 'Unknown error');
    }
  }
}
