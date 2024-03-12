import 'package:nasa_satellite/domain/nasa_planetary_view_object.dart';

class FilterPhotosUseCase {
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
