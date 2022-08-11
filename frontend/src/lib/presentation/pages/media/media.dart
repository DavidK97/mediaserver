import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediaserver/config/config.dart';
import 'package:mediaserver/logic/blocs/manage_media/manage_media_bloc.dart';
import 'package:mediaserver/logic/blocs/media/media_bloc.dart';
import 'package:mediaserver/logic/cubits/menu/menu_cubit.dart';
import 'package:mediaserver/presentation/pages/media/widgets/ms_edit_media_dialog.dart';
import 'package:mediaserver/presentation/pages/media/widgets/ms_menu_overlay.dart';

import '../../../data/models/media.dart';
import 'widgets/ms_video_player.dart';

class MediaPage extends StatefulWidget {
  final List<Media> media;
  final int selectedIndex;

  const MediaPage({required this.media, required this.selectedIndex, Key? key})
      : super(key: key);

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  late PageController _pageController;
  late List<Media> cachedMedia;
  late int _selectedIndex = widget.selectedIndex;
  bool _showInfo = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MediaBloc>(context)
        .add(FetchMedia(widget.media[_selectedIndex].id));
    _pageController = PageController(initialPage: widget.selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_showInfo) {
          setState(() {
            _showInfo = false;
          });
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: BlocListener<MenuCubit, bool>(
        listener: (context, state) {
          if (state) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          } else {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
          }
        },
        child: Scaffold(
          body: GestureDetector(
            onTap: (() => BlocProvider.of<MenuCubit>(context).toggleMenu()),
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: widget.media.length,
                    pageSnapping: true,
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _selectedIndex = page;
                        BlocProvider.of<MediaBloc>(context)
                            .add(FetchMedia(widget.media[_selectedIndex].id));
                      });
                    },
                    itemBuilder: (context, index) {
                      return Center(
                        child: (widget.media[index].type == 'Video')
                            ? MSVideoPlayer(
                                url: MSUrls.mediaFile(widget.media[index].id))
                            : Image.network(
                                MSUrls.mediaFile(widget.media[index].id),
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                      );
                    },
                  ),
                  BlocBuilder<MediaBloc, MediaState>(
                    builder: (context, state) {
                      return MSMenuOverlay(
                        onEditPressed: () => setState(() {
                          _showInfo = !_showInfo;
                        }),
                        onFavoritePressed: () => setState(
                          () {
                            if (state is MediaLoadedState) {
                              state.media.favorite = !state.media.favorite;
                              BlocProvider.of<ManageMediaBloc>(context)
                                  .add(UpdateMedia(state.media));
                            }
                          },
                        ),
                        onDeletePressed: () => setState(
                          () {
                            if (state is MediaLoadedState) {
                              BlocProvider.of<ManageMediaBloc>(context)
                                  .add(RemoveMedia(state.media.id));
                            }
                          },
                        ),
                        isFavorite: (state is MediaLoadedState)
                            ? state.media.favorite
                            : false,
                      );
                    },
                  ),
                  Visibility(
                    visible: _showInfo,
                    child: BlocBuilder<MediaBloc, MediaState>(
                      builder: (context, state) {
                        if (state is MediaLoadedState) {
                          return MSEditMediaDialog(state.media,
                              onClosePressed: () {
                            setState(() {
                              _showInfo = !_showInfo;
                            });
                          });
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color: Colors.black.withOpacity(0.5),
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
