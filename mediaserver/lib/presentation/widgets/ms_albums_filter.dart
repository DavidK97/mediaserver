import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/blocs/album/album_bloc.dart';

class MSAlbumsFilter extends StatefulWidget {
  final String input;
  final Function(String album) onAddAlbum;
  final Function(String album) onRemoveAlbum;
  final List<String> selectedAlbums;

  const MSAlbumsFilter(this.input,
      {required this.onAddAlbum,
      required this.onRemoveAlbum,
      required this.selectedAlbums,
      Key? key})
      : super(key: key);

  @override
  State<MSAlbumsFilter> createState() => _MSAlbumsFilterState();
}

class _MSAlbumsFilterState extends State<MSAlbumsFilter> {
  late List<String> selectedAlbums = widget.selectedAlbums;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AlbumBloc>(context).add(FetchAlbums());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: ((context, state) {
        if (state is AlbumsLoaded) {
          List<String> filteredAlbums = state.albums
              .where((element) => element.startsWith(widget.input))
              .where((element) => !selectedAlbums.contains(element))
              .take(10)
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Auswahl'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: selectedAlbums
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: InputChip(
                            avatar: const Icon(Icons.remove),
                            label: Text(e),
                            onSelected: (val) => widget.onRemoveAlbum.call(e),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const Text('Vorschläge'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filteredAlbums
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: InputChip(
                            avatar: const Icon(Icons.add),
                            label: Text(e),
                            onSelected: (val) => widget.onAddAlbum.call(e),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
