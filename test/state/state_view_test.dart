import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_satellite/core/error_message.dart';
import 'package:nasa_satellite/core/state_view.dart';

void main() {
  group('StateView', () {
    test('loading state has correct status', () {
      final stateView = StateView.loading();
      expect(stateView.status, equals(StateViewStatus.loading));
    });

    test('success state has correct status and data', () {
      const testData = 'Test data';
      final stateView = StateView.success(testData);
      expect(stateView.status, equals(StateViewStatus.success));
      expect(stateView.data, equals(testData));
    });

    test('error state has correct status and error message', () {
      const errorMessage = 'Test error message';
      final stateView = StateView.error(error: errorMessage);
      expect(stateView.status, equals(StateViewStatus.error));
      expect(stateView.error, equals(errorMessage));
    });

    test('error state has default error message if none provided', () {
      final stateView = StateView.error();
      expect(stateView.status, equals(StateViewStatus.error));
      expect(stateView.error, equals(ErrorMessage.messageGenericError));
    });
  });
}
