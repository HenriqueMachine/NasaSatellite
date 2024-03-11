import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_satellite/nasa_planetary_photo_cubit.dart';
import 'package:nasa_satellite/nasa_planetary_view_object.dart';
import 'package:nasa_satellite/stateview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => NasaPlanetaryPhotoCubit.create(),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
