/// Use case responsible for incrementing the month range.
class IncrementMonthUseCase {
  /// Increments the month range based on the provided batch year and month values.
  ///
  /// Returns a list of integers representing the updated batch year and month range.
  List<int> incrementMonth(int batchYearStart, int batchYearEnd,
      int batchMonthStart, int batchMonthEnd) {
    batchMonthEnd++;
    if (batchMonthEnd > 12) {
      batchMonthEnd = 1;
      batchYearEnd++;
    }

    batchMonthStart = (batchMonthEnd == 1) ? 12 : batchMonthEnd - 1;
    batchYearStart = (batchMonthEnd == 1) ? batchYearEnd - 1 : batchYearStart;

    return [batchYearStart, batchYearEnd, batchMonthStart, batchMonthEnd];
  }
}
