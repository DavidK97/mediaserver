import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediaserver/config/config.dart';
import 'package:mediaserver/data/data.dart';
import 'package:mediaserver/logic/blocs/album/album_bloc.dart';
import 'package:mediaserver/logic/blocs/creator/creator_bloc.dart';
import 'package:mediaserver/logic/blocs/manage_media/manage_media_bloc.dart';
import 'package:mediaserver/logic/blocs/media/media_bloc.dart';
import 'package:mediaserver/logic/blocs/multi_media/multi_media_bloc.dart';
import 'package:mediaserver/logic/blocs/tag/tag_bloc.dart';
import 'package:mediaserver/logic/cubits/menu/menu_cubit.dart';
import 'package:mediaserver/logic/cubits/navigation/navigation_cubit.dart';
import 'package:mediaserver/presentation/pages/login/login.dart';
import 'package:mediaserver/presentation/pages/media/media.dart';

import '../../presentation/pages/home/home.dart';

class RouteGenerator {
  RouteGenerator._();
  static final MediaRepository _mediaRepository = MediaRepository();
  static final AlbumRepository _albumRepository = AlbumRepository();
  static final TagRepository _tagRepository = TagRepository();
  static final CreatorRepository _creatorRepository = CreatorRepository();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => MultiMediaBloc(_mediaRepository)),
              BlocProvider(
                  create: (_) => TagBloc(_tagRepository)..add(FetchTags())),
              BlocProvider(
                  create: (_) =>
                      CreatorBloc(_creatorRepository)..add(FetchCreators())),
              BlocProvider(create: (_) => AlbumBloc(_albumRepository)),
              BlocProvider(create: (_) => NavigationCubit())
            ],
            child: const HomePage(),
          ),
        );
      case Routes.login:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case Routes.media:
        List<dynamic> args = settings.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => MenuCubit()),
                    BlocProvider(create: (_) => MediaBloc(_mediaRepository)),
                    BlocProvider(
                        create: (_) =>
                            ManageMediaBloc(_mediaRepository, _albumRepository))
                  ],
                  child: MediaPage(
                      media: args[0] as List<Media>,
                      selectedIndex: args[1] as int),
                ));
      default:
        return MaterialPageRoute(builder: (context) => LoginPage());
    }
  }
}
