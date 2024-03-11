import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_satellite/presentation/cubits/nasa_planetary_photo_cubit.dart';
import 'package:nasa_satellite/presentation/pages/photo_detail_page.dart';
import 'package:nasa_satellite/presentation/pages/photo_list_page.dart';

class Routes {
  static const String photosList = '/photosList';
  static const String photoDetail = '/photoDetail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case photosList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => NasaPlanetaryPhotoCubit.create(),
            child: const PhotoListPage(title: "Nasa List"),
          ),
        );
      case photoDetail:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => NasaPlanetaryPhotoCubit.create(),
            child: const PhotoDetailPage(),
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