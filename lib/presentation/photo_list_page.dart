import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/stateview.dart';
import '../domain/nasa_planetary_view_object.dart';
import 'nasa_planetary_photo_cubit.dart';

class PhotoListPage extends StatefulWidget {
  const PhotoListPage({super.key, required this.title});

  final String title;

  @override
  State<PhotoListPage> createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<NasaPlanetaryPhotoCubit,
          StateView<List<NasaPlanetaryViewObject>>>(
        builder: (context, state) {
          switch (state.status) {
            case StateViewStatus.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case StateViewStatus.success:
              final List<NasaPlanetaryViewObject> photos = state.data!;
              return ListView.builder(
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return ListTile(
                    title: Text(photo.title ?? ""),
                    subtitle: Text(photo.date ?? ""),
                  );
                },
              );
            case StateViewStatus.error:
              final String errorMessage = state.error!;
              return Center(
                child: Text(errorMessage),
              );
            default:
              return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<NasaPlanetaryPhotoCubit>().getPlanetaryList();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}