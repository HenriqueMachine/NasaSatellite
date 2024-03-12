import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_satellite/core/error_message.dart';
import 'package:nasa_satellite/core/http_response.dart';

void main() {
  group('HttpResponse', () {
    test('handleRequest calls onSuccess if data is not null', () {
      const testData = 'test data';
      bool onSuccessCalled = false;

      final httpResponse = HttpResponse<String>(data: testData);

      httpResponse.handleRequest(
        onSuccess: (data) {
          onSuccessCalled = true;
          expect(data, equals(testData));
        },
        onError: (errorMessage) {
          fail('onError should not have been called');
        },
      );

      expect(onSuccessCalled, isTrue);
    });

    test('handleRequest calls onError if data is null', () {
      bool onErrorCalled = false;

      final httpResponse = HttpResponse<String>(errorMessage: 'Test error');

      httpResponse.handleRequest(
        onSuccess: (data) {
          fail('onSuccess should not have been called');
        },
        onError: (errorMessage) {
          onErrorCalled = true;
          expect(errorMessage, equals('Test error'));
        },
      );

      expect(onErrorCalled, isTrue);
    });

    test('handleStatusCode calls on200 for status code 200', () {
      const testData = 'test data';
      bool on200Called = false;

      final httpResponse = HttpResponse<String>(data: testData, statusCode: 200);

      httpResponse.handleStatusCode(
        on200: (data) {
          on200Called = true;
          expect(data, equals(testData));
        },
        on400: (errorMessage) {
          fail('on400 should not have been called');
        },
        unknownError: (errorMessage) {
          fail('unknownError should not have been called');
        },
      );

      expect(on200Called, isTrue);
    });

    test('handleStatusCode calls on400 for status code 400', () {
      bool on400Called = false;

      final httpResponse = HttpResponse<String>(errorMessage: 'Test error', statusCode: 400);

      httpResponse.handleStatusCode(
        on200: (data) {
          fail('on200 should not have been called');
        },
        on400: (errorMessage) {
          on400Called = true;
          expect(errorMessage, equals('Test error'));
        },
        unknownError: (errorMessage) {
          fail('unknownError should not have been called');
        },
      );

      expect(on400Called, isTrue);
    });

    test('handleStatusCode calls unknownError for unknown status codes', () {
      bool unknownErrorCalled = false;

      final httpResponse = HttpResponse<String>(statusCode: 500);

      httpResponse.handleStatusCode(
        on200: (data) {
          fail('on200 should not have been called');
        },
        on400: (errorMessage) {
          fail('on400 should not have been called');
        },
        unknownError: (errorMessage) {
          unknownErrorCalled = true;
          expect(errorMessage, equals(ErrorMessage.messageGenericRequestError));
        },
      );

      expect(unknownErrorCalled, isTrue);
    });
  });
}
