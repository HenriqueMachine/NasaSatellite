import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_satellite/presentation/usecase/increment_month_usecase.dart';

void main() {
  group('IncrementMonthUseCase', () {
    final useCase = IncrementMonthUseCase();

    test('should increment month within the same year', () {
      // Arrange
      const batchYearStart = 2023;
      const batchYearEnd = 2023;
      const batchMonthStart = 1;
      const batchMonthEnd = 2;

      // Act
      final updatedDates = useCase.incrementMonth(
          batchYearStart, batchYearEnd, batchMonthStart, batchMonthEnd);

      // Assert
      expect(updatedDates, [2023, 2023, 2, 3]);
    });

    test('should increment month and change year if necessary', () {
      // Arrange
      const batchYearStart = 2023;
      const batchYearEnd = 2023;
      const batchMonthStart = 12;
      const batchMonthEnd = 12;

      // Act
      final updatedDates = useCase.incrementMonth(
          batchYearStart, batchYearEnd, batchMonthStart, batchMonthEnd);

      // Assert
      expect(updatedDates, [2023, 2024, 12, 1]);
    });


    test('should handle year change correctly when reaching December', () {
      // Arrange
      const batchYearStart = 2023;
      const batchYearEnd = 2023;
      const batchMonthStart = 12;
      const batchMonthEnd = 12;

      // Act
      final updatedDates = useCase.incrementMonth(
          batchYearStart, batchYearEnd, batchMonthStart, batchMonthEnd);

      // Assert
      expect(updatedDates, [2023, 2024, 12, 1]);
    });

    test('should maintain difference of 1 month between start and end', () {
      // Arrange
      const batchYearStart = 2024;
      const batchYearEnd = 2025;
      const batchMonthStart = 11;
      const batchMonthEnd = 12;

      // Act
      final updatedDates = useCase.incrementMonth(
          batchYearStart, batchYearEnd, batchMonthStart, batchMonthEnd);

      // Assert
      expect(updatedDates, [2025, 2026, 12, 1]);
    });
  });
}
