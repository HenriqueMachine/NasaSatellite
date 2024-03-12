import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_satellite/domain/nasa_planetary_view_object.dart';
import 'package:nasa_satellite/presentation/usecase/filter_photo_usecase.dart';

void main() {
  group('FilterPhotosUseCase', () {
    final useCase = FilterPhotosUseCase();

    test('should return original list when query filter is empty', () {
      // Arrange
      final viewObjectList = [
        NasaPlanetaryViewObject(title: 'Planet 1', date: '1999-01-01'),
        NasaPlanetaryViewObject(title: 'Planet 2', date: '1999-02-01'),
      ];
      const queryFilter = '';

      // Act
      final filteredList = useCase.filterList(viewObjectList, queryFilter);

      // Assert
      expect(filteredList, viewObjectList);
    });

    test('should filter list by title or date', () {
      // Arrange
      final viewObjectList = [
        NasaPlanetaryViewObject(title: 'Planet 1', date: '1999-01-01'),
      ];
      const queryFilter = 'planet';

      // Act
      final filteredList = useCase.filterList(viewObjectList, queryFilter);

      // Assert
      expect(filteredList.length, 1);
      expect(filteredList.first.title, 'Planet 1');
    });

    test('should filter list case insensitively', () {
      // Arrange
      final viewObjectList = [
        NasaPlanetaryViewObject(title: 'Planet 1', date: '1999-01-01'),
        NasaPlanetaryViewObject(title: 'Planet 2', date: '1999-02-01'),
      ];
      const queryFilter = 'PLANET';

      // Act
      final filteredList = useCase.filterList(viewObjectList, queryFilter);

      // Assert
      expect(filteredList.length, 2);
    });
  });
}
