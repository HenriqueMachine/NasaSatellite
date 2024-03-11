import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_satellite/core/dimens.dart';
import 'package:nasa_satellite/core/error_message.dart';
import 'package:nasa_satellite/core/hint_message.dart';
import 'package:nasa_satellite/presentation/widgets/card_tile_item.dart';

import '../../core/state_view.dart';
import '../../domain/nasa_planetary_view_object.dart';
import '../cubits/nasa_planetary_photo_cubit.dart';
import '../routes.dart';

class PhotoListPage extends StatefulWidget {
  const PhotoListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PhotoListPage> createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<NasaPlanetaryViewObject> _photos = [];

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
              return caseLoading();
            case StateViewStatus.success:
              return caseSuccess(state, context);
            case StateViewStatus.error:
              return caseError(state);
            default:
              return Container();
          }
        },
      ),
    );
  }

  Widget caseLoading() {
    return Container(
      color: Colors.transparent,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget caseError(StateView<List<NasaPlanetaryViewObject>> state) {
    final String errorMessage = state.error!;
    return Center(
      child: Text(errorMessage),
    );
  }

  Widget caseSuccess(
      StateView<List<NasaPlanetaryViewObject>> state, BuildContext context) {
    _photos = state.data!;
    return Padding(
      padding: const EdgeInsets.all(Dimensions.dimenDouble16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _filterList,
            decoration: InputDecoration(
              hintText: HintMessage.searchPhoto,
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _filterList("");
                },
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  context.read<NasaPlanetaryPhotoCubit>().getPlanetaryList(),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Dimensions.dimenInt2,
                  crossAxisSpacing: Dimensions.dimenDouble8,
                  mainAxisSpacing: Dimensions.dimenDouble8,
                ),
                controller: _scrollController,
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                  final photo = _photos[index];
                  return CardTileItem(
                    imageUrl: photo.url ?? ErrorMessage.failToRecoverURL,
                    title: photo.title ?? ErrorMessage.failToRecoverTitle,
                    date: photo.date ?? ErrorMessage.failToRecoverDate,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.photoDetail,
                        arguments: photo,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<NasaPlanetaryPhotoCubit>().incrementMonth();
    }
  }

  void _filterList(String query) {
    context.read<NasaPlanetaryPhotoCubit>().filterList(query);
  }
}
