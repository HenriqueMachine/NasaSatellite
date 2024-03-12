import 'package:nasa_satellite/domain/nasa_planetary_view_object.dart';

/// Class responsible for filtering a list of [NasaPlanetaryViewObject] objects.
class FilterPhotosUseCase {
  /// Filters the list of [NasaPlanetaryViewObject] objects based on a query filter.
  ///
  /// Receives [viewObjectList] the list of objects to be filtered and [queryFilter] the query string for filtering.
  /// Returns a filtered list of [NasaPlanetaryViewObject] objects based on the [queryFilter].
  List<NasaPlanetaryViewObject> filterList(
      List<NasaPlanetaryViewObject> viewObjectList, String queryFilter) {
    if (queryFilter.isNotEmpty) {
      final String normalizeQuery = queryFilter.toLowerCase();
      final List<NasaPlanetaryViewObject> filteredList = viewObjectList
          .where((photo) =>
              photo.title!.toLowerCase().contains(normalizeQuery) ||
              photo.date!.toLowerCase().contains(normalizeQuery))
          .toList();
      return filteredList;
    } else {
      return viewObjectList;
    }
  }
}
