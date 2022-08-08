import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediaserver/config/config.dart';
import 'package:mediaserver/data/data.dart';
import 'package:mediaserver/logic/blocs/multi_media/multi_media_bloc.dart';
import 'package:mediaserver/logic/cubits/navigation/navigation_cubit.dart';
import 'package:mediaserver/presentation/widgets/ms_albums_filter.dart';
import 'package:mediaserver/presentation/widgets/ms_creators_filter.dart';
import 'package:mediaserver/presentation/widgets/ms_tags_filter.dart';

import '../../../logic/blocs/album/album_bloc.dart';
import '../../../logic/blocs/creator/creator_bloc.dart';
import '../../../logic/blocs/tag/tag_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Search search = Search();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _creatorController = TextEditingController();
  final TextEditingController _albumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: 'Filter Tags...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.all(0),
              ),
              controller: _tagController,
              onChanged: (val) {
                setState(() {});
              },
            ),
            const SizedBox(
              height: 10,
            ),
            BlocProvider(
              create: (context) => TagBloc(TagRepository()),
              child: MSTagsFilter(
                _tagController.text,
                onAddTag: (tag) => setState(() => search.tags.add(tag)),
                onRemoveTag: (tag) => setState(() => search.tags.remove(tag)),
                selectedTags: search.tags,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: 'Filter Ersteller...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.all(0),
              ),
              controller: _creatorController,
            ),
            const SizedBox(
              height: 10,
            ),
            BlocProvider(
              create: (context) => CreatorBloc(CreatorRepository()),
              child: MSCreatorsFilter(
                _creatorController.text,
                onAddCreator: (creator) =>
                    setState(() => search.creators.add(creator)),
                onRemoveCreator: (creator) =>
                    setState(() => search.creators.remove(creator)),
                selectedCreators: search.creators,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Filter Albums...',
                prefixIcon: Icon(Icons.search),
              ),
              controller: _albumController,
            ),
            const SizedBox(
              height: 10,
            ),
            BlocProvider(
              create: (context) => AlbumBloc(AlbumRepository()),
              child: MSAlbumsFilter(
                _albumController.text,
                onAddAlbum: (album) => setState(() => search.albums.add(album)),
                onRemoveAlbum: (album) =>
                    setState(() => search.albums.remove(album)),
                selectedAlbums: search.albums,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("Favoriten:"),
                Switch(
                  value: search.favorite,
                  onChanged: (val) =>
                      setState(() => search.favorite = !search.favorite),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<MultiMediaBloc>(context)
                    .add(SearchMedia(search));
                BlocProvider.of<NavigationCubit>(context)
                    .navigateTo(Routes.gallery);
              },
              child: const Text('Suchen'),
            ),
          ],
        ),
      ),
    );
  }
}
