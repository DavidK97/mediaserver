import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediaserver/config/config.dart';
import 'package:mediaserver/logic/blocs/album/album_bloc.dart';
import 'package:mediaserver/logic/cubits/navigation/navigation_cubit.dart';
import 'package:mediaserver/presentation/pages/media/widgets/ms_expandable_fab.dart';
import 'package:mediaserver/presentation/presentation.dart';
import 'package:mediaserver/presentation/screens/creators/creators.dart';
import 'package:mediaserver/presentation/screens/tags/tags.dart';
import 'package:mediaserver/presentation/widgets/ms_bottom_navigation_bar.dart';

import '../../../logic/blocs/multi_media/multi_media_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GalleryScreen gallery = const GalleryScreen();
  final SearchScreen search = const SearchScreen();
  final CreatorsScreen creators = const CreatorsScreen();
  final TagsScreen tags = const TagsScreen();
  final AlbumScreen albums = const AlbumScreen();

  @override
  void initState() {
    BlocProvider.of<MultiMediaBloc>(context).add(FetchMediaIds());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, String>(builder: (context, state) {
      Widget screen;
      Widget? actionButton;

      switch (state) {
        case Routes.gallery:
          actionButton = ExpandableFab(distance: 100, children: [
            ActionButton(
              icon: const Icon(Icons.tag),
              onPressed: () => BlocProvider.of<NavigationCubit>(context)
                  .navigateTo(Routes.tags),
            ),
            ActionButton(
              icon: const Icon(Icons.person),
              onPressed: () => BlocProvider.of<NavigationCubit>(context)
                  .navigateTo(Routes.creators),
            ),
          ]);
          screen = gallery;
          break;
        case Routes.search:
          actionButton = null;
          screen = search;
          break;
        case Routes.creators:
          actionButton = null;
          screen = creators;
          break;
        case Routes.tags:
          actionButton = null;
          screen = tags;
          break;
        case Routes.album:
          actionButton = FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    final TextEditingController textFieldController =
                        TextEditingController();
                    return AlertDialog(
                      title: const Text('Album erstellen'),
                      content: TextField(
                        controller: textFieldController,
                        decoration: const InputDecoration(
                          hintText: "Name...",
                          prefixIcon: Icon(Icons.image),
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('Abbrechen'),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ElevatedButton(
                          child: Text('Ok'),
                          onPressed: () {
                            setState(() {
                              BlocProvider.of<AlbumBloc>(context)
                                  .add(AddAlbum(textFieldController.text));
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    );
                  });
            },
            child: const Icon(Icons.add),
          );
          screen = albums;
          break;
        default:
          actionButton = null;
          screen = gallery;
          break;
      }

      return WillPopScope(
        onWillPop: () {
          setState(() {
            context.read<MultiMediaBloc>().add(FetchMediaIds());
            context.read<NavigationCubit>().navigateTo(Routes.gallery);
          });
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Mediaserver'),
            actions: [
              IconButton(
                onPressed: () {
                  BlocProvider.of<MultiMediaBloc>(context)
                      .add(SynchronizeMedia());
                },
                icon: const Icon(Icons.sync_sharp),
              )
            ],
          ),
          body: screen,
          floatingActionButton: actionButton,
          bottomNavigationBar: const MSBottomNavigationBar(),
        ),
      );
    });
  }
}
