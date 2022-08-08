import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediaserver/config/config.dart';
import 'package:mediaserver/data/models/album_info.dart';
import 'package:mediaserver/logic/blocs/multi_media/multi_media_bloc.dart';
import 'package:mediaserver/logic/cubits/navigation/navigation_cubit.dart';
import 'package:mediaserver/presentation/screens/album/widgets/ms_album_preview.dart';

import '../../../data/data.dart';
import '../../../logic/blocs/album/album_bloc.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AlbumBloc>(context).add(FetchAlbumInfos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        if (state is AlbumInfosLoaded) {
          return Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 50.0,
                  spacing: 50.0,
                  children: state.albumInfos
                      .map(
                        (e) => InkWell(
                          child: MSAlbumPreview(e),
                          onTap: () {
                            Search search = Search();
                            search.albums = [e.name];
                            BlocProvider.of<MultiMediaBloc>(context)
                                .add(SearchMedia(search));
                            BlocProvider.of<NavigationCubit>(context)
                                .navigateTo(Routes.gallery);
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
