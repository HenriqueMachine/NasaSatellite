import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_satellite/presentation/widgets/card_tile_item.dart';

import '../../core/state_view.dart';
import '../../domain/nasa_planetary_view_object.dart';
import '../cubits/nasa_planetary_photo_cubit.dart';

class PhotoListPage extends StatefulWidget {
  const PhotoListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PhotoListPage> createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NasaPlanetaryPhotoCubit>().getPlanetaryList();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
      ),
      body: BlocBuilder<NasaPlanetaryPhotoCubit,
          StateView<List<NasaPlanetaryViewObject>>>(
        builder: (context, state) {
          switch (state.status) {
            case StateViewStatus.loading:
              return Container(
                color: Colors.transparent,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case StateViewStatus.success:
              final List<NasaPlanetaryViewObject> photos = state.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: _filterList,
                      decoration: InputDecoration(
                        hintText: 'Search photo...',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterList('');
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => context
                            .read<NasaPlanetaryPhotoCubit>()
                            .getPlanetaryList(),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          controller: _scrollController,
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            final photo = photos[index];
                            return CardTileItem(
                              imageUrl: photo.url ?? "",
                              title: photo.title ?? "",
                              date: photo.date ?? "",
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<NasaPlanetaryPhotoCubit>().incrementMonth();
    }
  }

  void _filterList(String query) {
    if (query.isNotEmpty) {
      context.read<NasaPlanetaryPhotoCubit>().filterList(query);
    }
    setState(() {
      // _filteredItems.clear();
      // _filteredItems.addAll(filteredList);
    });
  }
}
