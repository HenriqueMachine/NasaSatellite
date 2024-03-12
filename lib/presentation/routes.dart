import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_satellite/presentation/cubits/nasa_planetary_photo_cubit.dart';
import 'package:nasa_satellite/presentation/pages/photo_detail_page.dart';
import 'package:nasa_satellite/presentation/pages/photo_list_page.dart';
import 'package:http/http.dart' as http;

import '../domain/nasa_planetary_view_object.dart';

class Routes {
  static const String photosList = '/photosList';
  static const String photoDetail = '/photoDetail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final http.Client httpClient = http.Client();

    switch (settings.name) {
      case photosList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => NasaPlanetaryPhotoCubit.create(httpClient),
            child: const PhotoListPage(title: "Nasa List"),
          ),
        );
      case photoDetail:
        final photo = settings.arguments as NasaPlanetaryViewObject;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => NasaPlanetaryPhotoCubit.create(httpClient),
            child: PhotoDetailPage(photo: photo),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Fail to find: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
